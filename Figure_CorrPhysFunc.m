close all;
i=2;
ClusterIDs = ClusterNearbyROI(~DataSet{i}.mask);
[NCorrsm,ind,~]=DendrogramOrderMatrix2(DataSet{i}.A2Acorrmat);
figure;
imagesc(DataSet{i}.A2Acorrmat(ind,ind)); 
set(gca,'XTick',1:size(DataSet{i}.A2Acorrmat,1),'XTickLabel',ind,'YTick',1:size(DataSet{i}.A2Acorrmat,1),'YTickLabel',ind);
[xtextLabels,ytextLabels] = ColorTextLabels(gca,ClusterIDs(ind));