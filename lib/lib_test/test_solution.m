function test_solution(nets, sol, params)
switch params.menu.switch_testSolution
    case 'ON'
        disp(' ')
        disp('-------------------------------------------------------------')
        disp('--------------------- TEST OF THE SOLUTION ------------------')
        disp('-------------------------------------------------------------')
        
        mic.x = params.geom.locationMics(1,:);
        mic.y = params.geom.locationMics(2,:);

        src.x = params.geom.locationSpeakers(1,:);
        src.y = params.geom.locationSpeakers(2,:);

        nMics = params.geom.nMics;
        nTimeSteps = 100;

        src.freqs = params.solve.frequency*ones(size(src.x));

        src.amps = sol.ampsSpeak.*params.learnTransferFunction.ampSpeakers;
        src.phase = sol.phasesSpeak + params.learnTransferFunction.phaseSpeakers;

        dt = params.const.dt;
        t  = dt:dt:200*dt;

        c     = params.const.c;
        rho   = params.const.rho_air;

        Ma = params.solve.MachNumber;

        figure
        
        data = get_pressureMicsPointsource( mic, src, t, c, Ma, '3D' );

        

        pressurePoint = data;
        plot(squeeze(pressurePoint(:,1:nMics/2)),'-.r','DisplayName','inner')
        hold on
        plot(squeeze(pressurePoint(:,nMics/2+1:end)),'-b','DisplayName','outer')
        legend
        
        
        lims = 2;
        
        nPointsField = params.postProc.testFieldPoints;
        x = linspace(-lims,lims,nPointsField);
        y = linspace(-lims,lims,nPointsField);

        [grid_xy.x, grid_xy.y] = meshgrid(x,y);
        grid_xy.x = grid_xy.x'; grid_xy.y = grid_xy.y';




        fieldValuePoint = zeros([nTimeSteps size(grid_xy.x)]);

        micField.x = reshape(grid_xy.x,[],1);
        micField.y = reshape(grid_xy.y,[],1);

        disp('calculating a short time series with the calculated solution...')
        for iT = 1:nTimeSteps
            fieldValuePoint(iT,:,:) = reshape(get_pressureMicsPointsource( micField, src, iT*dt, c, Ma, '3D' ), size(grid_xy.x));
        end

        

        figure
        % surf(grid_xy.x, grid_xy.y, squeeze(fieldValuePoint(1,:,:)))
        imagesc(x, y, flipMatrixImageSC(squeeze(fieldValuePoint(end,:,:))))
        set ( gca, 'ydir', 'normal' )
        hold on
        scatter3(mic.x(1    :nMics/2), mic.y(1    :nMics/2), 1e2*ones(int64(size(mic.x)/2)), 50, '*r')
        scatter3(mic.x(1+nMics/2:end), mic.y(1+nMics/2:end), 1e2*ones(int64(size(mic.x)/2)), 50, '*b')
        scatter3(src.x, src.y, 1e2*ones(size(src.x)), 50, 'ob')
        % title('sound field')
        xlabel('$x$ [m]')
        ylabel('$y$ [m]')
        view(2)
        cb = colorbar;
        cb.Label.Interpreter = 'LaTeX';
        cb.Label.String = 'sound pressure [Pa]';
%         caxis([-max(abs(fieldValuePoint),[],'all'), max(abs(fieldValuePoint),[],'all')])
        shading interp
        axis tight
        caxis([-10^round(log10(max(abs(params.solve.micGoal),[],'all'))) 10^round(log10(max(abs(params.solve.micGoal),[],'all')))])


        %% sound energy density calculation

        [ampField, ~] = calculateAmpsAndPhase(reshape(fieldValuePoint, nTimeSteps, []), params.solve.frequency, 'newton', params);


        ampField = reshape(abs(ampField), size(grid_xy.x));

        % \int_V p^2/(2*rho*c^2) dV + kinetische energie (ist aber 0, weil peak von
        % Druckschwingung erreicht! Daher auch Amplitude des Feldes)
        soundPowerDensity = ampField.^2 / (2*rho * c^2);

        soundPowerDensityLevel = 10 * log10(soundPowerDensity/1e-12);

        relSoundPowerDensityLevel = soundPowerDensityLevel - sol.meanSoundPowerDensityLevelBright;

        figure
        % surf(grid_xy.x, grid_xy.y, relSoundPowerDensityLevel)
        imagesc(x, y, flipMatrixImageSC(relSoundPowerDensityLevel))
        set ( gca, 'ydir', 'normal' )
        shading flat
        axis tight
        xlabel('$x$ [m]')
        ylabel('$y$ [m]')
        hold on
        colormap(hot)
        cb = colorbar;
        cb.Label.Interpreter = 'LaTeX';
        cb.Label.String = 'sound energy density level relative to bright zone [dB]';
        caxis([-40 10])
        scatter3(mic.x(1    :nMics/2), mic.y(1    :nMics/2), 1e2*ones(int64(size(mic.x)/2)), 50, '*r')
        scatter3(mic.x(1+nMics/2:end), mic.y(1+nMics/2:end), 1e2*ones(int64(size(mic.x)/2)), 50, '*b')
        scatter3(src.x, src.y, 1e2*ones(size(src.x)), 50, 'ob')



        % get soundPowerDensity at microphones
        interpolateFunctionRel = scatteredInterpolant(reshape(grid_xy.x,[],1),reshape(grid_xy.y,[],1),reshape(relSoundPowerDensityLevel,[],1));
        try
            meanRelPowerDensityIntensityMicsBright   = mean(interpolateFunctionRel(mic.x(1    :nMics/2),mic.y(1    :nMics/2)));
            meanRelPowerDensityIntensityMicsDark     = mean(interpolateFunctionRel(mic.x(1+nMics/2:end),mic.y(1+nMics/2:end)));
        catch
            meanRelPowerDensityIntensityMics = 0;
        end
        disp(['mean relative sound energy density level of mics in dark zone:  ' num2str(meanRelPowerDensityIntensityMicsDark  ,'%.3f') 'dB'])
        disp(['mean relative sound energy density level of mics in bright zone: ' num2str(meanRelPowerDensityIntensityMicsBright,'%.3f') 'dB'])

%         keyboard
    case 'OFF'
        disp('Test of the solution is skipped!')
end
