function [ y ] = hex2bi( x )
%HEX2BI hexadecimal to binary conversion 
%   y = hex2bi(x) turns a hexadecimal string y of length Linto 
%   a row vector x of 4*L binary values 
y = de2bi(hex2dec(x),length(x)*4,2,'left-msb');
end

