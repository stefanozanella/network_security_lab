function w = linear_round_function(k,y)
% LINEAR_ROUND_FUNCTION: linear round function for a Feistel cipher
%   The function implements a basic, linear round function for a Feistel
%   cipher; given the input message block y (length L) and the current 
%   subkey (length 2*L), the output of the round function is computed as a 
%   three-term XOR, between the input message y, the bits at odd indexes
%   in k and the bits at even indexes of k

if length(k) ~= 2*length(y)
    error('linear_round_function: a key such that length(k) = 2*length(y) is required')
end

w = xor(xor(y,k(1:2:end)),k(2:2:end));

end
