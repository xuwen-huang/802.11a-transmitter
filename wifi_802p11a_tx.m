clear all
close all
%%
load('.\vars\lstf.mat')
load('.\vars\lltf.mat')
%% µ¼Æµ
preamble_tx = [preamble_lstf(1:160);preamble_lstf(161)+preamble_lltf(1);preamble_lltf(2:161)];
% figure;plot(real(preamble_tx),'*-');
% figure;plot(imag(preamble_tx),'*-');
%% µ¼Æµ+signal
load('.\vars\signal.mat')
frame_prefix = [preamble_tx(1:end-1);preamble_tx(end)+signal_ifft(1);signal_ifft(2:81)];
% figure;plot(real(frame_prefix),'*-');
% figure;plot(imag(frame_prefix),'*-');
%% µ¼Æµ+signal+data
load('.\vars\data.mat')
tx_frame = [frame_prefix(1:end-1);frame_prefix(end)+data(1);data(2:end)];
figure;plot(real(tx_frame),'*-');
figure;plot(imag(tx_frame),'*-');
%%
ShowPowerSpectrum(tx_frame,20e6,'802.11a tx frame')








