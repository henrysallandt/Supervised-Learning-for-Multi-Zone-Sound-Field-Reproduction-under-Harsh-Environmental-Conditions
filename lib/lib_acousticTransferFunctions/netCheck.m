% netCheck - checks the networks, creates some plots and interrupts the
% calculation

freqCheck = linspace(params.learnTransferFunction.freqLower, params.learnTransferFunction.freqUpper, params.learnTransferFunction.nFreqs*4);
MaCheck = linspace(0, params.learnTransferFunction.MachNumberMax, params.learnTransferFunction.nMachNumbers*4);%/max(params.learnTransferFunction.MachNumberMax);

[FREQCHECK, MACHECK] = meshgrid(freqCheck, MaCheck);
[FREQ, MA] = meshgrid(freqs, Mas);
figure


%% amplitude check
% ampCheck = sim(netAmp, [reshape(FREQCHECK, 1, []); reshape(MACHECK, 1, [])]);
% for i=1:32
figure
ampCheck = reshape(rescaleData(sim(netAmp, [reshape(normaliseData(FREQCHECK,paramsLearn.freqScalingInterval,paramsLearn.freqInterval), 1, []); reshape(MACHECK, 1, [])]), paramsLearn.ampScalingInterval, paramsLearn.ampInterval), size(FREQCHECK));

subplot(2,1,2)
surf(FREQCHECK, MACHECK, ampCheck)
title('net prediction')
xlabel('frequency $f$ [Hz]')
ylabel('Mach number $M$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
cb.Label.String = 'amplitude $\tilde{a}_{11}$ [-]'; % \tilde{a}_{11}
caxis([min(amps,[],'all') max(amps,[],'all')])

subplot(2,1,1)
% surf(FREQ, MA, amps')
imagesc(freqs, Mas, flipMatrixImageSC(amps))
title('training data')
xlabel('frequency $f$ [Hz]')
ylabel('Mach number $M$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
cb.Label.String = 'amplitude $\tilde{a}_{11}$ [-]'; 

% end
%% amplitude train, validation, test visualisation
figure
% surf(freqCheck, MaCheck, reshape(ampCheck, size(FREQCHECK)))
imagesc(freqCheck, MaCheck, flipMatrixImageSC(ampCheck'))
xlabel('frequency $f$ [Hz]')
ylabel('Mach number $Ma$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
% cb.Label.Interpreter = 'LaTeX';
% cb.Label.String = 'amplitude $\tilde{a}_{11}$ [-]'; % \tilde{a}_{11}
caxis([min(amps,[],'all') max(amps,[],'all')])
hold on
FREQT = FREQ';
MAT = MA';
if strcmp(params.learnTransferFunction.switch_divideDataSet,'ON')
    scatter(FREQT(netAmpRaw.divideParam.trainInd),MAT(netAmpRaw.divideParam.trainInd),30,'xk','LineWidth',2)
    scatter(FREQT(netAmpRaw.divideParam.testInd),MAT(netAmpRaw.divideParam.testInd),30,'xr','LineWidth',2)
    scatter(FREQT(netAmpRaw.divideParam.valInd),MAT(netAmpRaw.divideParam.valInd),30,'x','LineWidth',2,'MarkerEdgeColor', [0 0.4 0])
end

%% training progress
figure
plot(trainingLog.perf,'k','DisplayName','training data')
hold on
plot(trainingLog.vperf,'DisplayName','between freqs','Color',[0.4940 0.1840 0.5560])
plot(trainingLog.tperf,'r','DisplayName','between Mas')
set(gca, 'YScale', 'log')
legend
ylabel('mean square error [-]')
xlabel('epoch [-]')
grid on
grid minor
grid minor

%% phase check
phaseCheck = sim(netPhase, [reshape(normaliseData(FREQCHECK,paramsLearn.freqScalingInterval,paramsLearn.freqInterval), 1, []); reshape(MACHECK, 1, [])]);
phaseCheckRad = atan2(phaseCheck(1,:), phaseCheck(2,:));

figure
subplot(2,1,2)
surf(FREQCHECK, MACHECK, reshape(phaseCheckRad, size(FREQCHECK)))
% imagesc(freqs, Mas, flipMatrixImageSC(phasesShiftedFinal/pi))
xlabel('frequency $f$ [Hz]')
ylabel('Mach number $Ma$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
cb.Label.String = 'corrected phase shift $\tilde{\varphi}_{11}$ [-]'; % \tilde{a}_{11}

subplot(2,1,1)
surf(FREQCHECK, MACHECK, reshape(phaseCheckRad, size(FREQCHECK)))
% imagesc(freqs, Mas, flipMatrixImageSC(phasesShiftedFinal/pi))
xlabel('frequency $f$ [Hz]')
ylabel('Mach number $M$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
cb.Label.String = 'corrected phase shift $\tilde{\varphi}_{11}$ [-]'; % \tilde{a}_{11}
% caxis([-pi pi])

%% wave number check
waveNrCheck = rescaleData(sim(netWaveNr, reshape(MACHECK(:,1), 1, [])), paramsLearn.waveNrScalingInterval, paramsLearn.waveNrInterval);
figure
if strcmp(params.learnTransferFunction.switch_divideDataSet,'ON')
    plot(Mas(netWaveNrRaw.divideParam.trainInd), waveNumberCorrectionFactor(netWaveNrRaw.divideParam.trainInd),'-x','DisplayName','training data')
end
hold on
plot(MaCheck, waveNrCheck,'DisplayName','prediction')
xlabel('Mach number $\Ma$ [-]')
ylabel('wave number modulation factor $\waveNumberMod$ [-]')
grid on
legend

keyboard