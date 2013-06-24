function [ ciphertext ] = feistel_encrypt(plaintext, key, rounds, ...
                                  round_function, subkey_generation)

%FEISTEL_ENCRYPT: feistel block cipher encryption algorithm
%   Receives a plaintext as input, and encrypts it with the given key by using
%   'rounds' rounds, given the specified round function and
%   subkey_generation_algorihtm.

ciphertext = feistel_encdec(plaintext, key, rounds, round_function, subkey_generation);

