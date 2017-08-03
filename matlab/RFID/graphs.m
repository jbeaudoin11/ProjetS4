clc
clear
close all

%% Flags
IS_SAVE_FIG = true;

%% vars
fs = 50688000;

fs_64 = 4224000;
fc_64 = fs_64/4;

bandwidth = 330E3;
downsample_value = 64;

%% Graphs

%% LowPass
max_stop_freq_fir = fs / (2*downsample_value);
fc = max_stop_freq_fir/2; % Center after downsample

LO2 = 50E3 * round((10.7E6 - fc)/50E3); % 210

low_pass_order = 20;
b_low_pass = fir1(low_pass_order, freq2rad(max_stop_freq_fir, fs), 'low', kaiser(low_pass_order+1, 0.5));
low_pass_grpdelay = low_pass_order/2;

low_pass_fig = figure;
[amp, f] = freqz(b_low_pass, 1, 2048, fs);
plot(f, abs(amp))
hold on
    plot([max_stop_freq_fir, max_stop_freq_fir], [0, 1.05]);
hold off
xlim([0, fs/2]);
ylim([0, 1.05]);
title(['Pass bas     [ordre = ', num2str(low_pass_order), ']    [grpdelay  = ', num2str(low_pass_grpdelay), ']']);


%% BandPass
band_pass_order = 20;

band_pass_fig = figure;
for M=1:3
    filters_freq_band = linspace(-bandwidth/2, bandwidth/2, 2*M+1) + fc_64;

    for i=1:2*M
        filter_freqs = [filters_freq_band(i), filters_freq_band(i+1)];
        fc_filter = filters_freq_band(i) + (filters_freq_band(i+1) - filters_freq_band(i))/2;
        
        b = fir1(band_pass_order, freq2rad(filter_freqs, fs_64), 'bandpass', kaiser(band_pass_order+1, 0.5));
        [amp, f] = freqz(b, 1, 2048, fs_64);

        subplot(3, 1, M)
        hold on
            plot(f, abs(amp));
            plot([fc_filter, fc_filter], [0, max(abs(amp))])
            xlim([0, fs_64/2])
            ylim([0, 1.05]);
            title(['Passe bande     [M = ', num2str(M), ']     [ordre = ', num2str(band_pass_order), ']    [grpdelay  = ', num2str(band_pass_order/2), ']']);
    end
    
end
hold off

%% save figures
if IS_SAVE_FIG
    simple_fig_save(low_pass_fig, 'graphs/low_pass.png');
    simple_fig_save(band_pass_fig, 'graphs/band_pass.png');
end











