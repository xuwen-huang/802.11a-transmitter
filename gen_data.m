clc
clear all
close all
%% 加载数据源
% file = '.\docs\std_wifi_tx.xlsx';
% sheet = 'tx_src_data';
% [NUM,TXT,RAW]=xlsread(file,sheet);
% raw_bit = '';
% for ii = 1:36
%     raw_bit_2 = TXT{ii,2};raw_bit_2 = raw_bit_2(1:8);
%     raw_bit_3 = TXT{ii,3};raw_bit_3 = raw_bit_3(1:8);
%     raw_bit_4 = TXT{ii,4};raw_bit_4 = raw_bit_4(1:8);
%     raw_bit_tmp = [raw_bit_2,raw_bit_3,raw_bit_4];
%     raw_bit = [raw_bit,raw_bit_tmp];
% end
load('.\vars\raw_bit.mat')
%% 生成加扰序列
scramble_seed = [1,0,1,1,1,0,1];
scramble_series = zeros(127,1);
for ii = 1:127
    tmp = rem(scramble_seed(1) + scramble_seed(4),2);
    scramble_seed = [scramble_seed(2:7),tmp];
    scramble_series(ii) = tmp;
end
%% 加扰
scramble_data = zeros(length(raw_bit),1);
N_tmp = ceil(length(raw_bit)/127);
scramble_series = repmat(scramble_series,1,N_tmp);
scramble_series = scramble_series(:);
scramble_series = scramble_series(1:length(raw_bit));
for ii = 1:length(raw_bit)
    tmp = rem(scramble_series(ii) + str2num(raw_bit(ii)),2);
    scramble_data(ii) = tmp;
end
%% 编码+打孔
raw_bit = scramble_data';
A = zeros(length(raw_bit),1);
B = zeros(length(raw_bit),1);
raw_bit = [0,0,0,0,0,0,raw_bit] ;
for ii = 1:length(B);
    A(ii) = rem(raw_bit(ii) + raw_bit(ii+1) + raw_bit(ii+3) + raw_bit(ii+4) + raw_bit(ii+6),2);
    B(ii) = rem(raw_bit(ii) + raw_bit(ii+3) + raw_bit(ii+4) + raw_bit(ii+5) + raw_bit(ii+6),2);
end
encode_data = [A,B];
encode_data = encode_data';
encode_data = encode_data(:);
encode_data = reshape(encode_data,[6,1728/6]);
tmp1 = encode_data(1:3,:);
tmp2 = encode_data(6,:);
encode_data = [tmp1;tmp2];
encode_data = encode_data(:);
%% 交织
N_CBPS = 48*4;
N_BPSC = 4;
SYM_NUM = length(encode_data)/N_CBPS;
encode_data = reshape(encode_data,[N_CBPS,length(encode_data)/192]);
interleaved_data = zeros(N_CBPS,SYM_NUM);
for ii = 1:SYM_NUM
    tmp1 = encode_data(:,ii);
    tmp2 = interleaver_802p11a(tmp1, N_CBPS,N_BPSC);
    tmp2 = tmp2';
    interleaved_data(:,ii) = tmp2;
end
%% map-16QAM
[m,n] = size((interleaved_data));
sym_tmp = reshape(interleaved_data,[4,m*n/4]);
I = 2*sym_tmp(1,:)+sym_tmp(2,:) + 1;
Q = 2*sym_tmp(3,:)+sym_tmp(4,:) + 1;
gray_table = [-3,-1,3,1];
I = gray_table(I(:));
Q = gray_table(Q(:));
symbol = (I + 1j*Q)./sqrt(10);
symbol = symbol.';
%%  12,26,40,54
pilot = [1;1;1;-1];
pilot_parity = [1,1,1,1,-1,-1];
pilot = repmat(pilot,[1,6]);
% 根据随机序列更改导频极性
for ii=1:6
    if(pilot_parity(ii)==-1)
        pilot(:,ii) = -pilot(:,ii);
    end
end
% pilot = pilot./sqrt(10);  % 导频不用乘功率因子

symbol = reshape(symbol,[48,6]);
pre_pad = zeros(6,6);
middle_pad = zeros(1,6);
post_pad = zeros(5,6);
symbol = [pre_pad;symbol;post_pad];
symbol = [symbol(1:11,:);pilot(1,:);symbol(12:24,:);pilot(2,:);symbol(25:30,:);middle_pad; ... 
          symbol(31:36,:);pilot(3,:);symbol(37:49,:);pilot(4,:);symbol(50:end,:)];

%%
data_tx = zeros(81,6);
for ii = 1:6
    tmp = symbol(:,ii);
    tmp = fftshift(tmp);
    tmp = ifft(tmp);
    tmp = [tmp(49:64);tmp;tmp(1)];
    data_tx(:,ii) = tmp;
end
data_tx(1,:) = 0.5*data_tx(1,:);
data_tx(81,:) = 0.5*data_tx(81,:);
data_tx(1,2:end) = data_tx(1,2:end) + data_tx(end,1:end-1);
data_tx_add_window = zeros(64*6+1,1);
data_tx_add_window(1:80)    = data_tx(1:80,1);
data_tx_add_window(81:160)  = data_tx(1:80,2);
data_tx_add_window(161:240) = data_tx(1:80,3);
data_tx_add_window(241:320) = data_tx(1:80,4);
data_tx_add_window(321:400) = data_tx(1:80,5);
data_tx_add_window(401:481) = data_tx(1:81,6);
data = data_tx_add_window;
save('.\vars\data.mat','data');









