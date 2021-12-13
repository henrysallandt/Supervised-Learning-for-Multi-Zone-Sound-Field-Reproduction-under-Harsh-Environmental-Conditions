function [freqStr, MaStr] = get_freqStrMaStr(params)
%get_freqStrMaStr - create strings for the frequency and the Mach number
%for the file name.
%
% Syntax:  
%    [freqStr, MaStr] = get_freqStrMaStr(params)
%
% Inputs:
%    params  - parameter structure
%
% Outputs:
%    freqStr - frequency string
%    MaStr   - Mach number string

freqStr = num2str(params.solve.frequency);
freqStr = replace(freqStr, '.', 'dot');
switch params.solve.switch_windConsideration
    case 'ON'
        Ma = params.solve.MachNumber;
    case 'OFF'
        Ma = 0;
    otherwise
        error('wrong params.solve.switch_windConsideration!')
end
MaStr = num2str(Ma);
MaStr = replace(MaStr, '.', 'dot');
end