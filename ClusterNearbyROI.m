function ClusterIDs = ClusterNearbyROI(mask)

cm  = regionprops(mask, 'Centroid');
for i=1:size(cm,1)
cm1(i,1)=cm(i).Centroid(1);
cm1(i,2)=cm(i).Centroid(2);
cmLabel{i}=num2str(i);
end
D = pdist(cm1);
% D=squareform(D);
tree=linkage(D,'average');
leafOrder = optimalleaforder(tree,D);
figure;
[~,~,~] = dendrogram(tree,size(D,2),'Reorder',leafOrder);
thresh = 0.8*mean(tree(:,3));
ClusterIDs  = cluster(tree,'Cutoff',thresh,'Criterion','distance');

clusts=unique(ClusterIDs);
for i=1:numel(clusts)
clustCM(i,1)=mean(cm1(ClusterIDs==clusts(i),1));
clustCM(i,2)=mean(cm1(ClusterIDs==clusts(i),2));
end
D = pdist(clustCM);
tree=linkage(D,'average');
leafOrder = optimalleaforder(tree,D);
clusts=clusts(leafOrder);
cl1= ClusterIDs;
for i=1:numel(clusts)
cl1(ClusterIDs==clusts(i))=i;
end

ClusterIDs=cl1;
clear cl1;

for i=1:numel(ClusterIDs)
    ClustLabel{i} = num2str(ClusterIDs(i));
end
close all;
imagesc(mask);
text(cm1(:,1),cm1(:,2),cmLabel);
text(cm1(:,1)+10,cm1(:,2)+10,ClustLabel,'BackgroundColor',[.7 .9 .7]);
end