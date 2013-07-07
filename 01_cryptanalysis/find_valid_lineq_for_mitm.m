function [A, b, F] = find_valid_lineq_for_mitm(u,x)

% FIND_VALID_LINEQ_FOR_MITM: Given a plaintext u and a corresponding ciphertext
% x, try to reverse the 2 round Feistel cipher that produced them and find
% valid linear equations to be used to infer key bits from the known pairs.
%
% Basically, if the encryptor/decryptor is a 2 round nearly linear Feistel
% cipher, it's possible to calculate uR ^ xL and uL ^ xR and
% compare them with F(uL, k1) and F(xL, k2) respectively.
% Each bitwise comparison can give some certainty about XORs of pairs of key
% bits, thus allowing for construction of a system of linear equations over
% GF(2), solvable in principle with gflineq().
%
% You can run this function for many known pairs of x and u; just concatenate
% columns of resulting A and b together to obtain a more vinculated system
% (with more possibilities of obtaining a complete solution).
%
% NOTE: If the Feistel cipher performs more than 2 rounds, this function is
% completely useless sine you can't have a direct relationship between known
% parts of the plain/ciphertexts and the output of the round function.

L = length(u);

% Split plaintext and ciphertext in two halves
uL = u(1:L/2);
uR = u(L/2+1:end);

xL = x(1:L/2);
xR = x(L/2+1:end);

% Calculate notable values for subsequent inference
% Known equations are:
%   xL ^ uR = F(uL, k1)
%   xR ^ uL = F(xL, k2)
F_k1_uL = xor(uR, xL);
F_k2_xL = xor(uL, xR);

% Now, let's expand the value of F:
%   F_k1_uL = uL | (k1_j ^ k1_j+1)
%   F_k2_xL = xL | (k2_j ^ k2_j+1)
% Here, if we compare the values of the bit in position j of F_k1_uL and bit in
% position j of uL we can infer the following :
%   * if they're both 1, we can't say anything about the value of the xor
%   * if bit of uL is 0, then the xor must equate to the value of the bit of F_k1_uL
%   * if bit of u_l is 1 and bit of h1 is 0, then there must be something broken
%     since boolean algebra doesn't allow this situation :-)
% So, we can gather a list of pair of key bits that can be put in relation.
% Specifically, for every bit of the plain or ciphertext set at 0, we can build
% an equation on a pair of key bits in the form k_b1 XOR k_b2 = {0|1}. To know
% the index of the key bits for which we can infer information, we can use the
% subkey generation function over an array of indexes (instead of the key
% itself) and split them the same way the round function does, actually
% building a matrix where columns contain the indexes of key bit pairs
% contributing to a single bit of the round function's output. Then we perform
% an element wise multiplication, so the output will contain just the indexes
% for which we can build exact equations.
% Finally, we will use these two matrices (one for F_k1_uL and one for F_k2_xL)
% to build a matrix of solvable equations over GF(2).
good_indexes_k1 = [half_outward_shift(1:32, 1)(1:2:end) .* ~uL; half_outward_shift(1:32, 1)(2:2:end) .* ~uL];
good_indexes_k2 = [half_outward_shift(1:32, 2)(1:2:end) .* ~xL; half_outward_shift(1:32, 2)(2:2:end) .* ~xL];

bad_indexes_k1 = [half_outward_shift(1:32, 1)(1:2:end) .* uL; half_outward_shift(1:32, 1)(2:2:end) .* uL];
bad_indexes_k2 = [half_outward_shift(1:32, 2)(1:2:end) .* xL; half_outward_shift(1:32, 2)(2:2:end) .* xL];

A = b = F = [];

for j = 1:(L/2)
  eq = zeros(1,L);

  if (good_indexes_k1(1,j))
    eq(1,good_indexes_k1(1,j)) = 1;
    eq(1,good_indexes_k1(2,j)) = 1;

    A = [A ; eq];
    b = [b ; F_k1_uL(1,j)];
  else
    eq(1,bad_indexes_k1(1,j)) = 1;
    eq(1,bad_indexes_k1(2,j)) = 1;

    F = [F; eq];
  end
end

for j = 1:(L/2)
  eq = zeros(1,L);

  if (good_indexes_k2(1,j))
    eq(1,good_indexes_k2(1,j)) = 1;
    eq(1,good_indexes_k2(2,j)) = 1;

    A = [A ; eq];
    b = [b ; F_k2_xL(1,j)];
  else
    eq(1,bad_indexes_k2(1,j)) = 1;
    eq(1,bad_indexes_k2(2,j)) = 1;

    F = [F; eq];
  end
end
