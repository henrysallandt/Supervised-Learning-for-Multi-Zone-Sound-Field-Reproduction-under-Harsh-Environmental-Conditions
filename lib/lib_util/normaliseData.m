function [dataNorm, dataMin, dataMax, dataInterv] = normaliseData(data, intervNormal, intervOriginal)
%normalisedata - normalises the data into interval interv.
%
% Syntax:  
%    [dataNorm, dataMin, dataMax, dataDelta] = normalisedata(data)
%
% Inputs: 
%    data       - data
%    interv     - [min, max]
%
% Outputs:
%    dataNorm   - normalised data

dataMin = intervOriginal(1);
dataMax = intervOriginal(2);
dataDelta = dataMax - dataMin;
dataNorm = (data - dataMin) / (dataDelta/2) * intervNormal(2) + intervNormal(1);
dataInterv = [dataMin dataMax];