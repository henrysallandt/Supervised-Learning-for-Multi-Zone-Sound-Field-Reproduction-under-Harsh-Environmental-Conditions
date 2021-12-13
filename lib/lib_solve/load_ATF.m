function [transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor] = load_ATF(params)
%load_ATF - loads acoustic transfer functions if possible. It is possible if
%the acoustic transfer functions can be found and are younger than the
%networks.
%
% Syntax:  
%    [transferFunctions, amplification, phaseShiftAFT, phaseShiftNet, waveNrFactor] = load_ATF(params)
%
% Inputs:
%    params            - parameter structure
%
% Outputs:
%    transferFunctions - acoustic transfer functions
%    amplification     - amplitude modulation
%    phaseShiftAFT     - phase shift of transfer function
%    phaseShiftNet     - phase shift modulation
%    waveNrFactor      - wave number modulation factor

netsPath = params.save.netsPath;
[freqStr, MaStr] = get_freqStrMaStr(params);

freq = params.solve.frequency;
c = params.const.c;

% check if file is available
if isfile([netsPath params.load.netName '\freq' freqStr '_Ma' MaStr '.mat'])
    disp(['backupATFs were found! Loading ' 'freq' freqStr '_Ma' MaStr '.mat...'])
    % load variables
    load([netsPath params.load.netName '\freq' freqStr '_Ma' MaStr '.mat'],'transferFunctions','amplification','phaseShiftATF','phaseShiftNet','waveNrFactor')
    
    % check if variable file is younger than net file
    dateNet =  getLastChangeTime([netsPath params.load.netName '.mat']);
    dateFile = getLastChangeTime([netsPath params.load.netName '\freq' freqStr '_Ma' MaStr '.mat']);
    if dateNet > dateFile
        disp('backupATFs where found but the net is younger than the backup ATFs. Creating new ones with neural networks...')
        transferFunctions = nan;
    end
else
    disp('backupATFs were not found. Creating new ones with neural networks...')
    transferFunctions = nan;
end
% set everything to nan if no transferFunction backup is used
if isnan(transferFunctions)
    amplification = nan;
    phaseShiftATF = nan;
    phaseShiftNet = nan;
    waveNrFactor  = nan;
end
end

