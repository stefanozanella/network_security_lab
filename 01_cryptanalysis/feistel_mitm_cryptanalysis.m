function keys = feistel_mitm_cryptanalysis(kpa_pairs)
  A = b = F = keys = [];
  for j=1:length(kpa_pairs{1})
    [ Aj, bj, Fj ] = find_valid_lineq_for_mitm(...
                          hex2bi(kpa_pairs{1}{j}),...
                          hex2bi(kpa_pairs{2}{j})); 
    A = [A; Aj];
    b = [b; bj];
    F = [F; Fj];
  end

  % How many useful equations did we found?
  disp("Found"), disp(rows(A)), disp("equations over key bits");

  % What rank is the matrix?
  disp("Key bits relationship matrix has rank"), disp(rank(A));

  % Now we need to carve out of F just the rows that aren't in A, which are the
  % true undetermined equations
  free_eqs = setdiff(F, A, 'rows');

  % This is the key we can retrieve directly from solving the system, but we
  % will obtain it by performing the following step.
  %key = gflineq(A, b, 2);
  %keys = [ keys;
  %  bi2hex(key');
  %  bi2hex(~key');
  %  bi2hex([key(1:length(key)/2);~key(length(key)/2+1:end)]');
  %  bi2hex([~key(1:length(key)/2);key(length(key)/2+1:end)]');
  %];

  % Instead, these are the keys we can retrieve by forcing the constants of the
  % free equations.
  % This step corresponds to a bruteforce over a search space of rows(free_eqs)
  % bits.
  for j = 1:2^rows(free_eqs)
    key = gflineq([A;free_eqs], [b; de2bi(j,rows(free_eqs),'left-msb')'], 2);
    if (any(key))
      keys = [ keys;
        bi2hex(key');
        bi2hex(~key');
        bi2hex([key(1:length(key)/2);~key(length(key)/2+1:end)]');
        bi2hex([~key(1:length(key)/2);key(length(key)/2+1:end)]');
      ];
    end
  end
end
