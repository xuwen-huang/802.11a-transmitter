function ShowPowerSpectrum(data,Fs,str)
    data_fft = fft(data);
    data_power = abs(data_fft);
    data_power(1) = data_power(1)/length(data_power);
    data_power(2:end) = data_power(2:end)*2/length(data_power);
    step = Fs/length(data_power);
    x = 0:step:(Fs-step);
    x = x-Fs/2;
    data_power = fftshift(data_power);
    figure
    plot(x,data_power);
    figure_name = ['power spectrum of',str];
    title(figure_name)
end
%%
% Fs = 20e6;
% f = 1e6;
% T = 10000; % 0.01s
% t = 0:1/Fs:T/Fs;
% tx_frame = sin(2*pi*f*t);
% plot(tx_frame);
