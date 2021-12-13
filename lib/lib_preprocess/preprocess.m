function params = preprocess(params)
%preprocess - performs proprocessing
%
% Syntax:  
%    params = preprocess(params)
%
% Inputs:
%    params - parameter structure
%
% Outputs:
%    params - extended parameter structure

disp('preprocessing...')

% display Mach number
params.solve.MachNumber = params.solve.windSpeed / params.const.c;
disp(['resulting Mach number ' num2str(params.solve.MachNumber) ' at wind speed ' num2str(params.solve.windSpeed) 'm/s'])
disp(['wind effects consideration: ' params.solve.switch_windConsideration])
% prepare several things
params = create_speakers(params);
params = create_microphones(params);
params = create_goal(params);

%

params.save.net_name = ['nets_' num2str(params.geom.nSpeakers) 'Speakers_' num2str(params.geom.nMics) 'Mics'];
end