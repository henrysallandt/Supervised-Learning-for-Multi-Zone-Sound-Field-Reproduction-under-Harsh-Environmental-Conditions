function [netAmpRaw, netPhaseRaw, netWaveNrRaw, paramsLearn] = initialise_networks(paramsLearn, params)
%initialise_networks - creates the raw neural networks for acoustic
%transfer function reconstruction
%
% Syntax:  
%    [netAmpRaw, netPhaseRaw, netWaveNrRaw, paramsAFT] = initialise_networks(paramsAFT, params)
%
% Inputs:
%    paramsAFT    - parameter structure of trained neural networks
%    params       - parameter structure
%
% Outputs:
%    netAmpRaw    - raw network for amplitude modulation prediction
%    netPhaseRaw  - raw network for phase modulation prediction
%    netWaveNrRaw - raw network for wave number modulation factor prediction
%    paramsAFT    - changed parameter structure of trained neural networks

nFreqs = params.learnTransferFunction.nFreqs;
nMachNumbers = params.learnTransferFunction.nMachNumbers;

% definition of amplitude amplification network
paramsLearn.net.hiddenlayersAmp   = params.learnTransferFunction.net.hiddenlayersAmp;
netAmpRaw                         = feedforwardnet(params.learnTransferFunction.net.hiddenlayersAmp, 'trainlm'); %lm / rp / scg
netAmpRaw.inputs{1}.size          = 2;
netAmpRaw.trainParam.epochs       = params.learnTransferFunction.net.epochsAmp;
netAmpRaw.trainParam.goal         = params.learnTransferFunction.net.goalAmp;
netAmpRaw.trainParam.max_fail     = 1e3;
switch params.learnTransferFunction.switch_divideDataSet
    case 'ON'
        netAmpRaw.divideMode              = 'sample';
        netAmpRaw.divideFcn               = 'divideind';
        netAmpRaw.divideParam.trainInd    = reshape((1:2:nFreqs)' + ((1:2:nMachNumbers)-1)*nFreqs,[],1);
        netAmpRaw.divideParam.valInd      = reshape((2:2:nFreqs)' + ((1:2:nMachNumbers)-1)*nFreqs,[],1);
        netAmpRaw.divideParam.testInd     = reshape((1:1:nFreqs)' + ((2:2:nMachNumbers)-1)*nFreqs,[],1);
    case 'OFF'
        netAmpRaw.divideMode              = 'none';
    otherwise
        error('wrong params.learnTransferFunction.switch_divideDataSet!')
end

% definition of phase shift network
paramsLearn.net.hiddenlayersPhase = params.learnTransferFunction.net.hiddenlayersPhase;
netPhaseRaw                       = feedforwardnet(params.learnTransferFunction.net.hiddenlayersPhase, 'trainlm');
netPhaseRaw.inputs{1}.size        = 2;
netPhaseRaw.trainParam.epochs     = params.learnTransferFunction.net.epochsPhase;
netPhaseRaw.trainParam.goal       = params.learnTransferFunction.net.goalPhase;
netPhaseRaw.trainParam.max_fail   = 1e3;

switch params.learnTransferFunction.switch_divideDataSet
    case 'ON'
        netPhaseRaw.divideMode            = 'sample';
        netPhaseRaw.divideFcn             = 'divideind';
        netPhaseRaw.divideParam.trainInd  = reshape((1:2:nFreqs)' + ((1:2:nMachNumbers)-1)*nFreqs,[],1);
        netPhaseRaw.divideParam.valInd    = reshape((2:2:nFreqs)' + ((1:2:nMachNumbers)-1)*nFreqs,[],1);
        netPhaseRaw.divideParam.testInd   = reshape((1:1:nFreqs)' + ((2:2:nMachNumbers)-1)*nFreqs,[],1);
    case 'OFF'
        netPhaseRaw.divideMode              = 'none';
    otherwise
        error('wrong params.learnTransferFunction.switch_divideDataSet!')
end

% definition of wave number pertubation network
paramsLearn.net.hiddenlayersPhase = params.learnTransferFunction.net.hiddenlayersWaveNr;
netWaveNrRaw                       = feedforwardnet(params.learnTransferFunction.net.hiddenlayersWaveNr, 'trainlm');
netWaveNrRaw.inputs{1}.size        = 1;
netWaveNrRaw.trainParam.epochs     = params.learnTransferFunction.net.epochsWaveNr;
netWaveNrRaw.trainParam.goal       = params.learnTransferFunction.net.goalWaveNr;
netWaveNrRaw.trainParam.max_fail   = 1e3;
switch params.learnTransferFunction.switch_divideDataSet
    case 'ON'
        netWaveNrRaw.divideMode            = 'sample';
        netWaveNrRaw.divideFcn             = 'divideind';
        netWaveNrRaw.divideParam.trainInd  = reshape((1:2:nMachNumbers),[],1);
        netWaveNrRaw.divideParam.valInd    = reshape((2:2:nMachNumbers),[],1);
        netWaveNrRaw.divideParam.testInd   = reshape([],[],1);
    case 'OFF'
        netWaveNrRaw.divideMode              = 'none';
    otherwise
        error('wrong params.learnTransferFunction.switch_divideDataSet!')
end