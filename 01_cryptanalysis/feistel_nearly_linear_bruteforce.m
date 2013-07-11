function key_pool = feistel_nearly_linear_bruteforce(filename, lu, ...
                                                            nr_rounds, enc_or_dec)
% required by Octave - otherwise hex2bi and bi2hex don't work
pkg load communications

if nargin < 4
  enc_or_dec = 0;
end

kpa_pairs = textscan(fopen(filename), '%s  %s');

left_key = right_key = dec2hex(0, lu/4/2);
match_count = 0;
key_pool = [];

Nhalf = 2^(lu/2-1);

% bruteforce separately on the two halves of the key
for left_trial = 1:Nhalf
  for right_trial = 1:Nhalf
    % try encryption of every known plaintext and see if ciphertexts matches
    % their known counterparts
    is_matching = 1;
  
    key = strcat(left_key, right_key);
  
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
  
    right_key = dec2hex(hex2dec(right_key) + 1, lu/4/2);
  end

  right_key = dec2hex(0, lu/4/2);
  left_key = dec2hex(hex2dec(left_key) + 1, lu/4/2);
end

for j = 1:match_count
  key_1 = matching_keys{j};
  key_2 = bi2hex(~hex2bi(key_1));
  key_3 = strcat(substr(key_1, 1, length(key_1)/2), substr(key_2, length(key_2)/2, length(key_2)/2));
  key_4 = strcat(substr(key_2, 1, length(key_2)/2), substr(key_1, length(key_1)/2, length(key_1)/2));
  key_pool = [ key_pool; key_1; key_2; key_3; key_4 ];
end
