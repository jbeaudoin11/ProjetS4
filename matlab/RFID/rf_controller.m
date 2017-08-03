clear
close all
clc

load('signaux.mat');

%% Vars
% signal = signal_1a;
% baud_response_valid = baud_1a;

% signal = signal_1b;
% baud_response_valid = baud_1b;

% signal = signal_2a;
% baud_response_valid = baud_2a;

signal = signal_2b;
baud_response_valid = baud_2b;

% signal = signal_3a_1;
% baud_response_valid = baud_3a_1;

% signal = signal_3a_2;
% baud_response_valid = baud_3a_2;

% signal = signal_3b_1;
% baud_response_valid = baud_3b_1;

% signal = signal_3b_2;
% baud_response_valid = baud_3b_2;

M = size(baud_response_valid, 2);

downsample_value = 64;

fs = 1/(time(2)-time(1));
fs_64 = fs/downsample_value;

max_stop_freq_fir = fs / (2*downsample_value);
fc = max_stop_freq_fir/2; % Center

LO2 = 50E3 * round((10.7E6 - fc)/50E3); % 210
LO2_sig = cos(2*pi*LO2 * time);
bandwidth = 330E3;

nb_bits = 810;

%% Lowpass
low_pass_order = 20;
b_low_pass = fir1(low_pass_order, freq2rad(max_stop_freq_fir, fs), 'low', kaiser(low_pass_order+1, 0.5));
low_pass_grpdelay = low_pass_order/2;
sig_len_low_pass = length(signal);

%% Bandpass
filters_freq_band = linspace(-bandwidth/2, bandwidth/2, 2*M+1) + fc;
bandpass_b_vec = cell(2*M, 1);
bandpass_a_vec = cell(2*M, 1);

band_pass_order = 20;
band_pass_grpdelay = band_pass_order/2;
sig_len_band_pass = length(signal)/64;
for i=1:2*M
    filter_freqs = [filters_freq_band(i), filters_freq_band(i+1)];

    b = fir1(band_pass_order, freq2rad(filter_freqs, fs_64), 'bandpass', kaiser(band_pass_order+1, 0.5));
    
    bandpass_b_vec{i} = b;
    bandpass_a_vec{i} = 1;
end

%% Moving avrg filters
short_mean_len = 12;
long_mean_len = short_mean_len * 600;

%% Simulink
received_data_by_chanel = zeros(nb_bits, M);
received_data = zeros(nb_bits);
for i=1:M    
    bandpass_b_L = bandpass_b_vec{i};
    bandpass_a_L = bandpass_a_vec{i};
    
    bandpass_b_H = bandpass_b_vec{i+M};
    bandpass_a_H = bandpass_a_vec{i+M};
    
    % Generate response for 1 chanel
    sim('rf');
    
    low_val = 2*(i-1) + 1;
    high_val = low_val+1;
    wrong_val = high_val+1;
    
    received_data(received_data == 3) = wrong_val;
    received_data(received_data == 2) = high_val;
    received_data(received_data == 1) = low_val;
    
    received_data_by_chanel(:, i) = received_data;
end
%% Baud Error Rate
wrong_bits = sum(received_data_by_chanel ~= baud_response_valid);
err = wrong_bits/nb_bits * 100






