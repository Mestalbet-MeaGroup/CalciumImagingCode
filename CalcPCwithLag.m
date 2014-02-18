function [pc,pv]=CalcPCwithLag(v1,v2,others)
%function to ve used with PartialCorrWithLag3 to calculate the
%partialcorrelation over the lagmatrix v2. Returns the partial correlation
%between v1 and the lagged v2; 
v2s = size(v2,2);
pc = zeros(1,v2s);
pv=pc;

for ii=1:v2s
    [pc(ii),pv(ii)]=partialcorr(v1,v2(:,ii),others);
end

end