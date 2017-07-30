function [ n_freq_out ] = freq2rad( f, fs )
    n_freq_out = 2*pi * f/(fs*pi);
end

