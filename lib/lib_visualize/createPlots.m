close all
dim = '3D';
saveFigures = 'OFF';

switch dim
    case '2D'
%         %% no wind
%         load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\2D\acousticContrastAndReproductionErrorNoWind.mat'...
%             ,'freqs','acousticContrastGradDescentNoWind','acousticContrastMatInverseNoWindNoReg','reproductionErrorGradDescentNoWind','reproductionErrorMatInverseNoWindNoReg')
% 
%         figure
%         subplot(1,2,1)
%         plot(freqs,acousticContrastGradDescentNoWind,'o-r','DisplayName','gradient descent')
%         hold on
%         plot(freqs,acousticContrastMatInverseNoWindNoReg,'o-b','DisplayName','matrix inversion')
%         xlabel('frequency $f$ [Hz]')
%         ylabel('acoustic contrast [dB]')
%         legend('Location','southeast')
% 
%         subplot(1,2,2)
%         plot(freqs,reproductionErrorGradDescentNoWind,'o-r','DisplayName','gradient descent')
%         hold on
%         plot(freqs,reproductionErrorMatInverseNoWindNoReg,'o-b','DisplayName','matrix inversion')
%         xlabel('frequency $f$ [Hz]')
%         ylabel('reproduction error [dB]')
%         legend
% 
%         %% medium (2.83m/s) / high wind (6.95m/s)
%         load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\2D\acousticContrastAndReproductionErrorWithWind.mat'...
%             ,'freqs','acousticContrastMediumWindON','acousticContrastMediumWindOFF','reproductionErrorHighWindON','reproductionErrorHighWindOFF',...
%                      'acousticContrastHighWindON',  'acousticContrastHighWindOFF',  'reproductionErrorMediumWindON','reproductionErrorMediumWindOFF')
%         figure
%         subplot(1,2,1)
%         plot(freqs,acousticContrastMediumWindON,'o-r','DisplayName','medium wind considered')
%         hold on
%         plot(freqs,acousticContrastMediumWindOFF,'o-b','DisplayName','medium wind neglected')
%         plot(freqs,acousticContrastHighWindON,'x-r','DisplayName','high wind considered')
%         plot(freqs,acousticContrastHighWindOFF,'x-b','DisplayName','high wind neglected')
%         xlabel('frequency [Hz]')
%         ylabel('acoustic contrast [dB]')
%         legend('Location','northwest')
% 
%         subplot(1,2,2)
%         plot(freqs,reproductionErrorMediumWindON,'o-r','DisplayName','medium wind considered')
%         hold on
%         plot(freqs,reproductionErrorMediumWindOFF,'o-b','DisplayName','medium wind neglected')
%         plot(freqs,reproductionErrorHighWindON,'x-r','DisplayName','high wind considered')
%         plot(freqs,reproductionErrorHighWindOFF,'x-b','DisplayName','high wind neglected')
%         xlabel('frequency [Hz]')
%         ylabel('reproduction error [dB]')
%         legend
% 
%         %% surface wind (many wind 0:1:10m/s)
%         load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\2D\acousticContrastAndReproductionErrorMany.mat'...
%             ,'freqs','cs','acousticContrastsManyON','acousticContrastsManyOFF','reproductionErrorsManyON','reproductionErrorsManyOFF')
% 
%         cUpperContrast = ceil( max([acousticContrastsManyON, acousticContrastsManyOFF ],[],'all')/10)*10;
%         cLowerContrast = floor(min([acousticContrastsManyON, acousticContrastsManyOFF ],[],'all')/10)*10;
%         cUpperRepError = ceil( max([reproductionErrorsManyON,reproductionErrorsManyOFF],[],'all')/10)*10;
%         cLowerRepError = floor(min([reproductionErrorsManyON,reproductionErrorsManyOFF],[],'all')/10)*10;
% 
%         figure
%         subplot(1,2,1)
%         imagesc(freqs, cs, flipMatrixImageSC(reproductionErrorsManyON))
%         set ( gca, 'ydir', 'normal' )
%         xlabel('frequency [Hz]')
%         ylabel('wind speed [ms$^{-1}$]')
%         cb = colorbar;
%         cb.Label.Interpreter = 'LaTeX';
%         cb.Label.String = 'reproduction error, wind considered [dB]';
%         caxis([cLowerRepError cUpperRepError])
% 
%         subplot(1,2,2)
%         imagesc(freqs, cs, flipMatrixImageSC(reproductionErrorsManyOFF))
%         set ( gca, 'ydir', 'normal' )
%         xlabel('frequency [Hz]')
%         ylabel('wind speed [ms$^{-1}$]')
%         cb = colorbar;
%         cb.Label.Interpreter = 'LaTeX';
%         cb.Label.String = 'reproduction error, wind neglected [dB]';
%         caxis([cLowerRepError cUpperRepError])
% 
%         figure
%         subplot(1,2,1)
%         imagesc(freqs, cs, flipMatrixImageSC(acousticContrastsManyON))
%         set ( gca, 'ydir', 'normal' )
%         xlabel('frequency [Hz]')
%         ylabel('wind speed [ms$^{-1}$]')
%         cb = colorbar;
%         cb.Label.Interpreter = 'LaTeX';
%         cb.Label.String = 'acoustic contrast, wind considered [dB]';
%         caxis([cLowerContrast cUpperContrast])
% 
%         subplot(1,2,2)
%         imagesc(freqs, cs, flipMatrixImageSC(acousticContrastsManyOFF))
%         set ( gca, 'ydir', 'normal' )
%         xlabel('frequency [Hz]')
%         ylabel('wind speed [ms$^{-1}$]')
%         cb = colorbar;
%         cb.Label.Interpreter = 'LaTeX';
%         cb.Label.String = 'acoustic contrast, wind neglected [dB]';
%         caxis([cLowerContrast cUpperContrast])
    case '3D'
        %% no wind
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\comparisonMatInverseBFGS.mat'...
            ,'freqs','acousticContrastBFGSNoWindNoReg','acousticContrastMatInverseNoWindNoReg','acousticContrastMiddleMicNoWindNoReg','reproductionErrorBFGSNoWindNoReg','reproductionErrorMatInverseNoWindNoReg','reproductionErrorMiddleMicNoWindNoReg')
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\valuesPaper.mat'...
            ,'freqsPaper','acousticContrastPaper','reproductionErrorPaper')
        
        figure
        subplot(1,2,1)
        plot(freqs,acousticContrastBFGSNoWindNoReg,'o-r','DisplayName','BFGS')
        hold on
        plot(freqs,acousticContrastMatInverseNoWindNoReg,'x-b','DisplayName','matrix inversion')
        plot(freqsPaper,acousticContrastPaper,'-.k','DisplayName','reference')
        xlabel('frequency $f$ [Hz]')
        ylabel('acoustic contrast [dB]')
        legend('Location','southeast')

        subplot(1,2,2)
        plot(freqs,reproductionErrorBFGSNoWindNoReg,'o-r','DisplayName','BFGS')
        hold on
        plot(freqs,reproductionErrorMatInverseNoWindNoReg,'x-b','DisplayName','matrix inversion')
        plot(freqsPaper,reproductionErrorPaper,'-.k','DisplayName','reference')
        xlabel('frequency $f$ [Hz]')
        ylabel('reproduction error [dB]')
        legend('Location','northwest')
        
        %% comparison with mic in middle or not
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\recreationPaper.mat'...
            ,'freqs','acousticContrastMatInverseNoWindReg','acousticContrastMiddleMicNoWindReg','reproductionErrorMatInverseNoWindReg','reproductionErrorMiddleMicNoWindReg')
        
        figure
        plot(freqs,acousticContrastMiddleMicNoWindNoReg,'o-r','DisplayName','mic mid, $\lambda=0$')
        hold on
        plot(freqs,acousticContrastMiddleMicNoWindReg,'x-.r','DisplayName','mic mid, $\lambda=0.1$')
        plot(freqs,acousticContrastMatInverseNoWindNoReg,'o-b','DisplayName','no mic mid, $\lambda=0$')
        plot(freqs,acousticContrastMatInverseNoWindReg,'x-.b','DisplayName','no mic mid, $\lambda=0.1$')
        plot(freqsPaper,acousticContrastPaper,'-.k','DisplayName','reference')
        xlabel('frequency $f$ [Hz]')
        ylabel('acoustic contrast AC [dB]')
        grid on
        legend('Location','southeast')

        figure
        plot(freqs,reproductionErrorMiddleMicNoWindNoReg,'o-r','DisplayName','mic mid, $\lambda=0$')
        hold on
        plot(freqs,reproductionErrorMiddleMicNoWindReg,'x-.r','DisplayName','mic mid, $\lambda=0.1$')
        plot(freqs,reproductionErrorMatInverseNoWindNoReg,'o-b','DisplayName','no mic mid, $\lambda=0$')
        plot(freqs,reproductionErrorMatInverseNoWindReg,'x-.b','DisplayName','no mic mid, $\lambda=0.1$')
        plot(freqsPaper,reproductionErrorPaper,'-.k','DisplayName','reference')
        xlabel('frequency $f$ [Hz]')
        ylabel('reproduction error RE [dB]')
        grid on
        legend('Location','northwest')
        
        %% noise effect
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\noise.mat'...
            ,'freqs','noiseLevels','acousticContrastSTD0','acousticContrastSTD2','acousticContrastSTD5','reproductionErrorSTD0','reproductionErrorSTD2','reproductionErrorSTD5'...
            ,'acousticContrastUniform','reproductionErrorUniform')
        noiseLevels = -noiseLevels;
        stds = [0,2,5];
        for iSubplot=1:length(stds)
            figure
            eval(['plot(freqs,reproductionErrorSTD' num2str(stds(iSubplot)) ',''o-'')'])
            hold on
            plot(freqsPaper,reproductionErrorPaper,'-.k')
            legend(['SNR ' num2str(noiseLevels(1)) 'dB'], ['SNR ' num2str(noiseLevels(2)) 'dB'], ['SNR ' num2str(noiseLevels(3)) 'dB'], 'reference','Location','northwest')
            xlabel('frequency $f$ [Hz]')
            ylabel('reproduction error [dB]')
            grid on
            if strcmp(saveFigures,'ON')
                saveFigTikz(['repErrGaussianDistSTD' num2str(stds(iSubplot)) 'dB'])
            end
        end
        figure
        plot(freqs,reproductionErrorUniform,'o-')
        hold on
        plot(freqsPaper,reproductionErrorPaper,'-.k')
        legend(['SNR ' num2str(noiseLevels(1)) 'dB'], ['SNR ' num2str(noiseLevels(2)) 'dB'], ['SNR ' num2str(noiseLevels(3)) 'dB'], 'reference','Location','northwest')
        xlabel('frequency [Hz]')
        ylabel('reproduction error [dB]')
        grid on
        if strcmp(saveFigures,'ON')
            saveFigTikz(['repErrUniformDistdB'])
        end
        
        stds = [0,2,5];
        for iSubplot=1:length(stds)
            figure
            eval(['plot(freqs,acousticContrastSTD' num2str(stds(iSubplot)) ',''o-'')'])
            hold on
            plot(freqsPaper,acousticContrastPaper,'-.k')
            legend(['SNR ' num2str(noiseLevels(1)) 'dB'], ['SNR ' num2str(noiseLevels(2)) 'dB'], ['SNR ' num2str(noiseLevels(3)) 'dB'], 'reference','Location','northwest')
            xlabel('frequency [Hz]')
            ylabel('acoustic contrast [dB]')
            grid on
            if strcmp(saveFigures,'ON')
                saveFigTikz(['acContrGaussianDistSTD' num2str(stds(iSubplot)) 'dB'])
            end
        end
        figure
        plot(freqs,acousticContrastUniform,'o-')
        hold on
        plot(freqsPaper,acousticContrastPaper,'-.k')
        legend(['SNR ' num2str(noiseLevels(1)) 'dB'], ['SNR ' num2str(noiseLevels(2)) 'dB'], ['SNR ' num2str(noiseLevels(3)) 'dB'], 'reference','Location','northwest')
        xlabel('frequency [Hz]')
        ylabel('acoustic contrast [dB]')
        grid on
        if strcmp(saveFigures,'ON')
            saveFigTikz(['acContrUniformDistdB'])
        end
%         %% medium (2.83m/s) / high wind (6.95m/s)
%         load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\windOnOff.mat'...
%             ,'freqs','acousticContrastMediumWindON','acousticContrastMediumWindOFF','reproductionErrorHighWindON','reproductionErrorHighWindOFF',...
%                      'acousticContrastHighWindON',  'acousticContrastHighWindOFF',  'reproductionErrorMediumWindON','reproductionErrorMediumWindOFF')
%         figure
%         subplot(1,2,1)
%         plot(freqs,acousticContrastMediumWindON,'o-r','DisplayName','medium wind considered')
%         hold on
%         plot(freqs,acousticContrastMediumWindOFF,'o-b','DisplayName','medium wind neglected')
%         plot(freqs,acousticContrastHighWindON,'x-r','DisplayName','high wind considered')
%         plot(freqs,acousticContrastHighWindOFF,'x-b','DisplayName','high wind neglected')
%         plot(freqsPaper,acousticContrastPaper,'-.k','DisplayName','reference')
%         xlabel('frequency [Hz]')
%         ylabel('acoustic contrast [dB]')
%         legend('Location','northwest')
% 
%         subplot(1,2,2)
%         plot(freqs,reproductionErrorMediumWindON(:,:,2),'o-r','DisplayName','medium wind considered')
%         hold on
%         plot(freqs,reproductionErrorMediumWindOFF(:,:,2),'o-b','DisplayName','medium wind neglected')
%         plot(freqs,reproductionErrorHighWindON(:,:,2),'x-r','DisplayName','high wind considered')
%         plot(freqs,reproductionErrorHighWindOFF(:,:,2),'x-b','DisplayName','high wind neglected')
%         plot(freqsPaper,reproductionErrorPaper,'-.k','DisplayName','reference')
%         xlabel('frequency [Hz]')
%         ylabel('reproduction error [dB]')
%         legend
        
        %% wind considered or not considered
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\windOnOff.mat'...
            ,'freqs','cs','acousticContrastWindConsidered','acousticContrastWindUnconsidered','reproductionErrorWindConsidered','reproductionErrorWindUnconsidered')
        figure
%         % experimental data
%         M(:,1) = [ 0,  1,  2,  3,  4,  5];
%         M(:,3) = [12, 10, 15, 12, 11, 13];
% 
%         % get bounds
%         xmaxa = max(M(:,1))*3.6;    % km/h
%         xmaxb = max(M(:,1));        % m/s
% 
% 
%         figure;
% 
%         % axis for m/s
%         b=axes('Position',[.1 .1 .8 1e-12]);
%         set(b,'Units','normalized');
%         set(b,'Color','none');
% 
%         % axis for km/h with stem-plot
%         a=axes('Position',[.1 .2 .8 .7]);
%         set(a,'Units','normalized');
%         stem(a,M(:,1).*3.6, M(:,3));
% 
%         % set limits and labels
%         set(a,'xlim',[0 xmaxa]);
%         set(b,'xlim',[0 xmaxb]);
%         xlabel(a,'Speed (km/h)')
%         xlabel(b,'Speed (m/s)')
%         ylabel(a,'Samples');
%         title(a,'Double x-axis plot');
        subplot(2,1,1)
        plot(cs, acousticContrastWindConsidered,'o-r','DisplayName','wind considered')
        hold on
        grid on
        plot(cs, acousticContrastWindUnconsidered,'o-b','DisplayName','wind neglected')
        xlabel('wind speed [ms$^{-1}$]')
        ylabel('acoustic contrast [dB]')
        legend('Location','northwest')
        
        subplot(2,1,2)
        plot(cs, squeeze(reproductionErrorWindConsidered(:,:,2))  ,'o-r','DisplayName','wind considered')
        hold on
        grid
        plot(cs, squeeze(reproductionErrorWindUnconsidered(:,:,2)),'o-b','DisplayName','wind neglected')
        xlabel('wind speed [ms$^{-1}$]')
        ylabel('reproduction error [dB]')
        legend('Location','southeast')
        
        %% wind considered or not considered & regularisation parameter - frequency dependend
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\regularisationParamsAndWindONOFFFreqs.mat'...
            ,'freqs','regParams','acousticContrastWindConsiderationON','acousticContrastWindConsiderationOFF','reproductionErrorWindConsiderationON','reproductionErrorWindConsiderationOFF')
        plots = [1 4 5];
        markers = 'xo*.';
        figure
        hold on
        for iPlot = 1:length(plots)
            plot(freqs, acousticContrastWindConsiderationON(:,plots(iPlot)),  ['-' markers(iPlot) 'b'], 'DisplayName', ['wind considered, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        for iPlot = 1:length(plots)
            plot(freqs, acousticContrastWindConsiderationOFF(:,plots(iPlot)),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end

        ylabel('acoustic contrast AC [dB]')
        xlabel('frequency $f$ [Hz]')
        legend
        grid on
        
        figure
        hold on
        for iPlot = 1:length(plots)
            plot(freqs, reproductionErrorWindConsiderationON(:,plots(iPlot)),  ['-' markers(iPlot) 'b'], 'DisplayName', ['wind considered, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        for iPlot = 1:length(plots)
            plot(freqs, reproductionErrorWindConsiderationOFF(:,plots(iPlot)),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end

        ylabel('reproduction error RE [dB]')
        xlabel('frequency $f$ [Hz]')
        legend('Location','northwest')
        grid on
        
        %% wind considered or not considered & regularisation parameter - wind speed dependend
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\regularisationParamsAndWindONOFFMas.mat'...
            ,'cs','regParams','acousticContrastWindConsiderationON','acousticContrastWindConsiderationOFF','reproductionErrorWindConsiderationON','reproductionErrorWindConsiderationOFF')
        plots = [1 4 5];
        markers = 'xo*.';
        figure
        hold on
        for iPlot = 1:length(plots)
            plot(cs/343, acousticContrastWindConsiderationON(:,plots(iPlot)),  ['-' markers(iPlot) 'b'], 'DisplayName', ['wind considered, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        for iPlot = 1:length(plots)
            plot(cs/343, acousticContrastWindConsiderationOFF(:,plots(iPlot)),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        ylim([25 50])
        ylabel('acoustic contrast AC [dB]')
        xlabel('Mach number $M$ [-]')
        legend('Location','southwest')
        grid on
        
        figure
        hold on
        for iPlot = 1:length(plots)
            plot(cs/343, reproductionErrorWindConsiderationON(:,plots(iPlot)),  ['-' markers(iPlot) 'b'], 'DisplayName', ['wind considered, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        for iPlot = 1:length(plots)
            plot(cs/343, reproductionErrorWindConsiderationOFF(:,plots(iPlot)),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end

        ylabel('reproduction error RE [dB]')
        xlabel('Mach number $M$ [-]')
        legend('Location','northwest')
        grid on
        
        %% wind considered or not considered & regularisation parameter - wind speed dependend
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\reproductionErrorOnBoundary.mat'...
            ,'cs','regParams','reproductionErrorOnBoundaryWindConsidered','reproductionErrorOnBoundaryWindNeglected')
        plots = [1 2 3];
        markers = 'xo*.';
        
        figure
        hold on
        for iPlot = 1:length(plots)
            plot(cs/343, reproductionErrorOnBoundaryWindConsidered(plots(iPlot),:),  ['-' markers(iPlot) 'b'], 'DisplayName', ['wind considered, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end
        for iPlot = 1:length(plots)
            plot(cs/343, reproductionErrorOnBoundaryWindNeglected(plots(iPlot),:),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
        end

        ylabel('reproduction error $\RE$ [dB]')
        xlabel('Mach number $\Ma$ [-]')
        legend('Location','northwest')
        grid on
        
        %% training error
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\errorInfluence.mat',...
            'regParams','errors','acousticContrasts','reproductionErrors')
        plots = [1 4 5];
        markers = 'xo*.';
        figure
        hold on
        yyaxis left
        for iPlot = 1:length(plots)
            plot(errors, acousticContrasts(plots(iPlot),:),  ['-' markers(iPlot)], 'DisplayName', ['$\AC$, $\regParam = ' num2str(regParams(plots(iPlot))) '$'])
        end
        ylabel('acoustic contrast $\AC$ [dB]')
        yyaxis right
        for iPlot = 1:length(plots)
            plot(errors, reproductionErrors(plots(iPlot),:),  ['-' markers(iPlot)], 'DisplayName', ['$\RE$, $\regParam = ' num2str(regParams(plots(iPlot))) '$'])
        end
        ylabel('reproduction error $\RE$ [dB]')
%         for iPlot = 1:length(plots)
%             plot(cs/343, acousticContrastWindConsiderationOFF(:,plots(iPlot)),  ['-' markers(iPlot) 'r'], 'DisplayName', ['wind neglected, $\lambda = ' num2str(regParams(plots(iPlot))) '$'])
%         end
%         ylim([25 50])
        
        set(gca, 'XScale', 'log')
        xlabel('mean square error [-]')
        legend('Location','southwest')
        grid on
        grid minor
        grid minor
        
        %% comparison with mic in middle or not with bigger microphonearray
        load('D:\Uni\Technische Universität\Masterarbeit\Arbeit\data\paper\3D\biggerMicArray.mat'...
            ,'freqs','acousticContrastMicMiddle','acousticContrastNoMicMiddle','reproductionErrorMicMiddle','reproductionErrorNoMicMiddle')
        
        figure
        plot(freqs,acousticContrastMicMiddle(:,1),'o-r','DisplayName','mic mid, $\lambda=0$')
        hold on
        plot(freqs,acousticContrastMicMiddle(:,2),'x-.r','DisplayName','mic mid, $\lambda=0.1$')
        plot(freqs,acousticContrastNoMicMiddle(:,1),'o-b','DisplayName','no mic mid, $\lambda=0$')
        plot(freqs,acousticContrastNoMicMiddle(:,2),'x-.b','DisplayName','no mic mid, $\lambda=0.1$')
        plot(freqs,acousticContrastMatInverseNoWindNoReg,'-.m','DisplayName','square length $0.3\unit{m}$')
        xlabel('frequency $f$ [Hz]')
        ylabel('acoustic contrast AC [dB]')
        grid on
        legend('Location','southeast')

        figure
        plot(freqs,reproductionErrorMicMiddle(:,1),'o-r','DisplayName','mic mid, $\lambda=0$')
        hold on
        plot(freqs,reproductionErrorMicMiddle(:,2),'x-.r','DisplayName','mic mid, $\lambda=0.1$')
        plot(freqs,reproductionErrorNoMicMiddle(:,1),'o-b','DisplayName','no mic mid, $\lambda=0$')
        plot(freqs,reproductionErrorNoMicMiddle(:,2),'x-.b','DisplayName','no mic mid, $\lambda=0.1$')
        plot(freqs,reproductionErrorMatInverseNoWindNoReg,'-.k','DisplayName','square length $0.3\unit{m}$')
        xlabel('frequency $f$ [Hz]')
        ylabel('reproduction error RE [dB]')
        grid on
        legend('Location','northwest')
end