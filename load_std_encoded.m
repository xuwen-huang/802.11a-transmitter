%%
close all
clear all
clc
%%
file = '.\docs\std_wifi_encoded_data.xlsx';
sheet = 'encoded_data';
[NUM,TXT,RAW]=xlsread(file,sheet);
data = RAW(:,2:5);
% encoded_data = zeros(36*4*8);
encoded_str = '';
for ii = 1:36
    for jj = 1:4
        tmp = data{ii,jj};
        tmp = tmp(1:8);
        encoded_str = [encoded_str,tmp];
    end
end

std_encoded_data = zeros(1152,1);
for ii = 1:1152
    std_encoded_data(ii) = str2num(encoded_str(ii));
end

save('.\vars\std_encoded_data.mat','std_encoded_data');

