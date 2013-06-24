function [ y ] = bi2hex( x )
%BI2HEX binary to hexadecimal conversion 
%   y = bi2hex(x) turns a row vector x of 4*L binary values into a 
%   hexadecimal string y of length L

y = dec2hex(bi2de(x,'left-msb'),ceil(length(x)/4));

end

