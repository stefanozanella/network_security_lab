function UECscript(trials, split)

ntry = trials; 	% number of iterations
lu = 3; 		% message length
lx = 7; 		% codeword length
lv = 4; 		% randomized information word length
nerrB = 1;      % number of errors randomly introduced on A-B channel
nerrE = 3;      % number of errors randomly introduced on A-E channels

% define the number of possibile received words at Bob
Nyx = 0; 
for i = 0:nerrB
    Nyx = Nyx + nchoosek(lx,i); 
end
% define the number of possible received words at Eve
Nzx = 0; 
for i = 0:nerrE
    Nzx = Nzx + nchoosek(lx,i); 
end

Cs = log2(Nzx/Nyx)/lx;  % secrecy capacity
R = lu/lx;              % secrecy rate

% initialize histogram that will be used for computing entropy and mutual
% information (rows = possible messages, columns = possible codewords)
histogram = zeros(2^lu,2^lx);

errorsB = 0; % counter for the number of errors at Bob
errorsE = 0; % counter for the number of errors at Eve

Hudz_data = berB_data = berE_data = [];

bar = waitbar(0,'simulation in progress');

for j = 1:split
for i = 1:ntry
    
    u = randi([0 1], 1, lu);
    
    % encode message
    x = encoder(u,lu,lv,lx);
    
    % simulate a uniform error channel towards Bob and Eve
    y = UniformErrorChannel(nerrB, x);
    z = UniformErrorChannel(nerrE, x);
    
    % decode signals at Bob and Eve
    uhatB = decoder(y,lu,lv,lx);
    uhatE = decoder(z,lu,lv,lx);
        
    % update number of errors at Bob and Eve
    errorsB = errorsB + sum(uhatB ~= u);
    errorsE = errorsE + sum(uhatE ~= u);
    
    
    % update histogram
    uind = bi2de(u) + 1;
    zind = bi2de(z) + 1;
    
    histogram(uind, zind) = histogram(uind, zind) + 1;

    waitbar(i/ntry,bar)
end

berB = errorsB/((ntry*j)*lu);
berE = errorsE/((ntry*j)*lu);

[Huz,Hu,Hz,Hudz,Hzdu,Iuz] = jointentropy(histogram/(ntry*j), ntry*j, 'uec');

Hudz_data(j) = Hudz;
berB_data(j) = berB;
berE_data(j) = berE;

fprintf('Metrics with %d trials:\n', ntry*j);
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
fprintf('\n');

end

delete(bar)

x = trials:trials:trials*split;

figure;
plot(x, Hudz_data, '+;H_{u|z};', [x(1), x(end)], [lu, lu], ';lu;');
xlabel('trials');
ylabel('H_u|z');
grid on
axis auto
print('../reports/uec_Hudz.eps', '-deps');

figure;
plot(x, berB_data, 'x;BER_B;', x, berE_data, 'o;BER_E;', [x(1), x(end)], [0.5, 0.5], ';target BER_E;');
hold on;
xlabel('trials');
ylabel('BER');
grid on
axis tight
print('../reports/uec_ber.eps', '-deps');
