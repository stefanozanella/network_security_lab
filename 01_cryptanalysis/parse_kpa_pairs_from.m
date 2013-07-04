function [ kpa_pairs ] = parse_kpa_pairs_from(filename)

% PARSE_KPA_PAIRS_FROM: parses the given file into a cell containing the
% structured list of known plaintext/ciphertext pairs which are then
% supsequently accessible with the utility functions ciphertext(kpas, idx) and
% plaintext(kpas, idx)

kpa_pairs = textscan(fopen(filename), '%s  %s');
