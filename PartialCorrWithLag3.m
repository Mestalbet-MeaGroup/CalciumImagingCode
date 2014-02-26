function [ParCor,Pval,lags,p1,p2] = PartialCorrWithLag3(mat,maxlag)
% Function which accepts a time series and calculates the partialcorrelation over lags between
% -maxlag and maxlag. Returns the significance, the correlation and the lag
% vector.

lags = -maxlag:1:maxlag;
[m,n]=size(mat);
if m<n
    mat=mat';
    [m,n]=size(mat);
end

% combs = VChooseKR(int8(1:n),2);
combs = nchoosek(int8(1:n),2);
p1=combs(:,1);
p2=combs(:,2);
vec1=mat(:,p1);
vec2=mat(:,p2);
numcom=numel(p1);
clear combs;
Pcorr=zeros(numcom,numel(lags));
Pval=Pcorr;
% others = cell(numcom,1);
% for i=1:numcom
% others{i}= mat(:,setdiff(repmat(1:n,1,numcom),[p1(i),p2(i)]));
% end

parfor i=1:numcom
    others = mat(:,setdiff(repmat(1:n,1,numcom),[p1(i),p2(i)]));
    v2 = lagmatrix(vec2(:,i),lags);
    v2(isnan(v2))=0;
    [Pcorr(i,:),Pval(i,:)] = CalcPCwithLag(vec1(:,i),v2,others);
end
Pcorr(Pval<0.05)=nan;
%Comment out if you uncomment below.
[ParCor,ind]=max(Pcorr,[],2); 
lags=lags(ind);
%Comment out if you uncomment below.


%Uncomment if you want Pcorr to have the dimensions: Number of Time Series x Number of Time Series x Lags
% ParCor = zeros(max(p1),max(p2),numel(lags));
% parfor l=1:numel(lags)
%     ParCor(:,:,l) = full(sparse([p1; p2],[p2; p1],[Pcorr(:,l); Pcorr(:,l)]));
% end
% index = repmat(eye(max(p1),max(p2)),1,1,numel(lags));
% ParCor(logical(index))=1;

end