function [NCorrs,vx,vy] = DendrogramOrderMatrix2(Mat)
% Function which re-orders an ajacency matrix by dendrogram re-ordering
% using a linkage calculated according to the weighted method. returns the
% re-ordered matrix and the clustered order of both x and y indices. 
% Written by: Noah Levine-Small
% Revision 1: 30/04/2013
% Revision 2: 07/06/2013 *Changed nan's to -1000 instead of min value. 
% disttypes={'euclidean' 'seuclidean' 'mahalanobis' 'cityblock' 'minkowski' 'cosine' 'hamming' 'jaccard' 'chebychev'};
% linktypes={'average' 'centroid' 'complete' 'median' 'single' 'ward' 'weighted'};

[m1,n1] = size(Mat);
notsig=isnan(Mat);
Mat(isnan(Mat))=-1000;
vec=reshape(Mat,1,n1*m1);

test=pdist(Mat);
test2=linkage(test,'weighted');
figure;
[~,~,vm] = dendrogram(test2,size(Mat,1));
[~,~,vn] = dendrogram(test2,size(Mat,2));
close;

vx=vm;

Mat1=Mat';
[m1,n1] = size(Mat1);
vec=reshape(Mat1,1,n1*m1);

test=pdist(Mat1);
test2=linkage(test,'weighted');
figure;
[~,~,vm] = dendrogram(test2,size(Mat1,1));
[~,~,vn] = dendrogram(test2,size(Mat1,2));
close;

vy=vn;
Mat(notsig)=nan;
NCorrs=Mat(vx,vy);
% vx(sum(isnan(NCorrs),2)==m1)=[];
% NCorrs(sum(isnan(NCorrs),2)==m1,:)=[];

%Plot
% imagescnan(NCorrs);
% set(gca,'xtick',1:numel(vy),'xticklabel',vy,'ytick',1:numel(vx),'yticklabel',ic(1,vx));
% hcb=colorbar; a = get(hcb,'YTick'); set(hcb,'YTickLabel',log10(a));
% set(gca,'PlotBoxAspectRatio',[1 numel(vx)/numel(vy) numel(vy)])
end