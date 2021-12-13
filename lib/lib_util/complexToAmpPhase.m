function [amp, phase] = complexToAmpPhase(input)
%complexToAmpPhase - converts imaginary number into amplitude and phase
%angle.
%
% Syntax:  
%    [amp, phase] = complexToAmpPhase(input)
%
% Inputs:
%    input  - input number
%
% Outputs:
%    amp    - absolute value of imaginary number
%    phase  - phase angle of imaginary number

amp = abs(input);
phase = angle(input);