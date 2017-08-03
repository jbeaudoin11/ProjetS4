clear
close all
clc

load('signaux.mat');

%% Vars
M = 1;

sig = timeseries(signal_1a, time);
sig_comp = timeseries(baud_1a, linspace(0, time(end), length(baud_1a)));

fs = 1/(time(2)-time(1));

downsample_value = 64;

max_stop_freq_fir = fs / (2*downsample_value);
fc = max_stop_freq_fir/2; % Center

LO2 = 50E3 * round((10.7E6 - fc)/50E3); % 210
LO2_sig = [time, cos(2*pi*LO2 * time)];
bandwidth = 330E3;

%% Lowpass
b_low_pass = fir1(20, freq2rad(max_stop_freq_fir, fs), 'low', kaiser(21, 0.5));

%% Bandpass
filters_freq_band = linspace(-bandwidth/2, bandwidth/2, 2*M+1) + fc;
bandpass_b_vec = cell(2*M, 1);
bandpass_a_vec = cell(2*M, 1);

freq_offset = 50E3;
for i=1:2*M
    filter_freqs = [filters_freq_band(i)+freq_offset, filters_freq_band(i+1)-freq_offset];
    
    fc_filter = filters_freq_band(i) + (filters_freq_band(i+1) - filters_freq_band(i))/2;
    fc_filter_norm_pi = freq2rad(fc_filter, fs) * pi;
    
    [b, a] = zp2tf([-0.75; 0.75], [0.85*exp(1i*fc_filter_norm_pi); 0.85*exp(-1i*fc_filter_norm_pi)], 0.177);
    
%     b = fir1(24, freq2rad(filter_freqs, fs), 'bandpass', kaiser(25, 0.5));
    a = 1;
    
    bandpass_b_vec{i} = b;
    bandpass_a_vec{i} = a;
end

%% Moving avrg filters
seg_len = 12;
filter_fast_len = seg_len;
filter_fast = ones(1, filter_fast_len)/filter_fast_len;

filter_slow_len = filter_fast_len * 8;
filter_slow = ones(1, filter_slow_len)/filter_slow_len;

%% Simulink
sim('rf');

%% Baud Error Rate

% figure
% subplot(2, 1, 1)
% plot(sig_comp)
% xlim([0, time(end)])
% subplot(2, 1, 2)
% plot(low)
% xlim([0, time(end)])

% low = low.Data(3:end);
low = low.Data(2:end);
baud_1a(baud_1a == 2) = 0;

wrong_bits = sum(low ~= baud_1a);
err = wrong_bits/length(low) * 100






