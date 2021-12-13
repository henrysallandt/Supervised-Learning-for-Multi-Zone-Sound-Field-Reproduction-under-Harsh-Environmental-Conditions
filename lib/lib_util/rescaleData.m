function data = rescaleData(dataNorm, intervNormal, intervOriginal)
%rescaledata - rescales the normalised data into the original interval.
%
% Syntax:  
%    data = rescaledata(dataNorm, dataMin, dataDelta)
%
% Inputs:
%    dataNorm - normalised data
%    dataMin  - original minimum value of data
%    dataMax  - original maximum value of data
%
% Outputs:
%    data     - data

dataDelta = intervOriginal(2) - intervOriginal(1);
data = (dataNorm - intervNormal(1)) * (dataDelta/(intervNormal(2)-intervNormal(1))) + intervOriginal(1);