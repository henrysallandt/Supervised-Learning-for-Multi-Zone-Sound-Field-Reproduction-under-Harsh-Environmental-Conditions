function phaseShiftOut = correctPhaseShiftInterval(phaseShiftIn)
%correctPhaseShiftInterval - Brings phase shift numbers into the interval
%[-pi, pi].
%
% Syntax:  
%    phaseShiftOut = correctPhaseShiftInterval(phaseShiftIn)
%
% Inputs:
%    phaseShiftIn  - input phase shifts
%
% Outputs:
%    phaseShiftOut - output phase shifts
phaseShiftOut = mod(phaseShiftIn+pi, 2*pi) - pi;