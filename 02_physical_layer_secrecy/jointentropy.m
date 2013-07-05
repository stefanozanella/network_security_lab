function [Hxy,Hx,Hy,Hxdy,Hydx,Ixy] = jointentropy(pxy)

% pxy(i,j) = P[x = i, y = j],

Hxy = sum(sum(xlogx(pxy))); % H(x,y)
px = sum(pxy,2);            % pmd of x
Hx = sum(xlogx(px));        % H(x)
py = sum(pxy,1);            % pmd of y
Hy = sum(xlogx(py));        % H(y)
Hxdy = Hxy-Hy;              % H(x|y)
Hydx = Hxy-Hx;              % H(y|x)
Ixy = Hx+Hy-Hxy;            % I(x;y)

pxdy = pxy./repmat(py,size(px)); % pmd of x given y
Hxdy0 = sum(xlogx(pxdy),1);      % H(x|y=0)

figure;
stem(Hxdy0);
xlabel('w [codeword, 7 bit]');
ylabel('H_{u|z=0}(w)');
grid on
axis tight