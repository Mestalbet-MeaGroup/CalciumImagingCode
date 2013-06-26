close all;
for i=1:8
CorrMatSB = CorrMatSB2;
CorrMatNsb = CorrMatNsb2;
    [NCorrsNsb,NccOrderNsb,AccOrderNsb]=DendrogramOrderMatrix2(CorrMatNsb{i}');
    [NCorrsSB,NccOrderSB,AccOrderSB]=DendrogramOrderMatrix2(CorrMatSB{i}');

    [~,indexSB] = RemoveNanGroups(NCorrsSB);
    [~,indexNsb] = RemoveNanGroups(NCorrsNsb);
    indexSB = find(indexSB==0,1,'First');
    indexNsb = find(indexNsb==0,1,'First');
    upto = max([indexSB,indexNsb]);
    NCorrsNsb=NCorrsNsb(1:upto,1:upto);
    NccOrderNsb=NccOrderNsb(1:upto);
    AccOrderNsb=AccOrderNsb(1:upto);
    NCorrsSB=NCorrsSB(1:upto,1:upto);
    NccOrderSB=NccOrderSB(1:upto);
    AccOrderSB=AccOrderSB(1:upto);
    sbByNsb = CorrMatSB{i}'; 
    sbByNsb=sbByNsb(NccOrderNsb,AccOrderNsb);
%     subplot(1,3,1);
 figure('renderer','zbuffer');
    imagescnan(NCorrsNsb); %colorbar;
%     set(gca,'YTick',1:numel(NccOrderNsb),'YTickLabels',NccOrderNsb,'PlotBoxAspectRatio',[1 1 1]);
%     set(gca,'XTick',1:numel(AccOrderNsb),'XTickLabels',AccOrderNsb);
    set(gca,'YTick',[],'YTickLabels',[],'PlotBoxAspectRatio',[1 1 1]);
    set(gca,'XTick',[],'XTickLabels',[]);
    axis('tight');
    title(['Non SuperBursting Regime ' num2str(i)]);
    
%     subplot(1,3,2);
figure('renderer','zbuffer');
    imagescnan(sbByNsb);%colorbar;
    set(gca,'YTick',[],'YTickLabels',[],'PlotBoxAspectRatio',[1 1 1]);
    set(gca,'XTick',[],'XTickLabels',[]);
%     set(gca,'YTick',1:numel(NccOrderNsb),'YTickLabels',NccOrderNsb,'PlotBoxAspectRatio',[1 1 1]);
%     set(gca,'XTick',1:numel(AccOrderNsb),'XTickLabels',AccOrderNsb);
axis('tight');
    title(['SuperBursting Regime Ordered by Non-super-bursting ' num2str(i)])
%     subplot(1,3,3)
figure('renderer','zbuffer');
    imagescnan(NCorrsSB);%colorbar;
    set(gca,'YTick',[],'YTickLabels',[],'PlotBoxAspectRatio',[1 1 1]);
    set(gca,'XTick',[],'XTickLabels',[]);
%     set(gca,'YTick',1:numel(NccOrderSB),'YTickLabels',NccOrderSB,'PlotBoxAspectRatio',[1 1 1]);
%     set(gca,'XTick',1:numel(AccOrderSB),'XTickLabels',AccOrderSB);
axis('tight');    
title(['SuperBursting Regime ' num2str(i)] );

end
