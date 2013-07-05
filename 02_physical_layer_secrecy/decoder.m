function uhat = decoder(y,lu,lv,lx)

% Hamming decoding
vhat = decode(y,lx,lv,'hamming');
% retrieve the random salt from the decoded word
lb = lv -lu;
b = [repmat(vhat(1:lb),1,floor(lv/lb)),zeros(rem(lv,lb))];
tmp = xor(vhat,b);
% retrieve the message
uhat = tmp(lb+1:end);
    
end