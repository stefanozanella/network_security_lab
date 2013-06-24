% required by Octave - otherwise hex2bi and bi2hex don't work
pkg load communications

kpa_pairs = parse_kpa_pairs_from('KPALinear.hex');

[A, B] = impulse_response(32, 8, @feistel_encrypt, @linear_round_function, ...
        @half_outward_shift);

% Beware of transpositions
x = hex2bi(ciphertext_at(kpa_pairs, 1))';
u = hex2bi(plaintext_at(kpa_pairs, 1))';

% Solve the linear equation
k = bi2hex(gflineq(A, mod(x - (B * u), 2), 2)');

disp(sprintf('Found key: %s', k));

disp('Veryfing correctness with other known pairs');
j = 2;
key_working = 1;
while (key_working && j <= length(kpa_pairs{1}))
  x_j = ciphertext_at(kpa_pairs, j);
  u_j = plaintext_at(kpa_pairs, j);

  x_hat = feistel_encrypt(u_j, k, 8, @linear_round_function, ...
                                            @half_outward_shift);
  key_working = strcmp(x_j, x_hat);
  j = j+1;
end

if (key_working)
  disp('Got it! Key worked with all eavesdropped pairs');
else
  disp(spritnf('Something went wrong: key did not work for pair u = %s, x = %s', ...
  u_j, x_j));
end
