nMics = params.geom.nMics;

errorFieldBright = fieldBright - goalFieldBright;
integrand = abs(fieldBright-goalFieldBright).^2 ./ (abs(fieldBright).^2);
whereOnBoundary = surfaceReductionFactor ~= 1;

angleError = angle(errorFieldBright);
absError = abs(errorFieldBright);

% numberExperiment = params.solve.windSpeed/343/0.005 + 1;
% figure(1)
% subplot(3,4,numberExperiment)
% surf(gridBright.x, gridBright.y, integrand)
% view(2)
% shading interp
% axis equal
% xlim([-lims*1.2 lims*1.2])
% ylim([-lims*1.2 lims*1.2])
% hold on
% scatter3(params.geom.locationMics(1,1:nMics/2)    , params.geom.locationMics(2,1:nMics/2)    , 1e2*ones(size(params.geom.locationMics(2,1:nMics/2)    )), 30, '*r')
% title(['Ma = ' num2str(params.solve.windSpeed/343)])
% xlabel('$x$ [m]')
% ylabel('$y$ [m]')
% cb = colorbar;
% 
% cb.Label.Interpreter = 'LaTeX';
% cb.Label.String = 'integrand';
% caxis([0 0.04])
% drawnow