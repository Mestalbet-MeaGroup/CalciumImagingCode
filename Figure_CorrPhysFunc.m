close all;
for i=1:size(DataSet,2)
ClusterIDs = ClusterNearbyROI(~DataSet{i}.mask);
[NCorrsm,ind,~]=DendrogramOrderMatrix2(DataSet{i}.A2Acorrmat);
axis('off');
maximize(gcf);
export_fig(['ROImap_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
close all;
figure;
imagesc(DataSet{i}.A2Acorrmat(ind,ind)); 
set(gca,'XTick',1:size(DataSet{i}.A2Acorrmat,1),'XTickLabel',ind,'YTick',1:size(DataSet{i}.A2Acorrmat,1),'YTickLabel',ind,'TickDir','out','PlotBoxAspectRatio',[1,1,1],'Ticklength', [0 0]);
[xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(ind));
maximize(gcf);
export_fig(['CorrMapA2A_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.eps'],'-native');
close all;
end

close all;
for i=1:size(DataSet,2)
ClusterIDs = ClusterNearbyROI(~DataSet{i}.mask);
[NCorrsm,ind,inda]=DendrogramOrderMatrix2(DataSet{i}.A2Ncorrmat);
close all;
figure;
imagesc(DataSet{i}.A2Ncorrmat(ind,inda)); 
set(gca,'XTick',1:size(DataSet{i}.A2Ncorrmat,2),'XTickLabel',inda,'YTick',1:size(DataSet{i}.A2Ncorrmat,1),'YTickLabel',ind,'TickDir','out');
[xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(inda),'x'); set(findobj(gcf,'-property','Ticklength'),'Ticklength', [0 0]);
export_fig(['CorrMapA2N_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
close all;
end

close all;
for i=1:size(DataSet,2)
[NCorrsm,ind,~]=DendrogramOrderMatrix2(DataSet{i}.N2Ncorrmat);
close all;
figure;
imagesc(DataSet{i}.N2Ncorrmat(ind,ind)); 
set(gca,'XTick',1:4:size(DataSet{i}.N2Ncorrmat,2),'XTickLabel',ind(1:4:end),'YTick',2:2:size(DataSet{i}.N2Ncorrmat,1),'YTickLabel',ind(2:2:end),'FontSize',5,'TickDir','out','PlotBoxAspectRatio',[1,1,1]);
set(gca,'XAxisLocation','bottom','YAxisLocation','left'); colorbar;
maximize(gcf);
export_fig(['CorrMapN2N_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png']);
close all;
end

% check why corr values for i=4 are above one. 



% close all;
% for i=1:size(DataSet,2)
% ClusterIDs = ClusterNearbyROI(~DataSet{i}.mask);
% [NCorrsm,ind,~]=DendrogramOrderMatrix2(DataSet{i}.A2Alagmat);
% figure;
% imagesc(DataSet{i}.A2Alagmat(ind,ind)); 
% set(gca,'XTick',1:size(DataSet{i}.A2Alagmat,1),'XTickLabel',ind,'YTick',1:size(DataSet{i}.A2Alagmat,1),'YTickLabel',ind);
% [xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(ind));
% maximize(gcf);
% % export_fig(['LagMap_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
% % close all;
% end