function cs = bsc_secrecy_capacity(epsB, epsE)
  cs = binaryEntropy(epsE) - binaryEntropy(epsB);
end
