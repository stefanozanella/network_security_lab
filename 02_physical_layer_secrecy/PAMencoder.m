function x = PAMencoder(u,lu,lv,lx,lM)

% Hamming encoding + padding
xb = [encoder(u,lu,lv,lx), randi([0 1], 1, lM*ceil(lx/lM)-lx)];
% PAM modulation
x = PAMbitmap(xb,length(xb),lM);

end
