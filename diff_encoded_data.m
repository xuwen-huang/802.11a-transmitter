close all
clear all
%%
load('D:\matlab_prj\wifi_802.11a\vars\std_encoded_data.mat')
load('D:\matlab_prj\wifi_802.11a\vars\encoded_data.mat')

plot(std_encoded_data,'*-')
hold on
plot(encode_data,'^-')
error = std_encoded_data - encode_data;

if(sum(error)==0)
    disp('BCC encoder OK£¡');
else
    disp('#$%^&*()_+');
end
    
    



