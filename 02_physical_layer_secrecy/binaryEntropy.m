function [ h2 ] = binaryEntropy(p)
%binaryEntropy entropy of a binary rv with px(0) = p, px(1) = 1-p 

h2 = sum(xlogx([p,1-p]));

end

