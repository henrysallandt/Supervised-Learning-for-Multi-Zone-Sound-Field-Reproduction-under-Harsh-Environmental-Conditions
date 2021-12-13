function params = parameter()
%parameter - loads the chosen parameters of the run.
%
% Syntax:  
%    parameter()
%
% Inputs:
%
% Outputs:
%
disp(' ')
disp('-------------------------------------------------------------')
disp('------------------------ PREPROCESSING ----------------------')
disp('-------------------------------------------------------------')
disp('loading parameters...')
params = struct;
%% menu
params.menu.switch_squareSetup                          = 'micMiddle'; % 'normal' / 'micMiddle'
params.menu.sizeSquare                                  = 0.3;
params.menu.switch_transferFunctionNetSource            = 'readIn'; % 'createNew' / 'readIn'
params.menu.switch_testSolution                         = 'ON'; % 'ON' / 'OFF'
%% parameters for solving optimization problem
params.solve.goal_pressureAmplitude                     = 1;

params.solve.switch_transferFunctionSource              = 'loadIfPossible'; % 'fromNN' / 'loadIfPossible'

params.solve.switch_solutionMethod                      = 'matrixInversion'; % 'gradientDescent' / 'matrixInversion' / 'BFGS'
params.solve.frequency                                  = 600;
params.solve.windSpeed                                  = 0;%0.836 * 5^(3/2);%0.836 * 4^(3/2);%0.025*343;
params.solve.switch_errorFunction                       = 'ampsAndPhases'; % 'ampsAndPhases' / 'justAmps'

params.solve.switch_windConsideration                   = 'ON'; % 'ON' / 'OFF'

params.solve.switch_regularization                      = 'manual'; % 'lCurve' / 'manual' / 'OFF'
params.solve.manualRegularizationFactor                 = 0.01;

params.solve.switch_noise                               = 'OFF'; % 'ON' / 'OFF'
params.solve.switch_distribution                        = 'gauss'; % 'uniform' / 'gauss'
params.solve.noiseLevel                                 = -30; %dB of measured signal
params.solve.standardDeviation                          = 0;

%% parameters for the postprocessing and testing
params.postProc.testFieldPoints                         = 200;
params.postProc.brightDarkFieldPoints                   = 40;

%% constants
params.const.c                                          = 343;
params.const.dt                                         = 1/48000;
params.const.rho_air                                    = 1.225;

%% names
params.save.netsPath                                    = '.\data\nets\';

params.load.netName                                     = 'nets_16Speakers_34Mics';

%% parameters for learning of transfer function
params.learnTransferFunction.sinusAllowedError          = 1e-20;

params.learnTransferFunction.switch_divideDataSet       = 'OFF'; % 'ON' / 'OFF'

params.learnTransferFunction.nTimeSteps                 = 400;
params.learnTransferFunction.freqLower                  = 200;
params.learnTransferFunction.freqUpper                  = 3000;
params.learnTransferFunction.nFreqs                     = (35   *2)-1;%141;
params.learnTransferFunction.freqScalingInterval        = [0 1];
params.learnTransferFunction.MachNumberMax              = 0.3;
params.learnTransferFunction.MachNumberMin              = 0;
params.learnTransferFunction.nMachNumbers               = (15    *2)-1;%31;

params.learnTransferFunction.net.hiddenlayersAmp        = [15,10];
params.learnTransferFunction.net.epochsAmp              = 3e3;
params.learnTransferFunction.net.goalAmp                = 1e-7;
params.learnTransferFunction.net.ampScalingInterval     = [-1 1];

params.learnTransferFunction.net.hiddenlayersPhase      = [15,10];
params.learnTransferFunction.net.epochsPhase            = 2e3;
params.learnTransferFunction.net.goalPhase              = 1e-7;

params.learnTransferFunction.net.hiddenlayersWaveNr     = [10,5];
params.learnTransferFunction.net.epochsWaveNr           = 1e3;
params.learnTransferFunction.net.goalWaveNr             = 1e-7;
params.learnTransferFunction.net.waveNrScalingInterval  = [-1 1];

params.learnTransferFunction.ampSpeakers                = 1;
params.learnTransferFunction.phaseSpeakers              = 0;
end