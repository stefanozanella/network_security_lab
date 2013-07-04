function k_out = subkey_cyclic_rotation(k_in)

%SUBKEY_CYCLIC_ROTATION: generate i-th subkey by ciclic rotation
%   The function receives as input the (i-1)-th subkey and outputs the i-th
%   subkey, which is obtained by dividing it into left an right and 
%   cyclicly rotate each part outwards by 1 bit position.

L = length(k_in)/2;
k_out = k_in([2:L,1,2*L,L+1:2*L-1]);

end