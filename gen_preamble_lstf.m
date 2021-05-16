clc
clear all
close all
%%
% 生成802.11a的长训练序列，并存储
%%
FS = 20e6;
FS_STD = 20e6;
LAMBDA = FS/FS_STD;
preamble_lstf_LENGTH = LAMBDA*64;
%%
S = sqrt(13/6)*[0;0;1+1j;0;0;0;-1-1j;0;0;0;1+1j;0;0;0;-1-1j;0;0;0;-1-1j;0;0;0;1+1j;0;0;0;0;0;0;0;-1-1j;0;0;0;-1-1j;0;0;0;1+1j;0;0;0;1+1j;0;0;0;1+1j;0;0;0;1+1j;0;0];
S = [zeros(6,1);S;zeros(5,1)]; 
padding_bits = zeros((preamble_lstf_LENGTH-64)/2,1);
S = [padding_bits;S;padding_bits];
%%
S_shift = fftshift(S);
preamble_lstf = ifft(S_shift) ;
preamble_lstf = [preamble_lstf;preamble_lstf;preamble_lstf(1:32*LAMBDA+1)];
%% 加窗
preamble_lstf(1) = 0.5*preamble_lstf(1);
preamble_lstf(161) = 0.5*preamble_lstf(161);
%%
figure;
plot(real(preamble_lstf),'*-');
figure; 
plot(imag(preamble_lstf),'*-');
%%
save('.\vars\lstf.mat','preamble_lstf');



