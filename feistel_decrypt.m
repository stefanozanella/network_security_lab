function [ plaintext ] = feistel_decrypt(ciphertext, key, rounds, ...
                                  round_function, subkey_generation)

%FEISTEL_DECRYPT: feistel block cipher decryption algorithm
%   Receives a ciphertext as input, and decrypts it with the given key by using
%   'rounds' rounds, given the specified round function and
%   subkey_generation_algorihtm.

plaintext = feistel_encdec(ciphertext, key, rounds, round_function,
subkey_generation, 1);

