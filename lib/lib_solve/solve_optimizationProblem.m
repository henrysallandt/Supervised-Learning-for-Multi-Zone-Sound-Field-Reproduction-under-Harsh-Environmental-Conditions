function [sol, params] = solve_optimizationProblem(nets, sol, params)
%solve_optimizationProblem - solves the optimisation problem
%
% Syntax:  
%    [sol, params] = solve_optimizationProblem(nets, sol, params)
%
% Inputs:
%    nets   - neural network cell structure 
%    sol    - solution array with interesting values
%    params - parameter structure
%
% Outputs:
%    sol    - solution array with interesting values
%    params - parameter structure

disp(' ')
disp('-------------------------------------------------------------')
disp('----------- SOLVING OF THE OPTIMIZATION PROBLEM -------------')
disp('-------------------------------------------------------------')
nSpeakers = size(nets,2);

freq = params.solve.frequency;

%% get transfer functions from networks or backup
switch params.solve.switch_transferFunctionSource
    case 'fromNN'
        [transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor] = get_transferFunctionsFromNN(nets, params);
        save_ATF(transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor, params)
    case 'loadIfPossible'
        [transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor] = load_ATF(params);
        if isnan(transferFunctions)
            [transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor] = get_transferFunctionsFromNN(nets, params);
            save_ATF(transferFunctions, amplification, phaseShiftATF, phaseShiftNet, waveNrFactor, params)
        end
    otherwise
        error('wrong params.solve.switch_transferFunctionSource!')
end


switch params.solve.switch_noise
    case 'ON'
        switch params.solve.switch_distribution
            case 'uniform'
                transferFunctions = transferFunctions + ampPhaseToComplex(10.^(params.solve.noiseLevel/10)*abs(transferFunctions).*rand(size(transferFunctions))                                   , -pi + 2*pi.*rand(size(transferFunctions)));
            case 'gauss'
                transferFunctions = transferFunctions + ampPhaseToComplex(10.^((params.solve.standardDeviation*randn(size(transferFunctions)) + params.solve.noiseLevel)/10).*abs(transferFunctions), -pi + 2*pi.*rand(size(transferFunctions)));
            otherwise
                error('wrong params.solve.switch_distribution!')
        end
        
    case 'OFF'
        % do nothing
    otherwise
        error('wrong params.solve.switch_noise!')
end

sol.amplification = amplification;
sol.phaseShiftATF = phaseShiftATF;
sol.phaseShiftNet = phaseShiftNet;
sol.waveNrFactor = waveNrFactor;
sol.transferFunctions = transferFunctions;

%% goal, error and other preprocessing
ampsMicGoal     = params.solve.ampsMicGoal;
phasesMicGoal   = params.solve.phasesMicGoal;
goalMic         = params.solve.micGoal;

% error function definition
switch params.solve.switch_errorFunction
    case 'ampsAndPhases'
        disp('errorfunction: amplitudes and phases')
        errFunction = @(x) abs(x-goalMic).^2;
    case 'justAmps'
        disp('errorfunction: amplitudes')
        errFunction = @(x) (abs(x)-abs(goalMic)).^2;
        if strcmp(params.solve.switch_solutionMethod, 'matrixInversion') || strcmp(params.solve.switch_solutionMethod, 'BFGS')
            error('This combination of params.solve.switch_solutionMethod and params.solve.switch_errorFunction is not implemented!')
        end
    otherwise
        error('wrong params.solve.switch_errorFunction!')
end

switch params.solve.switch_regularization
    case 'lCurve'
        regularizationParameter = get_regularizationParameter(transferFunctions, goalMic);
    case 'manual'
        regularizationParameter = params.solve.manualRegularizationFactor;
    case 'OFF'
        regularizationParameter = 0;
    otherwise
        error('wrong params.solve.switch_regularization!')
end

disp(['setting regularizationParameter to ' num2str(regularizationParameter)])
% keyboard

switch params.solve.switch_solutionMethod
    case 'BFGS'
        % initial guess
        speakers = (mean(goalMic) * ones(nSpeakers,1));
        x0 = [real(speakers); imag(speakers)];
        
        % solve problem
        speakers = Quasi_Newton(transferFunctions, @errorFunc, x0, 100, 1e-10, regularizationParameter, 0, params);
        speakers = speakers(1:nSpeakers,end) + 1i*speakers(nSpeakers+1:end,end);
        
        mics = transferFunctions * speakers;
        [ampsMic, phasesMic] = complexToAmpPhase(mics);
        
        meanErr = mean(errFunction(mics));
    case 'gradientDescent'
        % initialisation
        speakers = (mean(goalMic) * ones(nSpeakers,1));
%         speakers = (transferFunctions'*transferFunctions) \ (transferFunctions' * goalMic);

        iOptimize = 0;
        h = 1e-6;

        stepSize = 1e-3;

        normGradient = inf;
        
        nCharacters = 0;

        while normGradient > 1e-8 && iOptimize < 5e5
            mics = transferFunctions * speakers;

            [ampsMic, phasesMic] = complexToAmpPhase(mics);

            errComplex = errFunction(mics);

%             derrBydReal = (errFunction(transferFunctions * (speakers+   h*eye(nSpeakers))) - errFunction(transferFunctions * (speakers-   h*eye(nSpeakers))))/(2*h);
%             derrBydImag = (errFunction(transferFunctions * (speakers+1i*h*eye(nSpeakers))) - errFunction(transferFunctions * (speakers-1i*h*eye(nSpeakers))))/(2*h);

            derrBydReal = (errFunction(transferFunctions * (speakers+   h*eye(nSpeakers))) - errComplex)/(1*h);
            derrBydImag = (errFunction(transferFunctions * (speakers+1i*h*eye(nSpeakers))) - errComplex)/(1*h);

            derrBydRealSum = sum(derrBydReal,1);
            derrBydImagSum = sum(derrBydImag,1);

            normGradient = norm([derrBydRealSum derrBydImagSum]);

            meanErr = mean(errComplex);

            if mod(iOptimize, 2000) == 0
                % print current status      
                fprintf(repmat('\b',1,nCharacters))
                msg = ['mean square error = ' num2str(meanErr) ' at iteration step ' num2str(iOptimize)];
                nCharacters = numel(msg);
                fprintf(msg)
                drawnow
%                 keyboard
            end
            speakers = speakers - stepSize*(derrBydRealSum + 1i*derrBydImagSum).';
            iOptimize = iOptimize +1;
        end
%         keyboard
        sol.iOptimize       = iOptimize;
        sol.normGradient    = normGradient;

    case 'matrixInversion'

        % formula after "Du et. al, Multizone Sound Field Reproduction Based
        % on Equivalent Source Method"
        speakers = (transferFunctions'*transferFunctions + regularizationParameter*eye(nSpeakers)) \ (transferFunctions' * goalMic);
        % calculate amps and phases of the mics
        mics = transferFunctions * speakers;
        [ampsMic, phasesMic] = complexToAmpPhase(mics);
        
        meanErr = mean(errFunction(mics));

    otherwise
        error('wrong params.solve.switch_solutionMethod!')
end
fprintf('\n')
disp(['finished!'])
disp(['Mean square error    =  ' num2str(meanErr)])
disp(['Norm of the solution =  ' num2str(norm(speakers))])

[ampsSpeak, phasesSpeak] = complexToAmpPhase(speakers);
% get amps to be positive and phases to be in interval [-pi, pi]
phasesSpeak = phasesSpeak + pi * (ampsSpeak < 0);
phasesSpeak = correctPhaseShiftInterval(phasesSpeak);
ampsSpeak = abs(ampsSpeak);

sol.normSolution    = norm(speakers);
sol.phasesSpeak     = phasesSpeak;
sol.ampsSpeak       = ampsSpeak;
sol.phasesMic       = phasesMic;
sol.ampsMic         = ampsMic;
sol.meanErr         = meanErr;
sol.ampsMicGoal     = params.solve.ampsMicGoal;
sol.phasesMicGoal   = params.solve.phasesMicGoal;
sol.micGoal         = params.solve.micGoal;
sol.locationSpeakers= params.geom.locationSpeakers;
sol.locationMics    = params.geom.locationMics;
sol.regularizationParameter = regularizationParameter;
