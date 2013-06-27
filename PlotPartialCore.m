CorrNsb = abs(CorrMatNsb{8});
SigNsb = SigMatNsb{8};
CorrNsb(SigNsb~=0)=nan;
CorrSB = abs(CorrMatSB{8});
SigSB = SigMatSB{8};
CorrSB(SigSB~=0)=nan;
[NCorrsNsb,~,~]=DendrogramOrderMatrix2(CorrNsb);
[NCorrsSB,~,~]=DendrogramOrderMatrix2(CorrSB);

figure('renderer','zbuffer');
imagescnan(NCorrsNsb,'NanColor',[0.4 0.4 0.4]); %colorbar;
set(gca,'YTick',[],'YTickLabels',[],'PlotBoxAspectRatio',[1 1 1]);
set(gca,'XTick',[],'XTickLabels',[]);
axis('tight');
title('Non SuperBursting Regime');
print(gcf, '-r400', '-dpng', 'ccPartCorrMaxLag_N2N_NsbRegime.png');
close;

figure('renderer','zbuffer');
imagescnan(NCorrsSB,'NanColor',[0.4 0.4 0.4]); %colorbar;
set(gca,'YTick',[],'YTickLabels',[],'PlotBoxAspectRatio',[1 1 1]);
set(gca,'XTick',[],'XTickLabels',[]);
axis('tight');
title('SuperBursting Regime');
print(gcf, '-r400', '-dpng', 'ccPartCorrMaxLag_N2N_SBregime.png');
close;