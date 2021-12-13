function [nets, params] = get_acousticTransferFunctionNetworks(nets, params)
%get_acousticTransferFunctionNetworks - creates neural networks to recreate
%the acoustic transfer functions if desired.
%
% Syntax:  
%    [nets, params] = get_acousticTransferFunctionNetworks(nets, params)
%
% Inputs:
%    nets   - cell array of neural networks
%    params - parameter structure
%
% Outputs:
%    nets   - cell array of neural networks
%    params - changed parameter structure


switch params.menu.switch_transferFunctionNetSource
    case 'readIn'
        % do nothing since nets are already loaded!
    case 'createNew'
        disp(' ')
        disp('-------------------------------------------------------------')
        disp('-------------- TRAINING OF TRANSFER FUNCTIONS ---------------')
        disp('-------------------------------------------------------------')
        %% preprocessing
        % speaker stuff
        locationSpeakers                          = params.geom.locationSpeakers;
        nSpeakers                                 = params.geom.nSpeakers;
        paramsLearn.geom.locationSpeakers         = locationSpeakers;
        paramsLearn.geom.nSpeakers                = nSpeakers;
        paramsLearn.ampSpeakers                   = params.learnTransferFunction.ampSpeakers;
        paramsLearn.phaseSpeakers                 = params.learnTransferFunction.phaseSpeakers;

        % microphone stuff
        locationMics                       = params.geom.locationMics;
        nMics                              = params.geom.nMics;
        paramsLearn.geom.locationMics      = locationMics;
        paramsLearn.geom.nMics             = nMics;

        % time stuff
        nTimeSteps                         = params.learnTransferFunction.nTimeSteps;
        dt                                 = params.const.dt;
        paramsLearn.time.nTimeSteps        = nTimeSteps;
        paramsLearn.time.dt                = dt;
        t                                  = dt:dt:nTimeSteps*dt;

        % speed of sound
        c                                  = params.const.c;

        % frequency
        nFreqs                             = params.learnTransferFunction.nFreqs;
        freqs                              = linspace(params.learnTransferFunction.freqLower, params.learnTransferFunction.freqUpper, params.learnTransferFunction.nFreqs);
        
        % Mach number
        nMas                               = params.learnTransferFunction.nMachNumbers;
        Mas                                = linspace(0, params.learnTransferFunction.MachNumberMax, nMas);
        
        % scaling
        paramsLearn.ampScalingInterval     = params.learnTransferFunction.net.ampScalingInterval;
        paramsLearn.waveNrScalingInterval  = params.learnTransferFunction.net.waveNrScalingInterval;
        paramsLearn.freqScalingInterval    = params.learnTransferFunction.freqScalingInterval;

        %% net definition
        nets = cell(nMics, nSpeakers);
        
        [netAmpRaw, netPhaseRaw, netWaveNrRaw, paramsLearn] = initialise_networks(paramsLearn, params);

        %% data generation
        % loop through speakers
        tStart = tic();
        
        paramsLearn.Mas                    = Mas;
        paramsLearn.MachNumberMax          = max(Mas);
        paramsLearn.MachNumberMin          = min(Mas);
        paramsLearn.MaInterval             = [min(Mas) max(Mas)];
        
        paramsLearn.freqs                  = freqs;
        paramsLearn.freqUpper              = max(freqs);
        paramsLearn.freqLower              = min(freqs);
        paramsLearn.freqInterval           = [min(freqs) max(freqs)];
        % loop over speakers
        for iSpeak = 1:nSpeakers
            % write speaker location in src structure
            src.x = locationSpeakers(1,iSpeak);
            src.y = locationSpeakers(2,iSpeak);
            % loop through microphones
            for iMic = 1:nMics
                % write microphone location in mic structure
                mic.x               = locationMics(1,iMic);
                mic.y               = locationMics(2,iMic);
                paramsLearn.iMic    = iMic;
                paramsLearn.iSrc    = iSpeak;

                amps                = zeros(nFreqs, nMas);
                phases              = zeros(nFreqs, nMas);

                % collect data
                for iFreq = 1:nFreqs
                    for iMa = 1:nMas
                        Ma          = Mas(iMa);
                        src.freqs   = freqs(iFreq);
                        src.amps    = params.learnTransferFunction.ampSpeakers;
                        src.phase   = params.learnTransferFunction.phaseSpeakers;
                        
                        data = get_pressureMicsPointsource( mic, src, t, c, Ma, '3D');
                        if length(mic.x) == 1
                            data = data';
                        end

                        % get amplitudes and phases of data
                        %-------------------------------------------------%
                        % the 'newton' method is not really a newton
                        % method, but works for exact sinus data. If you
                        % don't have an exact sinus it will break. Use
                        % 'gradient descent' instead in this case and
                        % change the stepSize if needed in
                        % "gradientDescentSinus.m"
                        %-------------------------------------------------%
                        [amp, phase] = calculateAmpsAndPhase(data, freqs(iFreq), 'newton', params);

                        amps(iFreq,iMa) = amp./params.learnTransferFunction.ampSpeakers;
                        phases(iFreq,iMa) = phase - params.learnTransferFunction.phaseSpeakers;
                    end
                end
                paramsLearn.src = src;
                paramsLearn.mic = mic;
                
                %% calculation and elimination of systematic distance based effect
                [waveNumberCorrectionFactor, phasesShiftedFinal, paramsLearn] = ...
                    calculate_phaseShifted(phases, Mas, iMic, iSpeak, freqs, paramsLearn, params);
                
                %% training data creation
                freqNorm = normaliseData(freqs,paramsLearn.freqScalingInterval, paramsLearn.freqInterval);
                
                inputs = [reshape((freqNorm.*ones(nMas  ,1))', 1, []);
                          reshape((Mas     .*ones(nFreqs,1)) , 1, [])];
                
                goalAmp = reshape(amps, 1, []);
                paramsLearn.ampInterval = [min(goalAmp,[],'all') max(goalAmp,[],'all')];
                goalAmpNorm = normaliseData(goalAmp,paramsLearn.ampScalingInterval,paramsLearn.ampInterval);               
        
                % no normalisation is performed since it is already
                % normalised by sin and cos
                goalPhase = [sin(reshape(phasesShiftedFinal, 1, []));
                             cos(reshape(phasesShiftedFinal, 1, []))];
                
                
                goalWaveNr = waveNumberCorrectionFactor;
                paramsLearn.waveNrInterval = [min(goalWaveNr,[],'all') max(goalWaveNr,[],'all')];
                goalWaveNrNorm = normaliseData(goalWaveNr, paramsLearn.waveNrScalingInterval, paramsLearn.waveNrInterval);
                
                %% bug fixing
%                 bugFixing
                

                %% net training
                netAmp = netAmpRaw;
                [netAmp, trainingLog] = train(netAmp,inputs,goalAmpNorm);
%                 keyboard
                netPhase = netPhaseRaw;
                netPhase = train(netPhase, inputs, goalPhase);
%                 keyboard
                netWaveNr = netWaveNrRaw;
                netWaveNr = train(netWaveNr, Mas, goalWaveNrNorm);
%                 keyboard
                %% check quality of network
%                 netCheck
                
                %% write data in cell array
                % place nets and params inside cell array
                nets{iMic, iSpeak} = struct;
                nets{iMic, iSpeak}.netPhase    = netPhase;
                nets{iMic, iSpeak}.netAmp      = netAmp;
                nets{iMic, iSpeak}.netWaveNr   = netWaveNr;
                nets{iMic, iSpeak}.paramsLearn = paramsLearn;
                
                %% print time stamp and rest time
                % display elapsed time, time to go and whole time
                t_elapsed        = seconds(toc(tStart));
                t_elapsed.Format = 'hh:mm:ss';
                t_whole           = seconds(toc(tStart) / ( (iSpeak-1)*nMics + iMic ) * (nMics*nSpeakers));
                t_whole.Format    = 'hh:mm:ss';
                t_togo            = t_whole - t_elapsed;
                disp(['finished with microphone ' num2str(iMic) ' (of ' num2str(nMics) ') to source ' num2str(iSpeak) '(of ' num2str(nSpeakers) ')'])
                disp(join(['t_elapsed:', string(t_elapsed), '-- t_whole:', string(t_whole), '-- t_togo:', string(t_togo), '--' num2str(t_elapsed/t_whole*100), '% finished']))
                disp(' --------------------------------------------------------- ')
                disp(' ')
                
%                 keyboard
            end
        end
        keyboard
        % save net for later runs
        save([params.save.netsPath params.save.net_name '.mat'],'nets')
    otherwise
        error('wrong params.menu.switch_transferFunctionNetSource!')
end