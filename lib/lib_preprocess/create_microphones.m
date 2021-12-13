function params = create_microphones(params)
%create_microphones - Creates the microphones and adds the required
%information to the parameter structure.
%
% Syntax:  
%    params = create_microphones(params)
%
% Inputs:
%    params - parameter structure
%
% Outputs:
%    params - extended parameter structure


% microphone square
%        a
%      |<-->|
% -----------
% |         |
% |         |
% |         |
% -----------
%
a = params.menu.sizeSquare/2; % see scetch above
n = 5;                        % number of microphones per edge - 1
b = a-a*2/(n-1);
switch params.menu.switch_squareSetup
    case 'normal'
        locationRectangle = [[ linspace(a , a, n-1) linspace(a, -b, n-1)  linspace(-a, -a, n-1) linspace(-a,  b, n-1)];...
                             [ linspace(-a, b, n-1) linspace(a,  a, n-1)  linspace( a, -b, n-1) linspace(-a, -a, n-1)]];
    case 'micMiddle'
        locationRectangle = [[ 0 linspace(a , a, n-1) linspace(a, -b, n-1)  linspace(-a, -a, n-1) linspace(-a,  b, n-1)];...
                             [ 0 linspace(-a, b, n-1) linspace(a,  a, n-1)  linspace( a, -b, n-1) linspace(-a, -a, n-1)]];
    otherwise
        error('Wrong params.menu.switch_squareSetup')
end
locationMics = [locationRectangle, locationRectangle + [-1;-1]];


params.geom.locationMics = locationMics;
params.geom.nMics = size(locationMics,2);

params.geom.distanceSpeakMic = sqrt((params.geom.locationMics(1,:) - params.geom.locationSpeakers(1,:)').^2 + ...
                                    (params.geom.locationMics(2,:) - params.geom.locationSpeakers(2,:)').^2)';
