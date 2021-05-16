function [ encode_data_second ] = interleaver_802p11a( encode_data, N_CBPS,N_BPSC)
%INTERLEAVER_802P11A 此处显示有关此函数的摘要
%   此处显示详细说明
    % 第一次交织
    k = 0:N_CBPS-1;
    i = (N_CBPS/16)*mod(k,16) + floor(k/16);
    encode_data_first = zeros(1,N_CBPS);
    encode_data_second = zeros(1,N_CBPS);
    for ii = 1:N_CBPS
        encode_data_first(i(ii)+1) = encode_data(ii);
    end
    % 第二次交织
    i = 0:N_CBPS-1;
    s = max(N_BPSC/2,1);
    j = s*floor(i/s) + mod((i + N_CBPS - floor(16*i/N_CBPS)),s);
    for jj = 1:N_CBPS
        encode_data_second(j(jj)+1) = encode_data_first(jj);
    end
%     encode_data_second = encode_data_second.*2-1;
end

