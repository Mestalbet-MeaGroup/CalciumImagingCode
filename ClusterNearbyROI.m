function [ClusterIDs,combs] = ClusterNearbyROI(mask,corr)
% replaced with PlotA2ACorrelation
pixtest = bwconncomp(mask);
pixlis=pixtest.PixelIdxList;
combs = nchoosek(1:numel(pixlis),2);
combs1 = combs(:,1);
combs2 = combs(:,2);
combs3 = zeros(numel(combs1),1);
pixlis1 = pixlis(combs1);
pixlis2 = pixlis(combs2);

parfor i=1:size(combs,1)
    [testpix1,testpix2] = ind2sub([520,692],pixlis1{i});
    [testpatch1,testpatch2] = ind2sub([520,692],pixlis2{i});
    tests = allcomb(1:numel(testpix1),1:numel(testpatch1));
    temp = zeros(size(tests,1),1);
    for j=1:size(tests,1)
        temp(j) = sqrt( (testpix1(tests(j,1))-testpatch1(tests(j,2)))^2+(testpix2(tests(j,1))-testpatch2(tests(j,2)))^2 );
    end
    combs3(i)=min(temp);
end
combs(:,3)=combs3;
combs(:,4)=corr;
clear combs1; clear combs2; clear combs3; clear tests;
tree=linkage(combs(:,3)','weighted');
ClusterIDs  = cluster(tree,'Cutoff',20,'Criterion','distance');


cm = regionprops(pixtest,'Centroid');

for i=1:size(cm,1); 
    cm1(i,1) = cm(i).Centroid(1); 
    cm1(i,2) = cm(i).Centroid(2);
    cmLabel{i}=i;
end

clusts=unique(ClusterIDs);
for i=1:numel(clusts)
    clustCM(i,1)=mean(cm1(ClusterIDs==clusts(i),1));
    clustCM(i,2)=mean(cm1(ClusterIDs==clusts(i),2));
end
D = pdist(clustCM);
tree=linkage(D,'ward');
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
% close all;
imagesc(mask);
text(cm1(:,1),cm1(:,2),cmLabel);

color = cbrewer('qual','Paired',max(ClusterIDs));
for i=1:numel(ClusterIDs)
    text(cm1((i),1)+10,cm1((i),2)+10,ClustLabel{i},'BackgroundColor',color(ClusterIDs(i),:));
end

end