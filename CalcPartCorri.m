function [rho,pval] = CalcPartCorri(dfTraces,fr,lag)

rho=zeros(size(dfTraces,2),size(fr,2),lag-1);
pval=rho;
parfor i=-(lag-1):(lag-1)
v2 = lagmatrix(dfTraces,i);
v2(isnan(v2))=0;
[rho(:,:,i+lag),pval(:,:,i+lag)] = partialcorri(v2,fr);
end


end