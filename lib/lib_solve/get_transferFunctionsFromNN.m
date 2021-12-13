function [transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor] = get_transferFunctionsFromNN(nets, params)
%getTransferFunctionsFromNN - evaluates the neural networks to reconstruct
%the acoustic transfer functions
%
% Syntax:  
%    [transferFunctions, amplification, phaseShiftAFT, phaseShiftNet, waveNrFactor] = ...
%         getTransferFunctionsFromNN(nets, params)
%
% Inputs:
%    nets              - neural network cell structure 
%    params            - parameter structure
%
% Outputs:
%    transferFunctions - acoustic transfer functions
%    amplification     - amplitude modulation
%    phaseShiftATF     - phase shift of transfer function
%    phaseShiftNet     - phase shift modulation
%    waveNrFactor      - wave number modulation factor

nSpeakers = size(nets,2);
nMics = size(nets,1);

paramsLearn = nets{1,1}.paramsLearn;

freq = params.solve.frequency;
c = params.const.c;
k = freq/c;
freqUpper = params.learnTransferFunction.freqUpper;

switch params.solve.switch_windConsideration
    case 'ON'
        Ma = params.solve.MachNumber;
    case 'OFF'
        Ma = 0;
    otherwise
        error('Wrong params.solve.switch_waveNumberCorrection!')
end


amplification = zeros(nMics,nSpeakers);
phaseShiftATF = zeros(nMics,nSpeakers);
phaseShiftNet = zeros(nMics,nSpeakers);
waveNrFactor  = zeros(nMics,nSpeakers);
fprintf(['evaluating neural networks to get the acoustic transfer functions for the chosen frequency: ' num2str(params.solve.frequency) 'Hz\n'])
if freq < paramsLearn.freqLower || freq > paramsLearn.freqUpper 
    warning('Frequency is not in the learned value interval!')
end
if Ma < paramsLearn.MachNumberMin || Ma > paramsLearn.MachNumberMax 
    warning('Mach number is not in the learned value interval!')
end

nCharacters = 0;
% loop over speakers and mics
for iSrc = 1:nSpeakers
    for iMic = 1:nMics
        paramsLearn = nets{iMic,iSrc}.paramsLearn;
        amplification(iMic,iSrc) = rescaleData(sim(nets{iMic,iSrc}.netAmp, [normaliseData(freq,paramsLearn.freqScalingInterval,paramsLearn.freqInterval);Ma]),paramsLearn.ampScalingInterval,paramsLearn.ampInterval) ;
        phaseShiftNetComplex = reshape(sim(nets{iMic,iSrc}.netPhase, [normaliseData(freq,paramsLearn.freqScalingInterval,paramsLearn.freqInterval);Ma]),1,2);
        phaseShiftNet(iMic,iSrc) = atan2(phaseShiftNetComplex(1), phaseShiftNetComplex(2));

        waveNrFactor(iMic,iSrc) = rescaleData(sim(nets{iMic,iSrc}.netWaveNr, Ma),paramsLearn.waveNrScalingInterval,paramsLearn.waveNrInterval) ;
        phaseShiftATF(iMic,iSrc) = phaseShiftNet(iMic,iSrc) - (k.*waveNrFactor(iMic,iSrc)*(nets{iMic,iSrc}.paramsLearn.geom.distanceSpeakMic)*2*pi);
    end

    % print current status      
    fprintf(repmat('\b',1,nCharacters))
    msg = [num2str(iSrc/nSpeakers * 100,'%0-2.2f') '%% finished...'];
    nCharacters = numel(msg)-1;
    fprintf(msg)
    drawnow
end
fprintf('\n')

phaseShiftATF = correctPhaseShiftInterval(phaseShiftATF);

transferFunctions = ampPhaseToComplex(amplification, phaseShiftATF);
end