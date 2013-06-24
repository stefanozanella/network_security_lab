#!/usr/bin/env ruby

require 'openssl'
require 'yaml'

# TODO
# Documentation:
#   * Serialization format

# Spaces:
#   Key space: 32-bit
n_key = 8

# Step 0:
#   Asymmetric key pairs generation
#   TODO
ka_priv = OpenSSL::PKey::RSA.new(2048)
ka_pub  = ka_priv.public_key

kb_priv = OpenSSL::PKey::RSA.new(2048)
kb_pub  = kb_priv.public_key

kc_priv = OpenSSL::PKey::RSA.new(2048)
kc_pub  = kc_priv.public_key

# Step 1:
#   * A generates nonce
#   * A sends nonce to C
# Question: PRNG or TRNG? Does we need long-distance independence more than
# uniform distribution?
ra = Random.new.bytes(8)

idA = 'alice@example.com'
idB = 'bob@example.com'

# POSSIBLE FLAW: ra is not encrypted
#   * C isn't sure A is sending. Is this important?
msg_to_c = YAML::dump({ :idA => idA, :idB => idB, :ra => ra })

# Step 2:
#   * C generates the key, encrypts [k, ra] = u1, => x1 = E(u1)
#   * Sends x1 to A
#   * A decrypts u1
# NOTE: Key is uniform, we use Kernel#rand
ra_c = YAML::load(msg_to_c)[:ra]

k = Random.new.bytes(n_key)
u1 = YAML::dump({:k => k, :ra => ra_c})
x1 = ka_pub.public_encrypt(u1) # NOTE: Doesn't contain idA. Flaw?

u1 = ka_priv.private_decrypt(x1)

# Step 3:
#   * A signs [idA, idB, ra]
#   * A sends the signed message x2 to B
u2 = YAML::dump({:idA => idA, :idB => idB, :ra => ra})
t2 = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, k, u2)
x2 = YAML::dump({:u => u2, :t => t2})

# Step 4:
#   * B sends u2 to C
u2hash = YAML::load(x2) 
u2 = u2hash[:u]
t2 = u2hash[:t]
b_to_c = YAML::dump(u2) # Why sending this if it doesn't provide useful information to C?

# Step 5:
#   * C encrypts u1 into x3 and sends it to B
#   * B decrypts x3 into u1
# No verification on anything?
x3 = kb_pub.public_encrypt(u1)
u1_b = kb_priv.private_decrypt(x3)

k_b = YAML::load(u1)[:k]
t1 = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, k_b, u1_b)
puts t1 == t2
