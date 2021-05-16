clc
clear all
close all
%%
% 生成802.11a的短训练序列，并存储
%%
FS = 20e6;
FS_STD = 20e6;
LAMBDA = FS/FS_STD;
preamble_lltf_LENGTH = LAMBDA*64;
%%
L =[1;1;-1;-1;1;1;-1;1;-1;1;1;1;1;1;1;-1;-1;1;1;-1;1;-1;1;1;1;1;0;1;-1;-1;1;1;-1;1;-1;1;-1;-1;-1;-1;-1;1;1;-1;-1;1;-1;1;-1;1;1;1;1];
L = [zeros(6,1);L;zeros(5,1)]; 
padding_bits = zeros((preamble_lltf_LENGTH-64)/2,1);
L = [padding_bits;L;padding_bits];
%%
L_shift = fftshift(L);
preamble_lltf = ifft(L_shift) ;
preamble_lltf = [preamble_lltf(end-(LAMBDA*32-1):end);preamble_lltf;preamble_lltf;preamble_lltf(1)];
%%
preamble_lltf(1) = 0.5*preamble_lltf(1);
preamble_lltf(161) = 0.5*preamble_lltf(161);
%%
figure;
plot(real(preamble_lltf),'*-');
figure; 
plot(imag(preamble_lltf),'*-');
%%
save('.\vars\lltf.mat','preamble_lltf');


