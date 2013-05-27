function [ output_msg ] = feistel_encdec(input_msg, key, nr_rounds, ...
                                  round_function,subkey_generation, ...
                                  decrypt)

% FEISTEL_ENCDEC: feistel block cipher encryption/decrpytion algorithm
%   The function receives as input a input_msg, and (d)encrypts it with the
%   given key, by using nr_rounds rounds, given the specified round
%   function and the subkey_generation algorithm. Encryption/Decryption
%   behaviour can be switched by setting the decrypt parameter as follows:
%   - falsy value for encryption (e.g. 0)
%   - truthy value for decrpytion (e.g. 1)
%   You can also omit the decrpyt argument, in which case the function encrypts
%   the message.

% define if we're going to encrypt or decrypt the input
if nargin > 5 && decrypt
  enc_dec_shift = nr_rounds + 1;
else
  enc_dec_shift = 0;
end

% convert the input input_msg (hexadecimal) to binary
u = hex2bi(input_msg);
% convert the input key (hexadecimal) to binary
k = hex2bi(key);

L = length(u)/2;

% initialize the inputs to the Feistel cipher with:
% 1 - the left part of the input_msg (L_0)
y = u(1:L); 
% 2 - the right part of the input_msg (R_0)
z = u(L+1:2*L); 
% initialize the subkey
ki = k;    

for i = 1:nr_rounds
    
    % generate the i-th subkey
    %ki = feval(subkey_generation,ki);
    % TODO is it correct to assume key is available through all rounds?
    ki = feval(subkey_generation, k, abs(i - enc_dec_shift));
    % apply the round function to y
    w = feval(round_function,ki,y);
    % XOR the output of the round function with z
    v = xor(w,z);
    
    if i < nr_rounds 
        % if this is not the last round, swap y and v
        z = y; y = v;
    end
    
end

% binary output of the Feistel cipher
x = [y,v];
% hexadecimal output of the Feistel cipher
output_msg =bi2hex(x);

end


