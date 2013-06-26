function [sigCorrMat,nf] = CalcRankCorr(t,ic);
% To do: Convert this to a per regime calculation.
choices = VChooseK(1:size(ic,2),2);
n1 = choices(:,1);
n2 = choices(:,2);

for ij = 1:length(n1);
    i=n1(ij);
    j=n2(ij);
    t1a{ij} = t(ic(3,i):ic(4,i));
    t2a{ij} = t(ic(3,j):ic(4,j));
end
% try
tt1 = sort(t);
parfor ii=1:length(n1)
    tt=tt1;
    t1=t1a{ii};
    t2=t2a{ii};
    t1(isnan(t1))=[];
    t2(isnan(t2))=[];
    if isempty(t1)||isempty(t2)
        Corrs(ii)=nan;
        nf(ii)=nan;
    else
        temp1=[min(t1),min(t2)];
        temp2=[max(t1),max(t2)];
        t1(t1<max(temp1))=[];
        t2(t2<max(temp1))=[];
        t1(t1>min(temp2))=[];
        t2(t2>min(temp2))=[];
        t1b = histc(t1,0:120:min(temp2));
        t2b = histc(t2,0:120:min(temp2));
        tt(tt<max(temp1))=[];
        tt(tt>min(temp2))=[];
        ttb = histc(tt,0:120:min(temp2));
        r=corr(t1b',t2b','type', 'Spearman');
        spikeNormFactor = sum(t1b)+sum(t2b); spikeNormFactor = spikeNormFactor / sum(ttb);
        
        normFactor = spikeNormFactor*sqrt(corr(t1b',ttb','type', 'Spearman')*corr(t2b',ttb','type', 'Spearman'));
        Corrs(ii)=r;
        nf(ii) = normFactor;
    end
end
% catch
%     display(ii)
% end
CorrsMat = zeros(size(ic,2),size(ic,2));
NormMat = zeros(size(ic,2),size(ic,2));
for ii=1:length(n1)
    CorrsMat(n1(ii),n2(ii))=Corrs(ii);
    NormMat(n1(ii),n2(ii))=nf(ii);
end
CorrsMat = CorrsMat + CorrsMat';%+eye(size(CorrsMat));
NormMat = NormMat + NormMat';
sigCorrMat = CorrsMat-NormMat;
sigCorrMat(sigCorrMat<0)=nan;
% [NCorrs,~,~]=DendrogramOrderMatrix2(sigCorrMat);

end