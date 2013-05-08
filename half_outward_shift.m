function vector_out = half_outward_shift(vector_in, n_bits)

%HALF_OUTWARD_SHIFT: split the input vector in two halves, then perform a
% n_bits left shift for the first half, and a n_bits right shift for the second
% half.

L = length(vector_in)/2;
vector_out = vector_in([n_bits+1:L,1:n_bits,2*L-n_bits+1:2*L,L+1:2*L-n_bits]);

end
