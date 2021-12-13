function params = create_goal(params)
%create_goal - Creates the goal pressure and adds the required
%information to the parameter structure.
%
% Syntax:  
%    params = create_goal(params)
%
% Inputs:
%    params - parameter structure
%
% Outputs:
%    params - extended parameter structure

locationMics = params.geom.locationMics;
waveLength = params.const.c / params.solve.frequency;

% point source at [5,0] for bright zone
ampsMicGoal = params.solve.goal_pressureAmplitude * 5 ./ sqrt((locationMics(1,:) - 5).^2 + locationMics(2,:).^2);
% zero for dark zone
ampsMicGoal(params.geom.nMics/2+1:end) = 0;

phasesMicGoal = correctPhaseShiftInterval(2*pi*sqrt((locationMics(1,:) - 5).^2 + locationMics(2,:).^2)/waveLength);


params.solve.ampsMicGoal        = ampsMicGoal;
params.solve.phasesMicGoal      = phasesMicGoal;
params.solve.micGoal            = ampPhaseToComplex(ampsMicGoal, phasesMicGoal).';