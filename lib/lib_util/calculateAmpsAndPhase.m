function [amp, phase, err] = calculateAmpsAndPhase(data, freq, method, params)
%calculateAmpsAndPhase - calculates amplitude and phase of a sinusial signal
%with known frequency.
%
% Syntax:  
%    [amp, phase, err] = calculateAmpsAndPhase(data, freq, method, params)
%
% Inputs:
%    data   - signal data
%    freq   - frequency of the signal
%    flag   - option to display iteration progress (1 = on, 0 = off)
%    method - iteration method
%    params - parameter structure
%
% Outputs:
%    amp    - refined guess of amplitudes
%    phase  - refined guess of phases
%    err    - mean square error of the sinus approximation
%% normalization
% normalize data that max(each signal) is equal to 1
normFactor = max(abs(data),[],1);
data = data ./ normFactor;

%% guess amp and phase
% calculate the sign of the derivative of the signal in the beginning
signdpBydt1 = sign(data(2,:)-data(1,:));

% guess the phase of the signal by looking at the gradient (divide the sin
% wave into two parts) an then calculate the phase shift with the arcsin
% function
phase = (signdpBydt1==1 | signdpBydt1 == 0) .* real(asin(data(1,:))) + (signdpBydt1==-1) .* (real(asin(-data(1,:)))-pi) - freq*2*pi*params.const.dt;

% guess the amplitude by taking the maximum absolute value - since this is
% already normalised, it can be initialised with ones
amp = ones(1,size(phase,2));

%% gradient descent into the correct amps and phases
[amp, phase, err] = gradientDescentSinus(amp, phase, freq, data, 0, method, params);

%% rescale to old scale
amp = amp .* normFactor;
% get the phase into the interval [-pi, pi]
phase = mod(phase+pi, 2*pi) - pi;
end