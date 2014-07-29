index = indexC1+2;


pef1 = squeeze(double(squeeze(ion3dC1.data(index,:,:,:))));
pef2 = squeeze(double(squeeze(ion3dC1.data(index+1,:,:,:))));
middleIndex1 = 3;

[ionComb, dT1, newPhi1] = Anjo.getCombSpin(pef1,pef2,middleIndex1,phi);

combTime = timeTagsC1.data(index)+dT1;
polComb = zeros(8,31);

for i = 1:16
    polComb = polComb + squeeze(ionComb(:,i,:));
end

phi = double(phiC3.data);
theta = linspace(180-11.25,11.25,8);


pefSize = 1;


% Initiate figure
set(0,'defaultLineLineWidth', 1.5);
%fm3=figure(38);
fm3 = irf_plot(1,'newfigure');
% clf reset;
% clear h;
set(fm3,'color','white'); % white background for figures (default is grey)
% set(gcf,'PaperUnits','centimeters')
% xSize = 12.67; ySize = 12.67;
% xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
% set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
% set(gcf,'Position',[10 10 xSize*50 ySize*50])
set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
clear xLeft xSize sLeft ySize yTop


nPhi = 16; %Number of phi values
sb = zeros(1,nPhi);
startInd = 1;
dT2 = zeros(1,nPhi);
nRow = ceil(nPhi/2);

for i = startInd:startInd + nPhi-1
    m = i-startInd+1;
    
    middleIndex2 = i;
    [ionPart, dT2(m),newPhi2] = Anjo.getPartSpin(ionComb,middleIndex2,pefSize,newPhi1);
    % partTime = combTime + dT2;
    %polPart = zeros(8,31);
    
    
%     for j = 1:pefSize
%         polPart = polPart + squeeze(ionPart(:,j,:));
%     end
    polPart = squeeze(ionPart);
    
    
    margin = 0.1;

    
    if(floor(m/2) == m/2) %Even
        sb(m) = subplot('position',[0.5 1-(m/2)/nRow+0.1 0.35 .5/(nRow-1)]);
    else %odd
        sb(m) = subplot('position',[0.1 1-((m+1)/2)/nRow+0.1 0.35 .5/(nRow-1)]);
    end
%     if(m<3)
%         sb(m) = subplot('position',[0.1+0.4*(m-1), 0.60, .38, .42]);
%     else
%         sb(m) = subplot('position',[0.1+0.4*(m-3), 0.1, .38, .42]);
%         
%     end
    
    hsf = surf(sb(m),log10(y),theta,log10(polPart),'EdgeColor', 'none');
    view(2)
    
    %h = colorbar;
    %ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 16)
    view(2)
    if (m/2 ~= ceil(m/2))
        ylabel('Polar angle \theta [deg]','FontSize', 15)
    end
    
    
    if(m >= nPhi-1)
        xlabel('log_{10}Energy [keV]','FontSize', 15)
    end
        
        %h = colorbar;
    %ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 16)
    %xlim([min(tArrayC1),max(tArrayC3)])
    ylim([0,180])
    caxis([2,9])
    grid off
    %str = sprintf('$$\varphi$$','Interpreter','latex')
    title(['$$\varphi$$ = ',num2str(newPhi2), '$$^\circ$$'],'Interpreter','latex','FontSize', 16);
    
end
suptitle(Anjo.fastDate(combTime+dT2(1),1))

h = colorbar;
set(h, 'Position', [.92, 0.06 , .03, .83]);
%ylabel(h, {'log_{10}dEF', '[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}] '},'FontSize', 15)

