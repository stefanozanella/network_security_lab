function AWGNscript(trials,split, db_snrB, db_snrE)
ntry = trials; 	% number of iterations
lu = 3; 		% message length
lx = 7; 		% codeword length
lv = 4; 		% randomized information word length
dBsnrB = db_snrB; 	% Signal-To-Noise ratio (in dB) of the channel to Bob
dBsnrE = db_snrE; 	% Signal-To-Noise ratio (in dB) of the channel to Eve
lM = 7; 		% number of bits per symbol; lM must divide lx

snrB = 10^(dBsnrB/10); 	% SNR to Bob 
snrE = 10^(dBsnrE/10);	% SNR to Eve

errorsB = 0; % counter for the number of errors at Bob
errorsE = 0; % counter for the number of errors at Eve

Cs = 1/2* (log2(1+snrB)-log2(1+snrE)); % secrecy capacity for the Gaussian channel
R = lu/lx*lM;					 	   % secrecy rate

% create a matrix with all PAM encoded symbols
xall = zeros(2^lv, lx/lM);
for iv = 1:2^lv 
    v = de2bi(iv-1,lv);
    xall(iv,:) = PAMbitmap(encode(v,lx,lv,'hamming')',lx,lM);
end

berB_data = [];
berE_data = [];

bar = waitbar(0,'Simulation in progress');

for j = 1:split
for i = 1:ntry
    
    u = randi([0 1], 1, lu);
    
    % Hamming encoding + PAM modulation
    x = PAMencoder(u,lu,lv,lx,lM);
    
    % simulate additive white gaussian noise channels towards Bob and Eve
    y = awgn(x,dBsnrB);
    z = awgn(x,dBsnrE);
    
    % PAM demodulation + Hamming decoding of Bob's and Eve's received
    % signal
    uhatB = PAMdecoder(y,lu,lv,xall);   
    uhatE = PAMdecoder(z,lu,lv,xall);
    
    % update number of errors at Bob and Eve
    errorsB = errorsB + sum(uhatB ~= u);
    errorsE = errorsE + sum(uhatE ~= u);
    
    waitbar(i/ntry,bar)
    
end

berB = errorsB/(ntry*j*lu);
berE = errorsE/(ntry*j*lu);

berB_data(j) = berB;
berE_data(j) = berE;

fprintf('Secrecy capacity = %.4f\n', Cs);
fprintf('Secrecy rate     = %.4f\n', R);
fprintf('BER at Bob       = %.2e\n', berB);
fprintf('BER at Eve       = %.2e\n', berE);

end

delete(bar)

figure;
plot(x, berB_data, 'x;BER_B;', x, berE_data, 'o;BER_E;', [x(1), x(end)], [0.5, 0.5], ';target BER_E;');
hold on;
xlabel('trials');
ylabel('BER');
grid on
axis tight
print('../reports/uec_ber.eps', '-deps');
