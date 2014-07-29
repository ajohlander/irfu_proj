% Calculates and plots the angle between the SLAMS and the magnetic field
% over time. Builds on Anjo.ionplot
%
% See also ANJO.IONPLOT


vSlams = 207; %km/s, scalar
nSlams = [-.88 -.17 .45];    %Normal vector of the SLAMS
nSlams = nSlams/sqrt(sum(nSlams.^2)); %Normalized
tSlams = irf_time([2002 02 03 04 18 12.7]);

rCluster = -[10.6959    1.8182   -8.3227];
%nSlams = rCluster/sqrt(sum(rCluster.^2));

t1 = irf_time([2002 02 03 04 18 39]);


tintBn = [irf_time([2002 02 03 04 00 00]) irf_time([2002 02 03 04 40 00])];
gseMagC1 = local.c_read('B_vec_xyz_gse__C1_CP_FGM_FULL',tintBn);
%gseMagC1 = ff;
magPrime = zeros(size(gseMagC1));

magPrime(:,2:4) = gseMagC1(:,2:4);

magPrime(:,1) = -(tSlams-gseMagC1(:,1))*vSlams;
dist = gseMagC1(:,1);

thetaBn = zeros(1,length(gseMagC1));

for i = 1: length(thetaBn)
    thetaBn(i) = acosd(magPrime(i,2:4)*nSlams'...
        /sqrt(sum(magPrime(i,2:4).^2)));
end

thetaBn(thetaBn>90) = 180 - thetaBn(thetaBn>90);


%Smear thetaBn
nSmear = 150;
thetaBnSmeared = zeros(size(thetaBn));

thetaBnSmeared(1:nSmear) = mean(thetaBn(1:nSmear));
thetaBnSmeared(end-nSmear:end) = mean(thetaBn(end-nSmear:end));

for i = nSmear+1 : length(thetaBn)-nSmear-1
    thetaBnSmeared(i) = mean(thetaBn(i-nSmear:i+nSmear));
end


fn = irf_plot(1,'newfigure');
set(gcf,'PaperUnits','centimeters')
xSize = 20; ySize = 10;
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
set(gcf,'Position',[10 10 xSize*50 ySize*50])
set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
clear xLeft xSize sLeft ySize yTop


plot(dist,thetaBnSmeared,'k','LineWidth',2)
hold on

plot([min(dist) max(dist)],[45 45],'k')
plot(tSlams*ones(1,2),[0 90],'k--')
%plot((t1-tSlams)*vSlams*ones(1,2),[0 90],'k--')

xlim([min(dist) max(dist)])
ylim([0 90])

set(fn,'YTick',0:22.5:90)
% set(fn,'XTick',[0 10000 20000 30000 40000]);
% set(fn,'XTickLabel',get(fn,'XTick'))

xlabel('Distance from SLAMS  [km]' )
ylabel('\theta_{Bn}  [deg]')

set(fn,'FontSize',16)
set(get(fn,'XLabel'),'FontSize',16)
set(get(fn,'YLabel'),'FontSize',16)

a = irf_legend(gca,{'quasi-parallel'},[0.93 0.1],'FontSize',16);
irf_legend(gca,{'quasi-perpendicular'},[0.97 0.9],'FontSize',16);
irf_timeaxis(fn)


