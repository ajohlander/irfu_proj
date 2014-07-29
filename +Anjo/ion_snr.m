%

fn = figure(3);
hold on
ax = zeros(1,8);
set(0,'defaultLineLineWidth', 1.5);
% clf reset;
% clear h;
set(fn,'color','white'); % white background for figures (default is grey)
set(gcf,'PaperUnits','centimeters')
xSize = 20; ySize = 10;
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
set(gcf,'Position',[10 10 xSize*50 ySize*50])
set(gcf,'paperpositionmode','auto') % to get the same printing as on screen
clear xLeft xSize sLeft ySize yTop

C = {'k','b','r','c','g'};
h = zeros(1,4);
legendInfo = cell(1,4);

for i = -1:2
tSlams = irf_time([2002 02 01 08 50 22]);
%tSlams = irf_time([2002 02 03 04 43 05]);
%normalVector = [-0.9995, 0.0098, 0.0312];
normalVector = [-0.86, 0.4, 0.31];
phi = double(phiC1.data);
%theta = double(thetaC1.data);
%theta = -theta-min(theta);
theta = linspace(180-11.25,11.25,8);


indexC1 = find(timeTagsC1.data>tSlams,1)+i-1;

pefFullC1 = squeeze(double(ion3dC1.data(indexC1,:,:,:)));

%Sum over energies
pefSq = pefFullC1;%squeeze(sum(pefFullC1,2));
%------------

normalPef = zeros(8,16,31);
% 
% for i = 1:8
%     for j = 1:16
%         pefSnr(i,j,:) = anjo.gse2snr([pefSq(i,j),theta(i),phi(j)],n);
%     end
% end

for k = 1:8
    for m = 1:16
        for n = 1:31
            r = pefSq(k,m,n);
            normalPef(k,m,n) = anjo.sph2car([r, theta(k), phi(m)])*normalVector';
        end
    end
end

% normalPef = squeeze(sum(normalPef)


normalPefSum = squeeze(sum(normalPef,2));
negInd = find(normalPefSum<0);
normalPefSumNeg = zeros(size(normalPefSum));
normalPefSumNeg(negInd) = -normalPefSum(negInd);

% ax(i+2) = subplot(1,4,i+2);
% hsf = surf(theta,log10(energyTabC1.data),log10(normalPefSumNeg)');
% %set(hsf,'edgecolor','none')
% view(2)
% %colorbar
% %caxis([-1e7, 1.5e9])
% caxis([0, 8])
% xlabel('\theta')
% ylabel('E [eV]')
% title(anjo.fast_date(timeTagsC1.data(indexC1),1))

pef = sum(normalPefSumNeg);

h(i+2) = plot(log10(energyTabC1.data),(pef),C{i+2});
%legend(h(i+2),anjo.fast_date(timeTagsC1.data(indexC1),0))
legendInfo{i+2} = anjo.fast_date(timeTagsC1.data(indexC1),0);

end



%hold off
legend(legendInfo)


title('Ion flux along -normalVector of SLAMS')
xlabel('log_{10}E [eV]')
ylabel('dEF [cm^{-2}s^{-1}sr^{-1}]')
% h=colorbar;
% 
% set(h, 'Position', [0.95 0.07 0.02 0.9])
% for i=1:3
%       pos=get(ax(i), 'Position');
%       set(ax(i), 'Position', [pos(1) pos(2) 0.85*pos(3) pos(4)]);
% end