function save_ATF(transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor, params)
%save_ATF - saves the acoustic transfer functions for future uses to save
%some time.
%
% Syntax:  
%    save_ATF(transferFunctions, amplification, phaseShiftAFT, phaseShiftNet, waveNrFactor, params)
%
% Inputs:
%    transferFunctions - acoustic transfer functions
%    amplification     - amplitude modulation
%    phaseShiftATF     - phase shift of the acoustic transfer functions
%    phaseShiftNet     - phase shift modulation
%    waveNrFactor      - wave number modulation factor
%    params            - parameter structure
%
% Outputs:
%
netsPath = params.save.netsPath;
% create folder if it does not exist
if ~isfolder([netsPath params.load.netName])
    mkdir(netsPath, params.load.netName)
end
% save ATFs
[freqStr, MaStr] = get_freqStrMaStr(params);
disp('saving neural network results to backup file')
save([netsPath params.load.netName '\freq' freqStr '_Ma' MaStr '.mat'], 'transferFunctions', 'amplification', 'phaseShiftATF','phaseShiftNet', 'waveNrFactor')
end