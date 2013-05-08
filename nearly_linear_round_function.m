function w = nearly_linear_round_function(k,y)
% NEARLY_LINEAR_ROUND_FUNCTION: nearly_linear round function for a Feistel cipher
%   The function implements a basic, nonlinear round function for a Feistel
%   cipher; given the input message block y (length L) and the current 
%   subkey (length 2*L), the output of the round function is computed as  
%   the OR between the input message y and the XOR of the bits at odd indexes
%   and the bits at even indexes in k

if length(k) ~= 2*length(y)
    error('nearly_linear_round_function: a key such that length(k) = 2*length(y) is required')
end

w = y | xor(k(1:2:end),k(2:2:end));

end
