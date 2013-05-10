function [ key_pool ] = feistel_nearly_linear_cryptanalysis(filename, lu, ...
                                                            nr_rounds, enc_or_dec)
% required by Octave - otherwise hex2bi and bi2hex don't work
pkg load communications

if nargin < 4
  enc_or_dec = 0
end

kpa_pairs = textscan(fopen(filename), '%s  %s');

key = dec2hex(1, lu/4);
match_count = 0;
matching_keys = {};
% for every key in key space
for trial = 1:2^lu-1
  % try encryption of every known plaintext and see if ciphertexts matches
  % their known counterparts
  is_matching = 1;
  for pair = 1:length(kpa_pairs{1})
    plaintext = kpa_pairs{1}{pair};
    ciphertext = kpa_pairs{2}{pair};

    ciphertext_hat = feistel_encdec(plaintext, key, nr_rounds, @nearly_linear_round_function, @half_outward_shift, enc_or_dec);

    is_matching = is_matching & strcmp(ciphertext, ciphertext_hat);
  end

  if is_matching
    match_count = match_count + 1;
    matching_keys{match_count} = key;
  end

  key = dec2hex(hex2dec(key) + 1, lu/4);
end

key_pool = matching_keys;
