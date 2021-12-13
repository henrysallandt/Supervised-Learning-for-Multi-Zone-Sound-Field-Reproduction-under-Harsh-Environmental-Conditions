function [result] = ampPhaseToComplex(amp, phase)
%complexToAmpPhase - calculates imaginary number from absolute value and
%phase angle
%
% Syntax:  
%    [result] = ampPhaseToComplex(amp, phase)
%
% Inputs:
%    amp    - absolute value of imaginary number
%    phase  - phase angle of imaginary number
%
% Outputs:
%    result - input number
result = amp.*(1i*sin(phase) + cos(phase));
