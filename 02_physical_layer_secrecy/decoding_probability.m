function p = decoding_probability(eps)
  % returns the probability of correctly decoding a Hamming(4,7) codeword for a
  % BSC with error probability eps

  p = (1-eps).^7 + (1-eps).^6.*eps;
end
