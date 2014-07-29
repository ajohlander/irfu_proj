%tintS = [irf_time([2004 02 28 07 00 45]) irf_time([2004 02 28 07 01 25])]; 
%tintS = [irf_time([2002 03 27 08 50 10]) irf_time([2002 03 27 08 50 15])]; 
tintS = [irf_time([2002 02 03 04 18 00]) irf_time([2002 02 03 04 19 30])];

indexC1 = find(timeTagsC1.data>tintS(1),1);
indexC3 = find(timeTagsC3.data>tintS(1),1);


if (timeTagsC1.data(indexC1)-timeTagsC3.data(indexC3) > 2)
    indexC3 = indexC3 +1;
elseif (timeTagsC1.data(indexC1)-timeTagsC3.data(indexC3) < -2)
    indexC1 = indexC1+1;
end

spinNum = floor((tintS(2)-tintS(1))/4);
isLinear = 0; % zero means logarithmic
showPolar = 0; % shows ion data over theta as well
cRange = [2,10]; % Range of the colormap
ionPlotRunning = 1;  % Variable to tell Anjo.ion_pol that it is called
                     % from here

pefMatC1 = zeros(31,16*spinNum);

for j = 1:spinNum
pefMatC1(:,16*(j-1)+1:16*(j-1)+16) = ...
    squeeze(sum(double(squeeze(ion3dC1.data(indexC1+(j-1),:,:,:)))))';
end

pefMatC3 = zeros(31,16*spinNum);

for j = 1:spinNum
pefMatC3(:,16*(j-1)+1:16*(j-1)+16) = ...
    squeeze(sum(double(squeeze(ion3dC3.data(indexC3+(j-1),:,:,:)))))';
end

%phiPrime = -linspace(179,179-22.5*(15+16*(spinNum-1)),16*spinNum);
tDiff = (timeTagsC1.data(indexC1+1)-timeTagsC1.data(indexC1))/16;
%tArray = linspace(0,tDiff*16*spinNum,16*spinNum);
%y = double(energyTabC3.data);
ionE = double(energyTabC1.data);

tint = [timeTagsC1.data(indexC1),timeTagsC1.data(indexC1)+tDiff*spinNum*16];
gseMagC1 = local.c_read('B_vec_xyz_gse__C1_CP_FGM_FULL',tint);
absMagC1 = sqrt(sum(gseMagC1(:,2:4)'.^2));

gseMagC3 = local.c_read('B_vec_xyz_gse__C3_CP_FGM_FULL',tint);
absMagC3 = sqrt(sum(gseMagC3(:,2:4)'.^2));



tArrayC1 = linspace(timeTagsC1.data(indexC1),timeTagsC1.data(indexC1+spinNum),spinNum*16);
tArrayC3 = linspace(timeTagsC3.data(indexC3),timeTagsC3.data(indexC3+spinNum),spinNum*16);
tMagC1 =  gseMagC1(:,1)';
tMagC3 =  gseMagC3(:,1)';

% t = timetags.data(n);
% 
% tind = find(R.R(:,1)<t, 1, 'last' );
% if abs(R.R(tind+1,1)-t)<abs(R.R(tind,1)-t)
%     tind = tind+1;
% end
% 
% delta_t = abs(R.R(tind,1)-t)
% 
% 
% Rx = R.R1(tind,2)
 

% Initiate figure
set(0,'defaultLineLineWidth', 1.5);
%fn=figure(61);
if showPolar
    fn = irf_plot(5,'newfigure');
    ah = zeros(1,5);
else
    fn = irf_plot(3,'newfigure');
    ah = zeros(1,3);
end





set(gcf,'PaperUnits','centimeters')
xSize = 20; ySize = 4*(1+(showPolar*2+2));
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
set(gcf,'Position',[10 10 xSize*50 ySize*50])
set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
clear xLeft xSize sLeft ySize yTop

% Plot the ion data
%ah1 = subplot(3,1,1);
ah(1) = irf_panel(fn,'Ion C1');
if isLinear
    nullIndex = find(pefMatC1 == 0);
    pefMatC1(nullIndex) = NaN;
    hsf = surf(tArrayC1,log10(ionE),pefMatC1);
    h = colorbar;
    ylabel(h, {'dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 15)
else
    hsf = surf(ah(1),tArrayC1,log10(ionE),log10(pefMatC1));
    set(hsf,'edgecolor','none')



    %ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
    %ylabel(h, {'log_{10}F', '[s^{3} km^{-6}] '},'FontSize', 15)

end
ylabel(ah(1),'log_{10}(E) [eV] ','FontSize', 16)
view(ah(1),2)
%xlim([0,16*spinNum*tDiff])
%xlim(ah(1),[min(tArrayC1),max(tArrayC3)])
irf_legend(ah(1),{'C1\_CP\_CIS-HIA\_HS\_MAG\_IONS\_PSD'},[0.02, 0.03])
set(gca,'xticklabel',[])


%ah2 = subplot(3,1,2);'
ah(2) = irf_panel(fn,'Ion C3');
if isLinear
    nullIndex = find(pefMatC1 == 0);
    pefMatC1(nullIndex) = NaN;
    hsf = surf(ah(2),tArrayC3,log10(ionE),pefMatC3);


    ylabel(h, {'dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 15)
else
    hsf = surf(ah(2),tArrayC3,log10(ionE),log10(pefMatC3));
    set(hsf,'edgecolor','none')
    h = colorbar;
    %ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 14)
%     ylabel(h, {'log_{10}F', '[s^{3} km^{-6}] '},'FontSize', 15)


end
ylabel(ah(2),'log_{10}(E) [eV] ','FontSize', 16)
view(ah(2),2)
%xlim([0,16*spinNum*tDiff])
%xlim(ah(2),[min(tArrayC1),max(tArrayC3)])
irf_legend(ah(2),{'C3\_CP\_CIS-HIA\_HS\_MAG\_IONS\_PSD'},[0.02, 0.03])
set(gca,'xticklabel',[])

%ah3 = subplot(3,1,3);
if showPolar
    Anjo.ion_pol
end

ah(3) = irf_panel(fn,'Mag C1 C3');

    
hold(ah(3))
%set(gca,'ColorOrder',[[0 0 1],[0 1 0]]);
plot(ah(3),tMagC1,absMagC1,'b','LineWidth',2)
plot(ah(3),tMagC3,absMagC3,'r','LineWidth',2)
hold off
%xlim([min(tArrayC1),max(tArrayC3)])
set(gca,'ColorOrder',[[0 0 1];[1 0 0]]);
irf_legend(gca,{'C1','C3'},[0.02 0.95])%,'color',[[0,0,1];[1,0,0]])


for i = 1:length(ah)
    xlim(ah(i),[min(tArrayC1),max(tArrayC3)])
    caxis(ah(i),cRange)
    set(ah(i),'XTickLabel','')
end

irf_timeaxis(ah(3));


% irf_plot(ah3,gseMagC1);
% ylabel(ah3,'B [nT] GSM');
% irf_zoom(hca,'y',[-25 15])
% irf_legend(ah3,{'B_X','B_Y','B_Z'},[0.98 0.05])


%# find current position [x,y,width,height]
pos3 = get(ah(3),'Position');
pos1 = get(ah(1),'Position');

%# set width of second axes equal to first
pos3(3) = pos1(3);
set(ah(3),'Position',pos3)
grid(ah(3))

ylabel('|B| [nT] ','FontSize', 16)

h = colorbar('Position',[0.92,pos3(2)+pos3(4),0.02,pos3(4)*(showPolar*2+2)]);

ylabel(h, {'log_{10}F       [s^{3} km^{-6}] '},'FontSize', 15)

ionPlotRunning = 0;