function [A, b] = find_valid_lineq_for_mitm(u,x)

% FIND_VALID_LINEQ_FOR_MITM: Given a plaintext u and a corresponding ciphertext
% x, try to reverse the 2 round Feistel cipher that produced them and find
% valid linear equations to be used to infer key bits from the known pairs.
%
% Basically, if the encryptor/decryptor is a 2 round nearly linear Feistel
% cipher, it's possible to calculate u_r ^ x_l and u_l ^ x_r and
% compare them with F(u_l, k1) and F(x_l, k2) respectively.
% Each bitwise comparison can give some certainty about XORs of pairs of key
% bits, thus allowing for construction of a system of linear equations over
% GF(2), solvable with gflineq().
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
u_l = u(1:L/2);
u_r = u(L/2+1:end);

x_l = x(1:L/2);
x_r = x(L/2+1:end);

% Calculate notable values for subsequent inference
% Known equations are:
%   x_l ^ u_r = F(u_l, k1)
%   x_r ^ u_l = F(x_l, k2)
% Let's just rename the two XORs to h1 and h2, so that:
%   h1 = F(u_l, k1)
%   h2 = F(x_l, k2)
h1 = xor(u_r, x_l);
h2 = xor(u_l, x_r);

% Now, let's expand the value of F:
%   h1 = u_l | (odd(k1) ^ even(k1))
%   h2 = x_l | (odd(k2) ^ even(k2))
% Here, if we compare the values of the bit in position j of h1 and bit in
% position j of u_l we can infer the following :
%   * if they're both 0, then the xor must equate to 0
%   * if bit of u_l is 0 and bit of h1 is 1, then the xor must equate to 1
%   * if they're both 1, we can't say anything about the value of the xor
%   * if bit of u_l is 1 and bit of h1 is 0, then there must be something broken
%     since boolean algebra don't allow this situation :-)
% All this considerations can be summed up nicely with the expression 
%   ~ h1_j & u_l_j
% if this is 1, then we know that the corresponding bit of odd(k1) ^ even(k1)
% is equal to h1_j ^ u_l_j
useful_positions_1 = not(h1 & u_l);
useful_positions_2 = not(h2 & x_l);

% Expanding this a little further, if we look at how the subkey generation
% function works, we notice that we can even determine the expression of the
% j-th bit of odd(k1) ^ even(k1). Basically, it is the XOR of two adjacent bits of
% the key k, specifically bit (2j + round - 1) mod L and (2j + round) mod L
% (with round in [1,2] - in the code below we need to adjust index calculation
% to account the fact that MatLab indexes start at 1). It is now clear that we can
% build from this information a linear equation of two variables in GF(2), with
% variables being exact bits of the key we're trying to recover, and known value
% set to
%   h_j ^ u_l_j
% for the first equation, and to
%   h_j ^ x_l_j
% for the second one.
% Iterating over all useful bits
% (see above) we can then build the function's output matrices

A = [];
b = [];

for j = 0:(length(useful_positions_1)/2-1)
  if (useful_positions_1(j+1))
    key_bit_1 = mod(2*j+1, 16)+1;
    key_bit_2 = mod(2*j+2, 16)+1;

    a_i = zeros(1, L);
    a_i(key_bit_1) = 1;
    a_i(key_bit_2) = 1;

    A = [ A; a_i ];

    b_i = xor(h1(j+1), u_l(j+1));
    b = [ b; b_i ];
  end

  if (useful_positions_1(j+9))
    key_bit_1 = mod(31 - mod(-2*j, 16), 32) + 1;
    key_bit_2 = mod(31 - mod(-2*j - 1, 16), 32) + 1;

    a_i = zeros(1, L);
    a_i(key_bit_1) = 1;
    a_i(key_bit_2) = 1;

    A = [ A; a_i ];

    b_i = xor(h1(j+9), u_l(j+9));
    b = [ b; b_i ];
  end

  if (useful_positions_2(j+1))
    key_bit_1 = mod(2*j+2, 16)+1;
    key_bit_2 = mod(2*j+3, 16)+1;

    a_i = zeros(1, L);
    a_i(key_bit_1) = 1;
    a_i(key_bit_2) = 1;

    A = [ A; a_i ];

    b_i = xor(h2(j+1), x_l(j+1));
    b = [ b; b_i ];
  end

  if (useful_positions_2(j+9))
    key_bit_1 = mod(31 - mod(-2*j - 1, 16), 32) + 1;
    key_bit_2 = mod(31 - mod(-2*j - 2, 16), 32) + 1;

    a_i = zeros(1, L);
    a_i(key_bit_1) = 1;
    a_i(key_bit_2) = 1;

    A = [ A; a_i ];

    b_i = xor(h2(j+9), x_l(j+9));
    b = [ b; b_i ];
  end
end
