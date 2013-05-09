% required by Octave - otherwise hex2bi and bi2hex don't work
pkg load communications


%filename = 'KPAlinear.hex';
%kpa_pairs = textscan(fopen(filename), '%s  %s');


lu = 32;
nr_rounds = 4;
pulse_input = pulse_key = '00000001';

disp('Cycling the plaintext');
key = '00000000';

B = []
for shift = 1:lu
  plaintext = bi2hex(circshift(hex2bi(pulse_input), [0, -(shift-1)]));

  b_i = hex2bi(feistel_encrypt(plaintext, key, nr_rounds, @linear_round_function, @half_outward_shift));
  B = [B; b_i];
end
disp (B);

disp('Cycling the key');
plaintext = '00000000';

A = []
for shift = 1:lu
  key = bi2hex(circshift(hex2bi(pulse_key), [0, -(shift-1)]));

  a_i = hex2bi(feistel_decrypt(plaintext, key, nr_rounds, @linear_round_function, @half_outward_shift));
  A = [A; a_i];
end
disp(A);
