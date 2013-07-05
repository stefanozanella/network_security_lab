function y = xlogx(x)

% compute x*log2(x)

y = nan(size(x));
y(x > 0) = x(x > 0).*(-log2(x(x > 0)));
y(x == 0) = 0;