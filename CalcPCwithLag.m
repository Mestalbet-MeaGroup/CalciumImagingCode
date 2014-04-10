function [pc,pv]=CalcPCwithLag(v1,v2,others)
%function to ve used with PartialCorrWithLag3 to calculate the
%partialcorrelation over the lagmatrix v2. Returns the partial correlation
%between v1 and the lagged v2; 
[n,d]=size(v1);
v2s = size(v2,2);
pc = zeros(1,v2s);
pv=pc;


z1 = [ones(n,1) others];

for ii=1:v2s
%     [pc(ii),pv(ii)]=partialcorr(v1,v2(:,ii),others); % This gives the
%     same results as the following calculations (but slower)
xx = [v1,v2(:,ii)];
resid = xx - z1*(z1 \ xx);
tol = max(n,d)*eps(class(xx))*sqrt(sum(abs(xx).^2,1));
resid(:,sqrt(sum(abs(resid).^2,1)) < tol) = 0;
pc(ii) = sum(prod(resid,2)) ./ prod(sqrt(sum(abs(resid).^2,1)),2);
end
df = max(n - d - 2,0); % this is a matrix for 'pairwise'
t = sign(pc) .* Inf;
k = (abs(pc) < 1);
t(k) = pc(k) ./ sqrt(1-pc(k).^2);
t = sqrt(df).*t;
pv = 2*tcdf(-abs(t),df);
end