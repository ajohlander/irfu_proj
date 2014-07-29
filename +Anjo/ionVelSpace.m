%Better than the old one


%pef(theta,phi,energy)


index = indexC1-2;
%index = 2748;

timeTags = timeTagsC1.data;

fVelSpace = zeros(1,4);

for m = 3:6
    pef = squeeze(double(ion3dC1.data(index+m,:,:,7:31)));
    %pef = squeeze(double(ion3dC3.data(index+m,:,:,7:31)));
    
    % %---TEST---------
    % pef = zeros(8,16,24);
    % pef(5,7,2)=100; % +x
    % pef(5,3,2)=200; % +y
    % pef(1,2,24)=300;% zero
    % pef(5,13,2)=400;% 1/sqrt(2)*(-x -y)
    % pef(8,12,2)=500; % +z
    % %-------------------------------
    
    
    
    vMat = zeros(8,16,25,3);
    
    phi = double(phiC3.data);
    theta = linspace(180-11.25,11.25,8);
    
    energy = 1e4*[0.5221330 0.3925840...
        0.2951780   0.2219400   0.1668730   0.1254690...
        0.0943390   0.0709320   0.0533320   0.0401000...
        0.0301500   0.0226700   0.0170450   0.0128160...
        0.0096360   0.0072450   0.0054480   0.0040960...
        0.0030800   0.0023160   0.0017410   0.0013090...
        0.0009840   0.0007400   0.0005560];
    
    
    mi = 1.67262178e-27;
    velocity = sqrt(2*energy*1.602e-19/mi)/1000;
    normalVector = [-1 0 0];
    maxVar=[0,0,1];
    % normalVector = [-0.94, 0.33, -0.08];
    % maxVar = [0.24,0.89,0.38];
    
    
    
    for i = 1:8
        for j = 1:16
            for k = 1:25
                vMat(i,j,k,:) = Anjo.gse2nmr([velocity(k),theta(i),phi(j)],maxVar,normalVector);
            end
        end
    end
    
    nBins = 50;
    
    pefZX = zeros(nBins);
    pefYX = zeros(nBins);
    pefZY = zeros(nBins);
    
    eVec = linspace(-max(energy),max(energy),nBins);
    vVec = linspace(-max(velocity),max(velocity),nBins);
    
    
    
    for i = 1:8
        for j = 1:16
            for k = 1:25
                xIndex = Anjo.findClosestIndex(vMat(i,j,k,1),vVec);
                yIndex = Anjo.findClosestIndex(vMat(i,j,k,2),vVec);
                zIndex = Anjo.findClosestIndex(vMat(i,j,k,3),vVec);
                
                pefYX(yIndex,xIndex) = pefYX(yIndex,xIndex) + pef(i,j,k);
                pefZX(zIndex,xIndex) = pefZX(zIndex,xIndex) + pef(i,j,k);
                pefZY(zIndex,yIndex) = pefZY(zIndex,yIndex) + pef(i,j,k);
            end
        end
    end
    
    
    % pefZX(pefZX==0) = 1;
    % pefZX = log10(pefZX);
    
    % Best line of code ever!
    pefYX(pefYX == 0) = min(min(min(pefYX(pefYX ~= 0))));
    %-------------------------
    
    fVelSpace(m-2) = irf_plot(1,'newfigure');
    
    set(gcf,'PaperUnits','centimeters')
    xSize = 10; ySize = 8.7;
    xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
    set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
    set(gcf,'Position',[10 10 xSize*50 ySize*50])
    set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
    clear xLeft xSize sLeft ySize yTop
    hold on
    
    %set(0,'defaulttextfontsize',18)
    surf(vVec,vVec,log10(pefYX'),'EdgeColor', 'none')
    plot3([-1000,1000],[0,0],[1e15,1e15],'k','LineWidth',2)
    plot3([0,0],[-1000,1000],[1e15,1e15],'k','LineWidth',2)
    view(2)
    xlabel('v_{y}    [km s^{-1}]','FontSize', 15)
    
    ylabel('v_{x}     [km s^{-1}]','FontSize', 15)
    
    
    
    xlim([-1000,1000]*1)
    ylim([-1000,1000]*1)
    
    axis equal
    
    h = colorbar;
    %colormap(b2r(0,10))
    %colormap(flipud(gray))
    %ylabel(h,{'dEF' ,'[keV cm^{-2} s^{-1} sr^{-1} keV^{-1}'},'FontSize', 14);
    %caxis([0 2.5e8])
    caxis([6,10])
    
    
    
    title(Anjo.fastDate(timeTags(index+m),0));
end

