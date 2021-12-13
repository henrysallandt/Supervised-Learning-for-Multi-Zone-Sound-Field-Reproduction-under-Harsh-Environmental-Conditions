function [waveNumberCorrectionFactor, phasesShiftedFinal, paramsLearn] = calculate_phaseShifted(phases, Mas, iMic, iSpeak, freqs, paramsLearn, params)
%calculate_phaseShifted - calculate phase shift modulation and wave number
%modulation factor
%
% Syntax:  
%    [waveNumberCorrectionFactor, phasesShiftedFinal, paramsAFT] = ...
%          calculate_phaseShifted(phases, Mas, iMic, iSpeak, freqs, paramsAFT, params)
%
% Inputs:
%    phases      - phase shift of pressure signal
%    Mas         - Mach number
%    iMic        - index of microphone
%    iSpeak      - index of speaker
%    freqs       - cell array of neural networks
%    paramsLearn - parameter structure of neural network training
%    params      - parameter structure
%
% Outputs:
%    waveNumberCorrectionFactor - wavenumber correction factors
%    phasesShiftedFinal         - phase modulation
%    paramsLearn                - altered parameter structure of neural network training
% 

% switch to true to be able to watch the iteration process
debugSwitch = false;


nMas = length(Mas);
locationMics                     = params.geom.locationMics;
locationSpeakers                 = params.geom.locationSpeakers;
c                                = params.const.c;


locationMic       = [locationMics(1,iMic)      ;locationMics(2,iMic)      ];
locationSpeaker   = [locationSpeakers(1,iSpeak);locationSpeakers(2,iSpeak)];
distanceSpeakMic  = norm(locationMic - locationSpeaker);
paramsLearn.geom.distanceSpeakMic = distanceSpeakMic;

k = 2*pi*(freqs / c)';

% switch params.geom.switch_numberDimensions
%     case '2D'
%         constPhaseShift = 1.040;
%     case '3D'
%         constPhaseShift = 0;
% end
% 
% paramsLearn.constPhaseShift = constPhaseShift;

waveNumberCorrectionFactor = ones(1,nMas);
phasesShiftedFinalFunction = @(waveNumberCorrectionFactor) correctPhaseShiftInterval(phases + k.*waveNumberCorrectionFactor*distanceSpeakMic - params.learnTransferFunction.phaseSpeakers);
phasesShiftedFinal =  phasesShiftedFinalFunction(waveNumberCorrectionFactor);
dPhasesShiftedBydk = meanPartialDerivativeFunction(phasesShiftedFinal, k);

dMeandPhasesShiftBydkBydWaveNumberCorrectionFactor = ...
    ( meanPartialDerivativeFunction(phasesShiftedFinalFunction(waveNumberCorrectionFactor+0.0001), k).^2 - ...
      meanPartialDerivativeFunction(phasesShiftedFinalFunction(waveNumberCorrectionFactor-0.0001), k).^2 ) / 0.0001;
iLoop = 1;
if debugSwitch
    [MAS, FREQS] = meshgrid(Mas, freqs);
    figure(4)
    cla
    plot(Mas,waveNumberCorrectionFactor)
    xlabel('Mach number $M$ [-]')
    ylabel('wave number correction factor $\tilde{k} [-]$')
    hold on
    figure(5)
    cla
    figure(6)
    cla
    surf(FREQS, MAS, phasesShiftedFinal/pi)
%     imagesc(Mas, freqs, flipMatrixImageSC((phasesShiftedFinal/pi)'))
    set ( gca, 'ydir', 'normal' )
    ylabel('frequency $f$ [Hz]')
    xlabel('Mach number $M$ [-]')
    cb = colorbar;
    cb.Label.Interpreter = 'LaTeX';
    cb.Label.String = 'corrected phase angle $\tilde{\varphi} / \pi$ [-]';
    caxis([-1 1])
    view(2)
    shading flat
end

while ~(iLoop > 3000 || all(abs(dMeandPhasesShiftBydkBydWaveNumberCorrectionFactor) < 1e-8))
    if debugSwitch
        figure(5)
        plot(Mas,dPhasesShiftedBydk)
        xlabel('Mach number $M$ [-]')
        ylabel('mean $\partial \tilde{\varphi}_{k}$')
        hold on
        keyboard
    end
    
    dMeandPhasesShiftBydkBydWaveNumberCorrectionFactor = ...
        ( meanPartialDerivativeFunction(phasesShiftedFinalFunction(waveNumberCorrectionFactor+0.0001), k).^2 - ...
          meanPartialDerivativeFunction(phasesShiftedFinalFunction(waveNumberCorrectionFactor-0.0001), k).^2 ) / 0.0001;
    
%     stepSize = max(0.1.*abs(dMeandPhasesShiftBydkBydWaveNumberCorrectionFactor), 0.2);
    if iMic <= params.geom.nMics/2
        stepSize = 0.5;
    else
        stepSize = 0.05;
    end
    waveNumberCorrectionFactor = waveNumberCorrectionFactor - stepSize.*dMeandPhasesShiftBydkBydWaveNumberCorrectionFactor;
    
    phasesShiftedFinal =  phasesShiftedFinalFunction(waveNumberCorrectionFactor);


    if debugSwitch
        dPhasesShiftedBydk = meanPartialDerivativeFunction(phasesShiftedFinal, k);
        figure(6)
        imagesc(Mas, freqs, flipMatrixImageSC((phasesShiftedFinal/pi)'))
        set ( gca, 'ydir', 'normal' )
    %                     view(2)
        shading flat
        ylabel('frequency $f$ [Hz]')
        xlabel('Mach number $M$ [-]')

        cb = colorbar;
        cb.Label.Interpreter = 'LaTeX';
        cb.Label.String = 'corrected phase angle $\tilde{\varphi} / \pi$ [-]';

        caxis([-1 1])
        figure(4)
        plot(Mas,waveNumberCorrectionFactor)
    end
    
    iLoop = iLoop + 1;
end

if any((abs(phasesShiftedFinal) - mean(phasesShiftedFinal)) > 0.1)
    keyboard
end