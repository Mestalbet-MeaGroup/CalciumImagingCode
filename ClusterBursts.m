function [ClusterIDs,mat] = ClusterBursts(m)
combs = VChooseK(1:size(m,3),2);

m(isnan(m))=0;
h = waitbarwithtime(0,'Calculating...');
for q=1:size(combs,1)
    I1 = squeeze(m(:,:,combs(q,1)));
    I1 = (I1-mean(I1(:)))/var(I1(:));
    I2 = squeeze(m(:,:,combs(q,2)));
    I2 = (I2-mean(I2(:)))/var(I2(:));
    cor = xcorr2(I1,I2)./sqrt(sum(dot(I1,I1))*sum(dot(I2,I2)));
    corr(q)=abs(max(cor(:)));
    waitbarwithtime(q/size(combs,1),h);
end
close(h);
% toc
mat = zeros(size(m,3),size(m,3));
for q=1:size(combs,1)
    mat(combs(q,1),combs(q,2))=corr(q);
end
mat = mat + mat'+eye(size(mat));
test=pdist(mat);
tree=linkage(test,'average'); %changed from weighted
leafOrder = optimalleaforder(tree,test);
% figure;
% [~,~,~] = dendrogram(tree,size(mat,1),'Reorder',leafOrder);
% hold on;
% index = 1:numel(get(gca,'XTick'));
% line(index,ones(length(index),1).*(0.7*max(tree(:,3))),'color','r');
% [~,thresh] = ginput(1);
thresh = 0.7*max(tree(:,3));
ClusterIDs  = cluster(tree,'MaxClust',5,'Criterion','distance');
end