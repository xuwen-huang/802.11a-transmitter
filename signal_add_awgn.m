clear all
close all
%%
load('D:\matlab_prj\wifi_802.11a\vars\preamble_tx.mat');
snr = 15;
tx_signal = awgn(preamble_tx,snr,'measured');
plot(real(preamble_tx));
hold on
plot(real(tx_signal));
noise_awgn = tx_signal - preamble_tx;
%能量就是P对于时间的积分
P1 = sum(abs(preamble_tx).^2)/length(preamble_tx);
Pn = sum(abs(tx_signal - preamble_tx).^2)/length(tx_signal-preamble_tx);
SNR_10=10*log10(P1/Pn);;
save('.\vars\tx_signal.mat','tx_signal')

