% PARAMETERS

lk = 32;    % key length (in bits)
lu = 32;    % message length (in bits)
nKPA = 5;   % number of known (plaintext,ciphertext) pairs

% generate an hexadecimal random key
key = dec2hex(randi([0,2^lk-1],1,1));
% generate nKPA random hexadecimal plaintexts
plaintext_vector = dec2hex(randi([0,2^lu-1],nKPA,1));
% initialize the corresponding ciphertexts to NaN
ciphertext_vector = nan(size(plaintext_vector));

for i = 1:nKPA
    % choose the i-th plaintext...
    plaintext = plaintext_vector(i,:);
    % ...encrypt it with the random key
    ciphertext = feistel_encrypt(plaintext, key, 4, ...
                                 @linear_round_function, ...
                                 @subkey_cyclic_rotation);
    % store the i-th ciphertext into the ciphertexts vector
    ciphertext_vector(i,:) = ciphertext;
end

% convert the ciphertext vector to char
ciphertext_vector = char(ciphertext_vector);