clear
clc

load('signaux.mat');
fs = 1/(time(2)-time(1));

downsample_value = 64;

max_stop_freq_fir = fs / (2*downsample_value);
fc = max_stop_freq_fir/2; % Center

LO2 = 50E3 * round((10.7E6 - fc)/50E3); % 210
bandwidth = 330E3;

b_low_pass = fir1(20, 0.0814, 'low', kaiser(21, 0.5));

%% Bandpass
filters_freq_band = linspace(-bandwidth/2, bandwidth/2, 2*M+1) + fc;
bandpass_b_a_vec = cell(2*M, 2);


freq_offset = 50E3;

for i=1:2*M
    filter_freqs = [filters_freq_band(i)+freq_offset, filters_freq_band(i+1)-freq_offset];
    
    fc_filter = filters_freq_band(i) + (filters_freq_band(i+1) - filters_freq_band(i))/2;
    fc_filter_norm_pi = freq2rad(fc_filter, fs) * pi;
    
    [b, a] = zp2tf([-0.75; 0.75], [0.85*exp(1i*fc_filter_norm_pi); 0.85*exp(-1i*fc_filter_norm_pi)], 0.177);
    bandpass_b_a_vec(i) = {b, a};
end