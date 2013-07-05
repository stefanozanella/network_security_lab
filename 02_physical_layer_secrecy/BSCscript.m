clear all; close all; clc;

ntry = 1000; 	% number of iterations
lu = 3; 		% message length
lx = 7; 		% codeword length
lv = 4; 		% randomized information word length 
epsB = 0.1;     % bit error rate on channel A-B
epsE = 0.3;     % bit error rate on channel A-E

% initialize histogram that will be used for computing entropy and mutual
% information (rows = possible messages, columns = possible codewords)
histogram = zeros(2^lu,2^lx);

errorsB = 0; % counter for the number of errors at Bob
errorsE = 0; % counter for the number of errors at Eve

Cs = binaryEntropy(epsE)-binaryEntropy(epsB); % secrecy capacity
R = lu/lx;                                    % secrecy rate

bar = waitbar(0,'Simulation in progress');

for i = 1:ntry
    
    u = randi([0 1], 1, lu);
    
    % encode message
    x = encoder(u,lu,lv,lx);
    
    % simulate binary symmetric channels towards Bob and Eve
    y = bsc(x,epsB);
    z = bsc(x,epsE);

    % decode signals at Bob and Eve
    uhatB = decoder(y,lu,lv,lx);   
    uhatE = decoder(z,lu,lv,lx);   
    
    % update number of errors at Bob and Eve
    errorsB = errorsB + sum(uhatB ~= u);
    errorsE = errorsE + sum(uhatE ~= u);
    
    uind = bi2de(u) + 1;
    zind = bi2de(z) + 1;
    
    histogram(uind, zind) = histogram(uind, zind) + 1;

    waitbar(i/ntry,bar)
    
end

berB = errorsB/(ntry*lu);
berE = errorsE/(ntry*lu);

delete(bar)

[Huz,Hu,Hz,Hudz,Hzdu,Iuz] = jointentropy(histogram/ntry);

fprintf('Secrecy capacity = %.4f\n', Cs);
fprintf('Secrecy rate     = %.4f\n', R);
fprintf('BER at Bob       = %.2e\n', berB);
fprintf('BER at Eve       = %.2e\n', berE);
fprintf('-------------------------\n');
fprintf('H(u)   = %.4f bit\n', Hu);
fprintf('H(z)   = %.4f bit\n', Hz);
fprintf('H(u,z) = %.4f bit\n', Huz);
fprintf('H(u|z) = %.4f bit\n', Hudz);
fprintf('H(z|u) = %.4f bit\n', Hzdu);
fprintf('I(u;z) = %.4f bit\n', Iuz);