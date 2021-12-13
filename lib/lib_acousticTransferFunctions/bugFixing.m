% bugFixing - script for some plots and bug fixing.

% figure
% plot(freqs, amps(:,1))
% xlabel('frequency [Hz]')
% ylabel('pressure amplitude at microphone [p]')
% 
% figure
% plot(freqs, phasesShiftedFinal(:,1)) 
% xlabel('frequency [Hz]')
% ylabel('phase shift to speaker [rad]')
% switch_savePlots = 'OFF';

[MAS, FREQS] = meshgrid(Mas, freqs);
figure
surf(FREQS, MAS, amps)

xlabel('frequency $f$ [Hz]')
ylabel('Mach number $M$ [-]')
view(2)
shading flat
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
grid on
% cb.Label.String = 'amplitude $\tilde{a}_{11}$ [-]'; % \tilde{a}_{11}




figure
surf(FREQS, MAS, phasesShiftedFinal/pi)

xlabel('frequency $f$ [Hz]')
ylabel('Mach number $M$ [-]')
view(2)
shading interp
set ( gca, 'ydir', 'normal' )
cb = colorbar;
cb.Label.Interpreter = 'LaTeX';
% cb.Label.String = 'corrected phase shift $\tilde{\varphi}_{11}/\pi$ [-]';
caxis([-1,1])
grid on


figure
plot(Mas, waveNumberCorrectionFactor)
xlabel('Mach number $M$ [-]')
ylabel('wave number correction $\tilde{k}_{11}$ factor [-]')
grid on



switch params.menu.switch_squareSetup
    case 'normal'
        corr = 0;
    case 'micMiddle'
        corr = 1;
    otherwise
        error('Wrong params.menu.switch_squareSetup!')
end

%% old uniform wind setup
% figure
% scatter3(params.geom.locationMics(1,:), params.geom.locationMics(2,:), 1e2*ones(size(params.geom.locationMics(2,:))), 20, '*k')
% hold on
% scatter3(params.geom.locationSpeakers(1,:), params.geom.locationSpeakers(2,:), 1e2*ones(size(params.geom.locationSpeakers(2,:))), 50, 'ok')
% % scatter3(params.geom.locationMics(1,iMic),params.geom.locationMics(2,iMic),1e2, 300,'xb')
% % scatter3(params.geom.locationSpeakers(1,iSpeak),params.geom.locationSpeakers(2,iSpeak),1e2, 300,'xb')
% xlim([-2,2])
% ylim([-2,2])
% xlabel('x [m]')
% ylabel('y [m]')
% axis equal
% [X, Y] = meshgrid(linspace(-2,2,16), linspace(-2,2,16));
% % quiver(X,Y,params.solve.windProfileFunction(Y),zeros(size(Y)), 0.3)
% view(2)
% if strcmp(params.menu.switch_savePlots,'ON')
%     saveFigTikz('location')
% end



%% logarithmic wind profile setup
% figure
% scatter3(params.geom.locationSpeakers(1,:), params.geom.locationSpeakers(2,:), 1e2*ones(size(params.geom.locationSpeakers(2,:))), 50, 'ok')
% hold on
% scatter3(params.geom.locationMics(1,1:nMics/2)    , params.geom.locationMics(2,1:nMics/2)    , 1e2*ones(size(params.geom.locationMics(2,1:nMics/2)    )), 30, '*k')
% scatter3(params.geom.locationMics(1,nMics/2+1:end), params.geom.locationMics(2,nMics/2+1:end), 1e2*ones(size(params.geom.locationMics(1,nMics/2+1:end))), 30, '*k')
% % scatter3(params.geom.locationMics(1,iMic),params.geom.locationMics(2,iMic),-1e2, 300,'xk','LineWidth',3)
% % scatter3(params.geom.locationSpeakers(1,iSpeak),params.geom.locationSpeakers(2,iSpeak),-1e2, 300,'xk','LineWidth',3)
% axis equal
% % xlim([-1.5,1])
% % ylim([-1.5,1])
% xlim([-2,2])
% ylim([-2,2])
% xlabel('x [m]')
% ylabel('y [m]')
% grid off
% [X_quiv, Y_quiv] = meshgrid(linspace(-2,2,16), linspace(-2,2,16));
% y_wind = linspace(-2,2,101);
% [X_temp, Y_temp] = meshgrid(linspace(-2,2,200), linspace(-2,2,200));
% T_oo   = 292.7470848552711 - (Y_temp') * 3 - 273.15;
% load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\code\pivr\user\sallandt\03_windprofileNew\windprofile.mat','splineWind')
% u_oo   = ppval(splineWind, Y_quiv + 4.25) * params.solve.windSpeed;
% u_wind = ppval(splineWind, y_wind + 4.25);
% % quiver3(X_quiv,Y_quiv, 100*ones(size(X_quiv)),u_oo,zeros(size(Y_quiv)),zeros(size(Y_quiv)), 0.3)
% imagesc(linspace(-2,2,200), linspace(-2,2,200), flipMatrixImageSC(T_oo))
% shading interp
% plot3(u_wind-2,y_wind, 100*ones(size(u_wind)),'r','LineWidth',1.5)
% quiver3(zeros(size(y_wind(3:8:end)))-2,y_wind(3:8:end),100*ones(size(y_wind(3:8:end))),u_wind(3:8:end),zeros(size(y_wind(3:8:end))),zeros(size(y_wind(3:8:end))),0,'r','LineWidth',1.5)
% view(2)
% colorbar
% % fill3(params.geom.locationMics(1,1+corr:nMics/2)    , params.geom.locationMics(2,1+corr:nMics/2)    ,100*ones(size(params.geom.locationMics(2,1+corr:nMics/2)    )),[1 0 0])
% % fill3(params.geom.locationMics(1,nMics/2+1+corr:end), params.geom.locationMics(2,nMics/2+1+corr:end),100*ones(size(params.geom.locationMics(2,nMics/2+1+corr:end))),[0 0 1])
% fill(params.geom.locationMics(1,1+corr:nMics/2)    , params.geom.locationMics(2,1+corr:nMics/2)    ,[1 0 0])
% fill(params.geom.locationMics(1,nMics/2+1+corr:end), params.geom.locationMics(2,nMics/2+1+corr:end),[0 0 1])
% if strcmp(params.menu.switch_savePlots,'ON')
%     saveFigTikz('location')
% end

figure
scatter3(params.geom.locationSpeakers(1,:), params.geom.locationSpeakers(2,:), 1e2*ones(size(params.geom.locationSpeakers(2,:))), 50, 'ok')
hold on
scatter3(params.geom.locationMics(1,1:nMics/2)    , params.geom.locationMics(2,1:nMics/2)    , 1e2*ones(size(params.geom.locationMics(2,1:nMics/2)    )), 30, '*k')
scatter3(params.geom.locationMics(1,nMics/2+1:end), params.geom.locationMics(2,nMics/2+1:end), 1e2*ones(size(params.geom.locationMics(1,nMics/2+1:end))), 30, '*k')
% scatter3(params.geom.locationMics(1,iMic),params.geom.locationMics(2,iMic),1e2, 300,'xk','LineWidth',3)
% scatter3(params.geom.locationSpeakers(1,iSpeak),params.geom.locationSpeakers(2,iSpeak),1e2, 300,'xk','LineWidth',3)
axis equal
xlim([-2,2])
ylim([-2,2])
xlabel('x [m]')
ylabel('y [m]')
grid on
[X_quiv, Y_quiv] = meshgrid(linspace(-2,2,16), linspace(-2,2,16));
y_wind = linspace(-2,2,101);
[X_temp, Y_temp] = meshgrid(linspace(-2,2,200), linspace(-2,2,200));
T_oo   = 292.7470848552711 - (Y_temp') * 3 - 273.15;
load('.\data\windprofile_eulerEQ\windprofile.mat','splineWind')
% u_oo   = ppval(splineWind, Y_quiv + 4.25) * params.solve.windSpeed;
u_wind = 0.5*ones(size(y_wind));
% quiver3(X_quiv,Y_quiv, 100*ones(size(X_quiv)),u_oo,zeros(size(Y_quiv)),zeros(size(Y_quiv)), 0.3)
% imagesc(linspace(-2,2,200), linspace(-2,2,200), flipMatrixImageSC(T_oo))
shading interp
% plot3(u_wind-2,y_wind, 100*ones(size(u_wind)),'r','LineWidth',1.5)
% quiver3(zeros(size(y_wind(3:8:end)))-2,y_wind(3:8:end),100*ones(size(y_wind(3:8:end))),u_wind(3:8:end),zeros(size(y_wind(3:8:end))),zeros(size(y_wind(3:8:end))),0,'r','LineWidth',1.5)
view(2)
% colorbar
% fill3(params.geom.locationMics(1,1+corr:nMics/2)    , params.geom.locationMics(2,1+corr:nMics/2)    ,100*ones(size(params.geom.locationMics(2,1+corr:nMics/2)    )),[1 0 0])
% fill3(params.geom.locationMics(1,nMics/2+1+corr:end), params.geom.locationMics(2,nMics/2+1+corr:end),100*ones(size(params.geom.locationMics(2,nMics/2+1+corr:end))),[0 0 1])
fill(params.geom.locationMics(1,1+corr:nMics/2)    , params.geom.locationMics(2,1+corr:nMics/2)    ,[1 0 0])
fill(params.geom.locationMics(1,nMics/2+1+corr:end), params.geom.locationMics(2,nMics/2+1+corr:end),[0 0 1])

keyboard