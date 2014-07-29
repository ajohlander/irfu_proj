
units = irf_units;
%normalVector = [-0.81 -0.52 0.50];
normalVector = [-1 0 0];
phi = double(phiC3.data);
theta = linspace(180-11.25,11.25,8);

%tSlams = irf_time([2002 04 20 03 47 12]);
tSlams = irf_time([2002 02 03 04 43 05]);


index = find(timeTagsC3.data>tSlams,1);
numSpin = 1;



fn = figure(22);
clf reset;
clear h;
set(fn,'color','white'); % white background for figures (default is grey)
set(gcf,'PaperUnits','centimeters')
xSize = 9*3; ySize = 9*numSpin;
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
set(gcf,'Position',[10 10 xSize*50 ySize*50])
set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
clear xLeft xSize sLeft ySize yTop

ah = zeros(1,3*numSpin);
suptitle(anjo.fast_date(timeTagsC3.data(index),1))
energyTabC3.data =1e4*[2.8898330   2.1728221   1.6337120   1.2283630...
            0.9235880   0.6944320   0.5221330   0.3925840...
            0.2951780   0.2219400   0.1668730   0.1254690...
            0.0943390   0.0709320   0.0533320   0.0401000...
            0.0301500   0.0226700   0.0170450   0.0128160...
            0.0096360   0.0072450   0.0054480   0.0040960...
            0.0030800   0.0023160   0.0017410   0.0013090...
            0.0009840   0.0007400   0.0005560];

for m = 0:numSpin-1
    %pefIsr2 = squeeze(double(ion3dC3.data(index+m,:,:,:)));
    pefIsr2 = zeros(8,16,31);
    pefIsr2(5,7,3) = 100;
    
    pefSnr = zeros(8*16*31,3);
    eSnr = zeros(8*16*31,3);
    count = 1;
    
    
    
    
    
    
    for i = 1:8
        for j = 1:16
            for k = 1:31
                eSnr(count,:) = anjo.gse2snr([energyTabC3.data(k),theta(i),phi(j)],normalVector)';
 
                count = count +1;

                
            end
        end
    end
    %
    % for i = 1:8
    %     for j = 1:16
    %         for k = 1:31
    %             eSnr(count,:) = anjo.sph2car([energyTabC3.data(k),theta(i),phi(j)]);
    %             pefSnr(count,:) = anjo.sph2car([pefIsr2(i,j,k),theta(i),phi(j)]);
    %             count = count+1;
    %         end
    %     end
    % end
    %
    
    velSnr = sign(eSnr) .* (abs(eSnr)*2*units.eV/(units.mp)).^(1/2);
    
    
    nBins = 40;
    pefZX = zeros(nBins);
    pefYX = zeros(nBins);
    pefZY = zeros(nBins);
    
    velMax = sqrt(2*max(energyTabC3.data)*units.eV/(units.mp));
    velVec = linspace(-velMax,velMax,nBins);
    
    xIndex = zeros(1,8*16*31);
    yIndex = zeros(1,8*16*31);
    zIndex = zeros(1,8*16*31);
    
    count = 1;
    
    for i = 1:8
        for j = 1:16
            for k = 1:31
                %     xIndex = anjo.find_closest_index(sign(eSnr(i,1))*sqrt(2*abs(eSnr(i,1))*units.eV/(units.mp)),velVec);
                %     yIndex = anjo.find_closest_index(sign(eSnr(i,2))*sqrt(2*abs(eSnr(i,2))*units.eV/(units.mp)),velVec);
                %     zIndex = anjo.find_closest_index(sign(eSnr(i,3))*sqrt(2*abs(eSnr(i,3))*units.eV/(units.mp)),velVec);
                % %
                %     pefYX(yIndex,xIndex) = pefZX(yIndex,xIndex) + sqrt(sum(pefSnr(i,1).^2));
                %     pefZX(zIndex,xIndex) = pefZX(zIndex,xIndex) + sqrt(sum(pefSnr(i,1).^2));
                %     pefZY(zIndex,yIndex) = pefZY(zIndex,yIndex) + sqrt(sum(pefSnr(i,1).^2));
                
                
                
                xIndex = anjo.find_closest_index(velSnr(count,1),velVec);
                yIndex = anjo.find_closest_index(velSnr(count,2),velVec);
                zIndex = anjo.find_closest_index(velSnr(count,3),velVec);
                
                
                
                pefYX(yIndex,xIndex) = pefZX(yIndex,xIndex) + pefIsr2(i,j,k);
                pefZX(zIndex,xIndex) = pefZX(zIndex,xIndex) + pefIsr2(i,j,k);
                pefZY(zIndex,yIndex) = pefZY(zIndex,yIndex) + pefIsr2(i,j,k);
                count = count+1;
            end
        end
    end
    
    
    
%     logPefZX = log10(pefZX);
%     logPefZX(logPefZX==-inf*ones(nBins))=0;
%     
%     logPefYX = log10(pefYX);
%     logPefYX(logPefYX==-inf*ones(nBins))=0;
%     
%     logPefZY = log10(pefZY);
%     logPefZY(logPefZY==-inf*ones(nBins))=0;
%     
%     
%     
%     
    
    
    if 0
    ah1 = subplot(numSpin,1,m+1);
    hsf = surf(ah1,velVec/1e3,velVec(nBins/2:nBins)/1e3,pefZX(:,nBins/2:nBins)');
    view(2)
    axis equal
    colorbar
    caxis([0,1e8])
    xlim([-2000 2000]/2)
    ylim([0 2000]/2)
    
    
    %----------------------------------------------------------------
    
    
    else
    
    %suptitle(anjo.fast_date(timeTagsC3.data(index),1))
    
    % nullIndex = find(pefYX == 0);
    % pefYX(nullIndex) = NaN;
    % nullIndex = find(pefZX == 0);
    % pefZX(nullIndex) = NaN;
    % nullIndex = find(pefZY == 0);
    % pefZY(nullIndex) = NaN;
    
    ah(m*numSpin+1) = subplot(numSpin,3,1+m*3);
    %hsf = surf(ah1,velVec/1e3,velVec/1e3,log10(pefZX));
    hsf = surf(ah(m*numSpin+1),velVec/1e3,velVec/1e3,pefZX');
    view(2)
    axis equal
    xlabel('v_{z}')
    ylabel('v_{x}')
    %clabel('dEF')
    colorbar
    %caxis([0 8e8])
    %xlim([-2000,2000]/2)
    %ylim([-2000,2000]/2)
    %set(hsf,'edgecolor','none')
    
    
    ah(m*numSpin+2) =subplot(numSpin,3,2+m*3);
    %hsf = surf(ah2,velVec/1e3,velVec/1e3,log10(pefYX));
    hsf = surf(ah(m*numSpin+2),velVec/1e3,velVec/1e3,pefYX');
    view(2)
    axis equal
    xlabel('v_{y}')
    ylabel('v_{x}')
    %clabel('dEF')
    colorbar
    %caxis([0 8e8])
    %xlim([-2000,2000]/2)
    %ylim([-2000,2000]/2)
    %set(hsf,'edgecolor','none')
    
    ah(m*numSpin+3) =subplot(numSpin,3,3+m*3);
    %hsf = surf(ah3,velVec/1e3,velVec/1e3,log10(pefZY));
    hsf = surf(ah(m*numSpin+3),velVec/1e3,velVec/1e3,pefZY');
    view(2)
    axis equal
    xlabel('v_{z}')
    ylabel('v_{y}')
    %clabel('dEF')
    colorbar
    %caxis([0 8e8])
    %xlim([-2000,2000]/2)
    %ylim([-2000,2000]/2)
    %set(hsf,'edgecolor','none')


end
    
end

