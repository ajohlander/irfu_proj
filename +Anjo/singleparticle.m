clear all
nSim = 10;


vX0 = 220;
v0 = [-vX0 0 0]*1e3;% + (rand(1,3)-.5)*5; %m/s
runTime = 60; %s
dT = 0.005;
%L = 2000e3; %simulation size in m

vSlams = 207*1e3; %m/s, scalar, only used for conversion to distance
tStart = irf_time([2002 02 03 04 18 07]);
%nSlams = [-.88 -.17 .45];    %Normal vector of the SLAMS
nSlams = [-1 0 0];
nSlams = nSlams/sqrt(sum(nSlams.^2)); %Normalized, hack

tintSim = [tStart, tStart+13];




%Construct the fields
bField = local.c_read('B_vec_xyz_gse__C3_CP_FGM_FULL',tintSim);

bField(:,1) = -(tStart-bField(:,1))*vSlams;


bComp = compress_field(bField,125,1);


eField = zeros(size(bField))/100;
eField(:,1) = bField(:,1);


% caa_download(tintSim,'C3_CP_EFW_L2_E3D_INERT')
% eField = irf_get_data('E_Vec_xyz_ISR2__C3_CP_EFW_L2_E3D_INERT','caa','mat');
% eField(isnan(eField)) = 0;
% %
% eField(:,1) = -(tStart-eField(:,1))*vSlams;


% Test Field
%
% bField = zeros(nSim,4);
%
% bField(:,1) = linspace(0,1e7,nSim);
%
% eField = bField;
% eField(:,3) = 1;
% bField(:,4) = -5*ones(1,nSim)';
% bComp = bField;

% eField = compress_field(eField,135,3);
% %Smeta E
% nSmear = 1;
% eSmeared = eField;
%
% eSmeared(1:nSmear,2) = mean(eField(1:nSmear,2));
% eSmeared(1:nSmear,3) = mean(eField(1:nSmear,3));
% eSmeared(1:nSmear,4) = mean(eField(1:nSmear,4));
% eSmeared(end-nSmear:end,2) = mean(eField(end-nSmear:end,2));
% eSmeared(end-nSmear:end,3) = mean(eField(end-nSmear:end,2));
% eSmeared(end-nSmear:end,4) = mean(eField(end-nSmear:end,2));
%
%
% for i = nSmear+1 : length(eField)-nSmear-1
%     eSmeared(i,2) = mean(eField(i-nSmear:i+nSmear,2))/2;
%     eSmeared(i,3) = mean(eField(i-nSmear:i+nSmear,3))/2;
%     eSmeared(i,4) = mean(eField(i-nSmear:i+nSmear,4))/2;
% end

% nSmear = 5;
% bSmeared = eField;
%
% bSmeared(1:nSmear,2) = mean(bField(1:nSmear,2));
% bSmeared(1:nSmear,3) = mean(bField(1:nSmear,3));
% bSmeared(1:nSmear,4) = mean(bField(1:nSmear,4));
% bSmeared(end-nSmear:end,2) = mean(bField(end-nSmear:end,2));
% bSmeared(end-nSmear:end,3) = mean(bField(end-nSmear:end,2));
% bSmeared(end-nSmear:end,4) = mean(bField(end-nSmear:end,2));
%
%
% for i = nSmear+1 : length(bField)-nSmear-1
%     bSmeared(i,2) = mean(bField(i-nSmear:i+nSmear,2));
%     bSmeared(i,3) = mean(bField(i-nSmear:i+nSmear,3));
%     bSmeared(i,4) = mean(bField(i-nSmear:i+nSmear,4));
% end
%
if 0
    
    %Calls for the simulation
    [vel,xMin] = Anjo.lorentz_1D(eField,bComp,v0,runTime,dT,nSlams);
    vel(:,2:4) = vel(:,2:4)/1000; %to km/s
    
    
    
    %E-B plot-----------------------------------------------
    
    
    
    fEB = irf_plot(1,'newfigure');
    ha = zeros(1,2);
    
    set(gcf,'PaperUnits','centimeters')
    xSize = 15; ySize = 8;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    
    
    % ha(1) = irf_panel(fEB,'E');
    % eField(:,1) = eField(:,1)/1e3; % to km
    % irf_plot(ha(1),eField)
    % hold(ha(1))
    % plot(ha(1),[xMin, xMin]/1e3, [-10 10],'k')
    % ylabel(ha(1),'E [mV/m]','FontSize',15);
    % xlabel('x [km/s]','FontSize',15);
    % irf_legend(ha(1), {'E_X','E_Y','E_Z'},[0.98 0.05])
    % set(ha(1),'XTickLabel',[])
    
    
    ha(2) = irf_panel(fEB,'B');
    bComp(:,1) = bComp(:,1)/1e3; % to km
    irf_plot(ha(2),bComp,'LineWidth',2)
    hold(ha(2))
    plot(ha(2),[xMin, xMin]/1e3, [-10 10],'k--','LineWidth',2)
    xlabel(ha(2),'Distance [km]','FontSize',15);
    ylabel(ha(2),'B [nT]','FontSize',15);
    irf_legend(ha(2), {'B_X','B_Y','B_Z'},[0.98 0.05])
    
    
    
    
    
    fV = irf_plot(1,'newfigure');
    
    set(gcf,'PaperUnits','centimeters')
    xSize = 15; ySize = 8;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    
    
    irf_plot(fV, vel,'LineWidth',2)
    ylabel('v [km/s]','FontSize',15);
    xlabel('t [s]','FontSize',15);
    irf_legend(fV, {'v_X','v_Y','v_Z'},[0.98 0.05])
    
    
    
    %
    % if(1 && kEn(1) ~= 0)
    % fEnergy = irf_plot(1,'newfigure');
    %
    % kEn = sum((vel(:,2:4)').^2);
    % plot(fEnergy, vel(:,1), kEn/kEn(1),'k')
    % ylabel('Energy [a.u.]','FontSize',15);
    % xlabel('t [s]','FontSize',15);
    % %ylim([0 2])
    % end
    
else
    nVel = 200;
    vx0 = linspace(50,400,nVel);
    vFinal = zeros(nVel,4);
    
    for i = 1:nVel
        v0 = [-vx0(i),0,0]*1e3;
        [vel,xMin] = Anjo.lorentz_1D(eField,bComp,v0,runTime,dT,nSlams);
        
        nanInd = find(isnan(vel(:,2)),1);
        vFinal(i,:) = [vx0(i), vel(nanInd-1,2:4)];
    end
    
    %Plot
    fVec = irf_plot(1,'newfigure');
    
    set(gcf,'PaperUnits','centimeters')
    xSize = 15; ySize = 8;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    
    
    vFinalKm = -vFinal;
    vFinalKm(:,2:4) = vFinal(:,2:4)/1e3;
    irf_plot(fVec,vFinalKm,'LineWidth',2);
    ylabel('v_{f}   [km/s]','FontSize',15);
    xlabel('v_{i}   [km/s]','FontSize',15);
    irf_legend(fVec, {'v_X','v_Y','v_Z'},[0.98 0.05])
    
    %Histogram
    fVxVy = irf_plot(1,'newfigure');
    
    set(gcf,'PaperUnits','centimeters')
    xSize = 15; ySize = 8;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    
    
    vFinalKm = vFinal;
    vFinalKm(:,2:4) = vFinal(:,2:4)/1e3;
    
    downStreamInd = find(vFinal(:,2)<0);
    %plot(vFinalKm(downStreamInd,2),vFinalKm(downStreamInd,3),'*','LineWidth',2);
    hist(vFinalKm(downStreamInd,3),20)
    ylabel('Counts','FontSize',15);
    xlabel('v_{y,f}   [km/s]','FontSize',15);
    
    
end





