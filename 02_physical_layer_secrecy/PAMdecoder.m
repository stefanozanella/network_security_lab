function uhat = PAMdecoder(y,lu,lv,xall)

% minimum distance decoding
[~,ivhat] = min(sum((repmat(y,size(xall,1),1)-xall).^2,2));

% obtained decoded word from the corresponding index of xall
vhat = de2bi(ivhat-1,lv);

% retrieve the random salt from the decoded word
b = [repmat(vhat(1:lv-lu),1,floor(lv/(lv-lu))),zeros(rem(lv,lv-lu))];
tmp = xor(vhat,b);

% retrieve message
uhat = tmp(lv-lu+1:end);
    
end