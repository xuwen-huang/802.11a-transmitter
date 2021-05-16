clc
clear all
close all
%%
% 生成802.11a的sinal调制序列，并存储
% rate = 1011(MOD=16QAM:R=3/4)
% length = 100B
% 
%%
FS = 20e6;
FS_STD = 20e6;
LAMBDA = FS/FS_STD;
%%
RATE = 11;
Reserved_1bit = 0;
LENGTH = 100;
tmp = dec2bin(LENGTH,12);
tmp = tmp(end:-1:1);
SIGNAL = [dec2bin(RATE,4),dec2bin(Reserved_1bit,1),tmp];
tmp = sum(str2num(SIGNAL(:)));
% 偶校验 even parity
Parity = rem(tmp,2);
SIGNAL = [SIGNAL,dec2bin(Parity,1)];
SIGNAL_TAIL = 0;
SIGNAL = [SIGNAL,dec2bin(SIGNAL_TAIL,6)];
%% bcc
SIGNAL = ['000000',SIGNAL] ;
A = zeros(24,0);
B = zeros(24,0);
for ii = 1:24;
    A(ii) = rem(str2num(SIGNAL(ii)) + str2num(SIGNAL(ii+1)) + str2num(SIGNAL(ii+3)) + str2num(SIGNAL(ii+4)) + str2num(SIGNAL(ii+6)),2);
    B(ii) = rem(str2num(SIGNAL(ii)) + str2num(SIGNAL(ii+3)) + str2num(SIGNAL(ii+4)) + str2num(SIGNAL(ii+5)) + str2num(SIGNAL(ii+6)),2);
end
encode_data = [A;B];
encode_data = encode_data(:);
tmp = reshape(encode_data,[16,3]);
%% interleaver
N_CBPS = 48;
N_BPSC = 1;

% 第一次交织
k = 0:N_CBPS-1;
i = (N_CBPS/16)*mod(k,16) + floor(k/16);
encode_data_first = zeros(1,48);
encode_data_second = zeros(1,48);
for ii = 1:48
    encode_data_first(i(ii)+1) = encode_data(ii);
end
% 第二次交织
i = 0:N_CBPS-1;
s = max(N_BPSC/2,1);
j = s*floor(i/s) + mod((i + N_CBPS - floor(16*i/N_CBPS)),s);
for jj = 1:48
    encode_data_second(j(jj)+1) = encode_data_first(jj);
end

encode_data_second = encode_data_second.*2-1;
%% 插入导频
pilot = [1,1,1,-1];
fft_src = [zeros(1,6),encode_data_second(1:5),...,
           pilot(1),encode_data_second(6:18),...,
           pilot(2),encode_data_second(19:24),...,
           0,encode_data_second(25:30),...,
           pilot(3),encode_data_second(31:43),...,
           pilot(4),encode_data_second(44:48),...,
           zeros(1,5)];

%%
ifft_src = ifftshift(fft_src);
signal_ifft = ifft(ifft_src) ;
signal_ifft = [signal_ifft(49:64),signal_ifft,signal_ifft(1)];
signal_ifft = signal_ifft.';
signal_ifft(1) = 0.5*signal_ifft(1);
signal_ifft(81) = 0.5*signal_ifft(81);
%%
save('.\vars\signal.mat','signal_ifft');

