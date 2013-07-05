function x = PAMbitmap(xb,lx,lM)

% perform PAM modulation
M = 2^lM;
P = (M^2-1)/3;
Nx = ceil(lx/lM);

% split xb into blocks of lM bits and PAM modulate
x = nan(1,Nx);
for m = 1:ceil(lx/lM)
    xbm = xb((m-1)*lM+1:m*lM);
    xdm = bi2de(xbm);
    x(m) = (2*bin2gray(xdm,'pam',M)-M+1)/sqrt(P);
end   
