function [sol, params] = postprocess(nets, sol, params)
disp(' ')
disp('-------------------------------------------------------------')
disp('------------------------ POSTPROCESSING ---------------------')
disp('-------------------------------------------------------------')
% get to know some variables
dt = params.const.dt;
t  = dt:dt:400*dt;

c     = params.const.c;
rho   = params.const.rho_air;

Ma = params.solve.MachNumber;

waveLength = c / params.solve.frequency;

mic.x = params.geom.locationMics(1,:);
mic.y = params.geom.locationMics(2,:);

src.x = params.geom.locationSpeakers(1,:);
src.y = params.geom.locationSpeakers(2,:);




src.freqs = params.solve.frequency*ones(size(src.x));

src.amps = sol.ampsSpeak;
src.phase = sol.phasesSpeak;

%% reproduction error
% prepare to calculate reproduction error
nTimeSteps = 100;
lims = params.menu.sizeSquare/2;
nPointsField = params.postProc.brightDarkFieldPoints;
shiftx = 0;
shifty = 0;

xBright = linspace(-lims,lims,nPointsField) + shiftx;
yBright = linspace(-lims,lims,nPointsField) + shifty;

dx = xBright(2) - xBright(1);

% since the points of the bright zone are also positioned at the boundary of
% the bright zone, these points need to be weighted differently (edges -->
% *0.5, corners --> *0.25)
surfaceReductionFactor = ones(nPointsField);
surfaceReductionFactor(:, 1) = 0.5; surfaceReductionFactor(:, end) = 0.5; surfaceReductionFactor(1, :) = 0.5; surfaceReductionFactor(end, :) = 0.5;
surfaceReductionFactor([1 end], [1 end]) = 0.25;

surfaceBright = dx^2*sum(surfaceReductionFactor,'all');

[gridBright.x, gridBright.y] = meshgrid(xBright,yBright);
gridBright.x = gridBright.x'; gridBright.y = gridBright.y';

% calculate pressure time series
fieldValuePointBright = zeros([nTimeSteps size(gridBright.x)]);

for iT = 1:nTimeSteps
    fieldValuePointBright(iT,:,:) = reshape(get_pressureMicsPointsource( gridBright, src, iT*dt, c, Ma, '3D' ), size(gridBright.x));
end
[ampFieldBright, phaseFieldBright] = calculateAmpsAndPhase(reshape(fieldValuePointBright, nTimeSteps, []), params.solve.frequency, 'newton', params);


ampFieldBright   = reshape(ampFieldBright  , size(gridBright.x));

phaseFieldBright = correctPhaseShiftInterval(reshape(phaseFieldBright, size(gridBright.x)));

fieldBright = ampPhaseToComplex(ampFieldBright, phaseFieldBright);


ampsFieldBrightGoal = params.solve.goal_pressureAmplitude*5 ./ sqrt((gridBright.x - 5).^2 + gridBright.y.^2);

phasesFieldBrightGoal = correctPhaseShiftInterval(2*pi*sqrt((gridBright.x - 5).^2 + gridBright.y.^2)/waveLength);

goalFieldBright = ampPhaseToComplex(ampsFieldBrightGoal, phasesFieldBrightGoal);

sol.meanSoundPowerDensityLevelBright = mean(10 * log10( ampFieldBright.^2 / (2*rho * c^2) / 1e-12 ),'all');

% amp and phase contribute to the error
sol.reproductionError = 10*log10(  1/surfaceBright * sum(  abs(fieldBright-goalFieldBright).^2 ./ (abs(fieldBright).^2) .* surfaceReductionFactor * dx^2, 'all'  )  );
disp(['reproduction error:             ' num2str(sol.reproductionError) 'dB'])

% amp contributes to the error
sol.reproductionErrorAmp = 10*log10(  1/surfaceBright * sum(  (abs(fieldBright)-abs(goalFieldBright)).^2 ./ (abs(fieldBright))^2 .* surfaceReductionFactor * dx^2, 'all'  )  );
disp(['reproduction error just amp:    ' num2str(sol.reproductionErrorAmp) 'dB'])

% only integrate along boundary of the bright zone with amp and phase
% contributing to the error
integrand = abs(fieldBright-goalFieldBright).^2 ./ (abs(fieldBright).^2);
whereOnBoundary = surfaceReductionFactor ~= 1;

sol.reproductionErrorOnBoundary = 10*log10(  1/(8*lims) * sum(  integrand(whereOnBoundary) * dx, 'all'  )  );
disp(['reproduction error on boundary: ' num2str(sol.reproductionErrorOnBoundary) 'dB'])
% keyboard
%% acoustic contrast
shiftx = -1;
shifty = -1;

xDark = linspace(-lims,lims,nPointsField) + shiftx;
yDark = linspace(-lims,lims,nPointsField) + shifty;

dx = xDark(2) - xDark(1);

% since the points of the dark zone are also positioned at the boundary of
% the bright zone, these points need to be weighted differently (edges -->
% *0.5, corners --> *0.25)
surfaceReductionFactor = ones(nPointsField);
surfaceReductionFactor(:, 1) = 0.5; surfaceReductionFactor(:, end) = 0.5; surfaceReductionFactor(1, :) = 0.5; surfaceReductionFactor(end, :) = 0.5;
surfaceReductionFactor([1 end], [1 end]) = 0.25;

surfaceDark = dx^2*sum(surfaceReductionFactor,'all');

[gridDark.x, gridDark.y] = meshgrid(xDark,yDark);
gridDark.x = gridDark.x'; gridDark.y = gridDark.y';

% calculate pressure time series
fieldValuePointDark = zeros([nTimeSteps size(gridDark.x)]);

for iT = 1:nTimeSteps
    fieldValuePointDark(iT,:,:) = reshape(get_pressureMicsPointsource( gridDark, src, iT*dt, c, Ma, '3D' ), size(gridDark.x));
end
[ampFieldDark, phaseFieldDark] = calculateAmpsAndPhase(reshape(fieldValuePointDark, nTimeSteps, []), params.solve.frequency, 'newton', params);


ampFieldDark   = reshape(ampFieldDark  , size(gridDark.x));
phaseFieldDark = reshape(phaseFieldDark, size(gridDark.x));

fieldDark = ampPhaseToComplex(ampFieldDark, phaseFieldDark);

sol.acousticContrast = 10*log10(  ( 1/surfaceBright*sum(abs(fieldBright).^2 .* surfaceReductionFactor * dx^2 ,'all') ) ./ ...
                                  ( 1/surfaceDark  *sum(abs(fieldDark  ).^2 .* surfaceReductionFactor * dx^2 ,'all') )  ) ;
disp(['acoustic contrast:              ' num2str(sol.acousticContrast) 'dB'])
% keyboard
% reproductionErrorExamination
