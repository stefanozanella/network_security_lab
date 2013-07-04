function [ A, B ] = impulse_response(lu, nr_rounds, feistel_cipher, ...
                        round_function, subkey_gen_function)
% PULSE_RESPONSE: finds the pulse response of the Feistel cipher represented by
% the feistel_cipher, round_function, subkey_gen_function parameters. The pulse
% response is given as the pair of matrices A, B, which are meant to satisfy
% the equation x = Ak + Bu, where k is the key, u is the plaintext and x in the
% ciphertext.

A = [];
B = [];
zero  = bi2hex(zeros(1, lu));
impulse = bi2hex([ zeros(1, lu-1) 1 ]);

for shift = 1:lu
  hex_impulse = bi2hex(circshift(hex2bi(impulse), [0, -(shift-1)]));

  a_i = hex2bi(feistel_encrypt(zero, hex_impulse, nr_rounds, @linear_round_function, @half_outward_shift));
  b_i = hex2bi(feistel_encrypt(hex_impulse, zero, nr_rounds, @linear_round_function, @half_outward_shift));

  A = [a_i' A];
  B = [b_i' B];
end

end
