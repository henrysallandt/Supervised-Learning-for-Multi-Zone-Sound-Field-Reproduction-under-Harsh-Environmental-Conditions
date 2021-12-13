function params = create_speakers(params)
%create_speakers - Creates the speakers and adds the required information to
%the parameter structure.
%
% Syntax:  
%    params = create_speakers(params)
%
% Inputs:
%    params - parameter structure
%
% Outputs:
%    params - extended parameter structure

locationSpeakers = [[0.5*cos(linspace(0,2*pi-2*pi/16,16))];... % x
                    [0.5*sin(linspace(0,2*pi-2*pi/16,16))]];   % y

params.geom.locationSpeakers = locationSpeakers;
params.geom.nSpeakers = size(locationSpeakers,2);