clc
clear
close all

%% vars
M = 1;
% M = 2;
% M = 3;

fs = 4224000;
fc = fs/4;

bandwidth = 330E3;
half_f_bandwidth = 330E3/(4*M);

fir_order = 12;

butter_order = 1;
cheby1_order = 1;
ellip_order = 1;

%% Bandpass test
filters_freq_band = linspace(-bandwidth/2, bandwidth/2, 2*M+1) + fc;
freq_offset = 0.1 * half_f_bandwidth;

figure
for i=1:2*M
    filters_freqs = [filters_freq_band(i)+freq_offset, filters_freq_band(i+1)-freq_offset]
    freq2rad(filters_freqs, fs) * pi
    
    b1 = fir1(fir_order, freq2rad(filters_freqs, fs), 'bandpass', ones(fir_order+1, 1));
    [b2, a2] = butter(butter_order, freq2rad(filters_freqs, fs),  'bandpass');
    [b3, a3] = cheby1(cheby1_order, 1, freq2rad(filters_freqs, fs),  'bandpass');
    [b4, a4] = ellip(ellip_order, 1, 80, freq2rad(filters_freqs, fs),  'bandpass');
    b5 = [0.0355237633148164,-0.355237633148164];
    a5 = [1,-0.325413535126088,0.64];
    
%     freqz(b5, a5);

    [amp1, f] = freqz(b1, 1, 2048, fs);
    [amp2] = freqz(b2, a2, 2048, fs);
    [amp3] = freqz(b3, a3, 2048, fs);
    [amp4] = freqz(b4, a4, 2048, fs);
    [amp5] = freqz(b5, a5, 2048, fs);
    
    fc_filter = filters_freq_band(i) + (filters_freq_band(i+1) - filters_freq_band(i))/2;
    
    subplot(5, 1, 1)
    hold on
        plot(f, abs(amp1));
        plot([fc_filter, fc_filter], [0, max(abs(amp1))])
        xlim([0, fs/2])
        title(['FIR     [ordre = ', num2str(fir_order), ']    [grpdelay  = ', num2str(max(grpdelay(b1, 1))), ']']);
    
    subplot(5, 1, 2)
    hold on
        plot(f, abs(amp2));
        plot([fc_filter, fc_filter], [0, max(abs(amp2))])
        xlim([0, fs/2])
        title(['Butterworth     [ordre = ', num2str(butter_order), ']    [grpdelay  = ', num2str(max(grpdelay(b2, a2))), ']']);
    
    subplot(5, 1, 3)
    hold on
        plot(f, abs(amp3))
        plot([fc_filter, fc_filter], [0, max(abs(amp3))])
        xlim([0, fs/2])
        title(['Chebyshev1     [ordre = ', num2str(cheby1_order), ']    [grpdelay  = ', num2str(max(grpdelay(b3, a3))), ']']);
    
    subplot(5, 1, 4)
    hold on
        plot(f, abs(amp4))
        plot([fc_filter, fc_filter], [0, max(abs(amp4))])
        xlim([0, fs/2])
        title(['Elliptic     [ordre = ', num2str(ellip_order), ']    [grpdelay  = ', num2str(max(grpdelay(b4, a4))), ']']);    
    
    subplot(5, 1, 5)
    hold on
        plot(f, abs(amp5))
        plot([fc_filter, fc_filter], [0, max(abs(amp5))])
        xlim([0, fs/2])
        title(['Custom     [ordre = ', num2str(2), ']    [grpdelay  = ', num2str(max(grpdelay(b5, a5))), ']']);    


end
hold off



