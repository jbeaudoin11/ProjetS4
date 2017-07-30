clc
clear
close all

load('signaux.mat');

%% vars
M = 1;
sig = signal_1a;
% f0 = 10.7E6;
% sig = sin(2*pi*(f0-165E3) * time) + sin(2*pi*(f0+165E3) * time);
sig_len = length(sig);

seg_len = 64;
% seg_index = 0;
% seg_indexes = (1:seg_len) + seg_index*seg_len;

fs = 1/(time(2)-time(1));
fs_bins_len = sig_len;
fs_bins = linspace(0, fs, fs_bins_len);

nb_bits = length(baud_1a);
nb_samples_per_bit = sig_len/nb_bits;
downsample_value = nb_samples_per_bit/seg_len;

max_stop_freq_fir = fs / (2*downsample_value);

% (max_stop_freq_fir/2 + 10.7E6)/50E3 = 235.12
LO2 = 50E3 * 235;
bandwidth = 330E3;

%% Clock LO2 (frequencies shift)
figure
subplot(2, 1, 1)
plot(fs_bins, abs(fft(sig, fs_bins_len)));
xlim([0, fs]);

clock_LO2 = cos(2*pi*LO2 * time);
sig = clock_LO2 .* sig;

subplot(2, 1, 2)
plot(fs_bins, abs(fft(sig, fs_bins_len)));
hold on
    plot([LO2, LO2], [0, 10E3])
hold off
xlim([0, fs]);

%% RIF
b = fir1(20, 0.0814, 'low', kaiser(21, 0.5));
sig = filter(b, 1, sig);

%% downsample N = 64
sig = downsample(sig, downsample_value);
sig_len = length(sig);

fs = max_stop_freq_fir;
fs_bins_len = sig_len;
fs_bins = linspace(0, fs, fs_bins_len);

fc = fs/4; % Center

figure
plot(fs_bins, abs(fft(sig, fs_bins_len)));
xlim([0, fs]);

%% 12 Bandpass
filters_freq_band = freq2rad(linspace(fc - bandwidth/2, fc + bandwidth/2, 2*M+1), fs);

filtered_segments = zeros(2*M, seg_len, nb_bits);
filter_order = 20;
filter_len = filter_order+1;
filters_b = zeros(2*M, filter_len);

for i=1:2*M
    b = fir1(filter_order, [filters_freq_band(i), filters_freq_band(i+1)], 'bandpass', kaiser(filter_len, 0.5), 'noscale');
    
    for seg_index=0:nb_bits-1
        seg_indexes = (1:seg_len) + seg_index*seg_len;
        seg = sig(seg_indexes);
        filtered_segments(i, :, seg_index+1) = filter(b, 1, seg)';
    end
end



%% 12 Demod
filter_fast_len = seg_len;
filter_fast = ones(1, filter_fast_len)/filter_fast_len;
nb_seg_filter_slow = 10;
filter_slow_len = seg_len * nb_seg_filter_slow;
filter_slow = ones(1, filter_fast_len)/filter_slow_len;

binary_segments = false(2*M, seg_len, nb_bits);

figure
for i=2:2*M

    for seg_index=1:nb_bits
        seg_fast = abs(filtered_segments(i, :, seg_index));
        
        if seg_index < nb_seg_filter_slow
            % Add zeros when we dont have any signal
            seg_slow = cat(3, zeros(1, seg_len, nb_seg_filter_slow-seg_index), abs(filtered_segments(i, :, 1:seg_index)));
        else
            seg_slow = abs(filtered_segments(i, :, seg_index-nb_seg_filter_slow+1:seg_index));
        end
        seg_slow = reshape(seg_slow, 1, seg_len*nb_seg_filter_slow);
        
        seg_fast = conv(seg_fast, filter_fast);
        seg_slow = conv(seg_slow, filter_slow);
        
        seg_fast = seg_fast(1:end-length(filter_fast)+1);
        seg_slow = seg_slow(1:end-length(filter_slow)+1);
        
        subplot(2, 1, 1)
        plot(seg_fast);
        subplot(2, 1, 2)
        plot(seg_slow);
        
%         binary_segments(i, :, seg_index) = 
%         filtered_segments(i, :, seg_index) = filter(b, 1, seg)';
    end
end






















