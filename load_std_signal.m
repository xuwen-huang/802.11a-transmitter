%%
close all
clear all
clc
%%
file = '.\docs\std_wifi_tx.xlsx';
sheet = 'preamble';
[NUM,TXT,RAW]=xlsread(file,sheet);
preamble_real =  NUM(:,2:3:end);
preamble_imag =  NUM(:,3:3:end);
preamble = complex(preamble_real,preamble_imag);
preamble = preamble.';
preamble = preamble(:);
figure
plot(real(preamble),'*-')

load('.\vars\preamble_tx.mat')
preamble_tx = preamble_tx(1:320);
hold on
plot(real(preamble_tx),'^-')
legend('std','sim')

