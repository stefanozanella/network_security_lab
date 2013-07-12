function y = UniformErrorChannel(nerr, x)

% takes input binary word x, outputs y = XOR(x,err),
% where err is uniformly distributed over all error patterns with <= nerr
% errors

% transmitted word length
n = length(x);

% create all possible error patterns
err_patterns = de2bi(0:2^n-1);
% restrict the choice to error patterns with at most nerr errors
err_patterns = err_patterns(sum(err_patterns,2) <= nerr,:);

Nydx = size(err_patterns,1);
% randomly pick up an error patter
err = err_patterns(randi(Nydx,1),:);

% add the error to the received word
y = xor(err,x);

%txerr = randi([0 nerr]);
