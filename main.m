clear variables
close all
clc

%% parameter study values
% whether the parameters are part of the parameter study needs to be chosen
% in the following section

% wind speed
cs = 0.836 * 5^(3/2); %;%343*0.04; %0 / 2.83 / 6.95 / 0:1:10
% cs = linspace(0, 0.05, 21)*343;
% frequency
% freqs = 200:20:1000;
freqs = 600;
% noise level
% noiseLevels = [-100, -30, -20, -10]; %dB
noiseLevels = -10; %dB
% regularisation parameter
% regParams = [0 logspace(-4,0,5)];
% regParams = [0 0.01 0.1];
regParams = 0;

%% choose which variable to study
var1 = cs;
var2 = regParams;

%% set path
restoredefaultpath;
path(path, genpath('./lib/'))
set_groot();

%% load parameters - default parameters for parameterstudies
params                  = parameter();

%% read in previous data (mainly networks)
[nets, sol, params]     = get_previousData(params);



% initialise arrays of interesting values
acousticContrast            = zeros(length(var2),length(var1));
reproductionError           = zeros(length(var2),length(var1));
reproductionErrorOnBoundary = zeros(length(var2),length(var1));
regularizationParameter     = zeros(length(var2),length(var1));
sols                        = cell(length(var2),length(var1));

% loop over parameter study variable values
for iVar1 = 1:length(var1)
    for iVar2 = 1:length(var2)
        %% overwrite values of parameter study values in parameter structure
        params.solve.windSpeed = var1(iVar1);
%         params.solve.noiseLevel = var1(iVar1);
%         params.solve.frequency = var2(iVar2);
        params.solve.manualRegularizationFactor = var2(iVar2);
        
        %% preprocessing
        params                  = preprocess(params);
        
        %% acoustic transfer functions
        [nets,params]           = get_acousticTransferFunctionNetworks(nets, params);
        
        %% calculate speaker amps and phases
        [sol, params]           = solve_optimizationProblem(nets, sol, params);
        
        %% postprocessing
        [sol, params]           = postprocess(nets, sol, params);
        
        %% test calculated speaker amps and phases
        test_solution(nets, sol, params)
        
        %% write out stuff of interest
        
        acousticContrast(iVar2, iVar1)              = sol.acousticContrast;
        reproductionError(iVar2, iVar1)             = sol.reproductionError;
        reproductionErrorOnBoundary(iVar2, iVar1)   = sol.reproductionErrorOnBoundary;
        regularizationParameter(iVar2, iVar1)       = sol.regularizationParameter;
        sols{iVar2, iVar1} = sol;
    end
end