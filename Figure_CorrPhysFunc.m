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
set(gca,'XTick',1:size(DataSet{i}.A2Acorrmat,1),'XTickLabel',ind,'YTick',1:size(DataSet{i}.A2Acorrmat,1),'YTickLabel',ind);
[xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(ind));
maximize(gcf);
export_fig(['CorrMap_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
close all;
end

close all;
for i=1:size(DataSet,2)
ClusterIDs = ClusterNearbyROI(~DataSet{i}.mask);
[NCorrsm,ind,inda]=DendrogramOrderMatrix2(DataSet{i}.A2Ncorrmat);
% axis('off');
% maximize(gcf);
% export_fig(['ROImap_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
close all;
figure;
imagesc(DataSet{i}.A2Ncorrmat(ind,inda)); 
set(gca,'XTick',1:size(DataSet{i}.A2Ncorrmat,2),'XTickLabel',inda,'YTick',1:size(DataSet{i}.A2Ncorrmat,1),'YTickLabel',ind);
[xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(inda),'x');
maximize(gcf);
export_fig(['CorrMapA2N_' num2str(DataSet{i}.culture) ' ' num2str(DataSet{i}.channel) '.png'],'-native');
close all;
end

