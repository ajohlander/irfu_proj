%Builds on anjo.ion_plot and anjo.ionVelSpace


index = indexC1+2;

pefPolC1 = zeros(8,spinNum*16);

pefPolC3 = zeros(8,spinNum*16);

for i = 1:31;
    for j = 1:spinNum
        pefPolC1(:,16*(j-1)+1:16*(j-1)+16) = pefPolC1(:,16*(j-1)+1:16*(j-1)+16) + ...
            squeeze(double(squeeze(ion3dC1.data(indexC1+(j-1),:,:,i))));
    end
end

for i = 1:31;
    for j = 1:spinNum
        pefPolC3(:,16*(j-1)+1:16*(j-1)+16) = pefPolC3(:,16*(j-1)+1:16*(j-1)+16) + ...
            squeeze(double(squeeze(ion3dC3.data(indexC3+(j-1),:,:,i))));
    end
end



phi = double(phiC3.data);
theta = linspace(180-11.25,11.25,8);



if ionPlotRunning
    %Do nothing
else
    fn = irf_plot(2,'newfigure');
    set(0,'defaultLineLineWidth', 1.5);
    % set(fn,'color','white'); % white background for figures (default is grey)
    set(gcf,'PaperUnits','centimeters')
    xSize = 16; ySize = 8;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    ah = zeros(1,2);
end


%Plot over energy and time
%ah(1) = subplot(2,1,1);
ah(4) = irf_panel('Ion Pol C1');
hsf = surf(ah(4),tArrayC1,theta,log10(pefPolC1),'EdgeColor', 'none');
view(ah(4),2)
irf_legend(ah(4),{'C1\_CP\_CIS-HIA\_HS\_MAG\_IONS\_PSD'},[0.02, 0.07])

grid off
ylabel(ah(4),'Polar angle \theta [deg]','FontSize',15)
% h = colorbar;
% ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
set(gca,'xticklabel',[])
xlim(ah(4),[min(tArrayC1),max(tArrayC3)])
ylim(ah(4),[0,180])



%ah(2) = subplot(2,1,2);
ah(5) = irf_panel('Ion Pol C3');
hsf = surf(ah(5),tArrayC3,theta,log10(pefPolC3),'EdgeColor', 'none');
view(ah(5),2)
irf_legend(ah(5),{'C3\_CP\_CIS-HIA\_HS\_MAG\_IONS\_PSD'},[0.02, 0.07])
ylabel(ah(5),'Polar angle \theta [deg]','FontSize',15)
% h = colorbar;
% ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
xlim(ah(5),[min(tArrayC1),max(tArrayC3)])
ylim(ah(5),[0,180])


%irf_timeaxis(ah(1))

if ionPlotRunning
    %Do nothing
else
    irf_timeaxis(ah(5))
end



% % Polar - log10 Flux Plot
% polFlux = zeros(8,31);
%
%
% for i = 1:16
%     polFlux = polFlux + squeeze(double(squeeze(ion3dC1.data(index,:,i,:))));
% end


% fm1 = irf_plot(1,'newfigure');
%
% hsf = surf(log10(y),theta,log(polFlux),'EdgeColor', 'none');
% view(2)
% ylabel('Polar angle \theta [deg]')
% xlabel('log_{10}Energy [keV]')
% h = colorbar;
% ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
% %xlim([min(tArrayC1),max(tArrayC3)])
% ylim([0,180])
% grid off
%
% title(anjo.fast_date(timeTagsC1.data(index),1));
%
%
%
%
%
%
% fm2 = irf_plot(1,'newfigure');
%
% hsf = surf(log10(y),theta,log(polComb),'EdgeColor', 'none');
% view(2)
%
% h = colorbar;
% ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
% view(2)
% ylabel('Polar angle \theta [deg]')
% xlabel('log_{10}Energy [keV]')
% h = colorbar;
% ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
% %xlim([min(tArrayC1),max(tArrayC3)])
% ylim([0,180])
% grid off
%
% title(anjo.fast_date(timeTagsC1.data(index) + (middleIndex1+7)*4.02/16,1));



