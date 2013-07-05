function x = encoder(u,lu,lv,lx)

% create a random salt to be used for randomizing the encoding procedure 
lb = lv -lu;
b = randi([0 1], 1, lb);
% extend b to lv bits
b = [repmat(b,1,floor(lv/lb)),zeros(rem(lv,lb))];
% xor the zero-padded message with b (note that the first
% lv-lu bits are equal to b)
v = xor([zeros(1,lb), u], b);

% Hamming encoding
x = encode(double(v),lx,lv,'hamming');

end