function [amp, phase, err] = gradientDescentSinus(amp, phase, freq, data, flag, method, params)
%gradientDescentSinus - refines an initial guess of amplitude and phase of 
%a sinusial signal with known frequency using gradient descent.
%
% Syntax:  
%    [amp, phase, err] = gradientDescentSinus(amp, phase, freq, data, flag, method, params)
%
% Inputs:
%    amp    - initial guess of amplitudes
%    phase  - initial guess of phases
%    freq   - frequency of the signal
%    data   - signal data
%    flag   - option to display iteration progress (1 = on, 0 = off)
%    method - iteration method
%    params - parameter structure
%
% Outputs:
%    amp    - refined guess of amplitudes
%    phase  - refined guess of phases
%    err    - mean square error of the sinus approximation

iT_start = 1;
iT_end   = 400;
nTimeSteps = min(iT_end - iT_start + 1, size(data,1));

iOptimize = 0;
nCharacters = 0;

dt = params.const.dt;

t = (dt:dt:nTimeSteps*dt)';

% error function which the gradient descent algorithm trys to minimize
errorFunction = @(old, amplitudes, phaseShifts) mean((old - sin(t*freq*2*pi +  phaseShifts).*amplitudes).^2);

normFactor = max(abs(data));
dataNorm = data ./ normFactor;
amp = amp ./ normFactor;

% order of numerical derivative
derivativeOrder = 2;

% initialise error
err = errorFunction(dataNorm, amp, phase);


switch_secondFittingMethod = method; %'gradient descent' / 'newton'
if strcmp(switch_secondFittingMethod, 'gradient descent')
    warning('gradient descent as optimization method for amplitude and phase calculation')
end

% step width for numerical derivative
h = 1e-6;

% interruption criterion
allowedError = params.learnTransferFunction.sinusAllowedError;

% for the first activateSeco iterations
firstStepSize  = 8e-3;
% for the remaining iterations
secondStepSize = 8e-3;
% from which iteration step the secondStepSize is used
activateSecondStepSize = 20;
% maximum numbers of iterations
maxOptimize = 4e3;

if flag == 1 
    fprintf(['Starting ' switch_secondFittingMethod ' iteration...\n'])
    fprintf('Finished with ')
end

whereTooHigh        = find(err > allowedError);

while any(err > allowedError)
    if iOptimize == maxOptimize
        warning(['gradient descent did not converge to desired value! ' num2str(length(whereTooHigh)) ' sinuses have a too high error. Maximum error: ' num2str(max(err))])
        
        break
        keyboard
        figure(10)
        iWhere = 1;
        
        amplitudeDebug = linspace(0.0001,1,400);
        phaseDebug = linspace(-pi*1.2, pi*1.2,400);
        
        amplitudeDebug = linspace(amp(whereTooHigh(iWhere))-0.1,amp(whereTooHigh(iWhere))+0.1,100);
        phaseDebug = linspace(phase(whereTooHigh(iWhere))-0.1,phase(whereTooHigh(iWhere))+0.1,100);
        
        errorVis = zeros(100,100);

        for iAmp = 1:100
            for iPhase = 1:100
                errorVis(iAmp, iPhase) = errorFunction(dataNorm(:,whereTooHigh(iWhere)), amplitudeDebug(iAmp), phaseDebug(iPhase));
            end
        end
        [AMPLITUDE, PHASE] = meshgrid(amplitudeDebug, phaseDebug);
        surf(PHASE,AMPLITUDE,errorVis')
        xlabel('Phase [rad]')
        ylabel('Amplitude [-]')
%         caxis([0 0.0000004])
        shading interp
        view(2)
        hold on


    elseif iOptimize > maxOptimize
        keyboard
        scatter3(phase(whereTooHigh(iWhere)), amp(whereTooHigh(iWhere)), 1e3, 100, 'r.')


%             error('Too many optimization iterations!')

    end
    
    % find out where the error is too high
    whereTooHigh = find(err > allowedError);
    
    % calculate derivatives
    switch derivativeOrder
        case 1
            dErrBydAmp   =  (errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)+h, phase(whereTooHigh)  ) - err(whereTooHigh)) / h ;
            dErrBydPhase =  (errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)  , phase(whereTooHigh)+h) - err(whereTooHigh)) / h;
        case 2
            dErrBydAmp   =  (errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)+h, phase(whereTooHigh)  ) - errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)-h, phase(whereTooHigh)  )) / (2*h);
            dErrBydPhase =  (errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)  , phase(whereTooHigh)+h) - errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh)  , phase(whereTooHigh)-h)) / (2*h);
    end
    
    switch switch_secondFittingMethod
        case 'gradient descent'
            % step size
            if iOptimize < activateSecondStepSize
                stepSize = firstStepSize;
            else
                stepSize = secondStepSize;
            end
        case 'newton'
            % step size that the linearized problem is equal to zero with
            % neglection of the hessian
            stepSize = err(whereTooHigh) ./ vecnorm([dErrBydAmp; dErrBydPhase]).^2;
        otherwise
            error('wrong switch_secondFittingMethod!')
    end
    
    % new amplitude and phase angle
    amp(whereTooHigh)   = amp(whereTooHigh)   - stepSize.*dErrBydAmp;
    phase(whereTooHigh) = phase(whereTooHigh) - stepSize.*dErrBydPhase;
    
    % calculate error
    err(whereTooHigh) = errorFunction(dataNorm(:,whereTooHigh), amp(whereTooHigh), phase(whereTooHigh));
    
    % raise iteration step counter
    iOptimize = iOptimize + 1;
    

    % print current status
    if mod(iOptimize, 4) == 0 && flag == 1   
        fprintf(repmat('\b',1,nCharacters))
        msg = [num2str((size(dataNorm,2) - length(whereTooHigh)) / size(dataNorm,2) * 100,'%0-2.2f') '%% at iteration step ' num2str(iOptimize)];
        nCharacters = numel(msg)-1;
        fprintf(msg)
        drawnow
    end
end

% keyboard

amp = amp .* normFactor;

if flag == 1
    fprintf('\n')
end

