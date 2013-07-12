function [ h2 ] = binaryEntropy(p)
%binaryEntropy entropy of a binary rv with px(0) = p, px(1) = 1-p 

%h2 = sum(xlogx([p,1-p]));
h2 = [];
for i=1:rows(p)
for j=1:columns(p)
  h2(i,j) = sum(xlogx([p(i,j),1-p(i,j)]));
end

end

