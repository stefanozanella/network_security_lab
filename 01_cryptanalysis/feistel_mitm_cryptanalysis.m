function [ A_redux, b_redux, freedom ] = feistel_mitm_cryptanalysis(kpa_pairs)
  A = b = F = [];
  for j=1:length(kpa_pairs{1})
    [ Aj, bj, Fj ] = find_valid_lineq_for_mitm(...
                              hex2bi(kpa_pairs{1}{j}),...
                              hex2bi(kpa_pairs{2}{j})); 
    A = [A; Aj];
    b = [b; bj];
    F = [F; Fj];
  end

  % Just reduce A to ist minimum size.
  A_redux = [];
  b_redux = [];
  for p=1:length(A)
    if (~ismember(A(p,:), A_redux, 'rows'))
      A_redux = [ A_redux; A(p,:) ];
      b_redux = [ b_redux; b(p,:) ];
    end
  end

  % Find collisions in A, so to keep only rows of F that truly has no certain
  % answer. Also, avoid inserting duplicated rows in `freedom`.
  freedom = [];
  collisions = ismember(F, A_redux, 'rows');
  for m=1:length(F)
    if (~(collisions(m) | ismember(F(m,:), freedom, 'rows')))
      freedom = [ freedom; F(m,:) ];
    end
  end
end
