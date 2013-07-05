function x = PAMencoder(u,lu,lv,lx,lM)

% Hamming encoding
xb = encoder(u,lu,lv,lx);
% PAM modulation
x = PAMbitmap(xb,lx,lM);

end