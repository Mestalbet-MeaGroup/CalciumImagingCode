function [CorrsMat,SigMat] = CalcPartialCorrParfor(t,ic);
choices = VChooseK(1:size(ic,2),2);
n1 = choices(:,1);
n2 = choices(:,2);
for ij = 1:length(n1);
    i=n1(ij);
    j=n2(ij);
    t1a{ij} = t(ic(3,i):ic(4,i));
    t2a{ij} = t(ic(3,j):ic(4,j));
end
tt1 = sort(t);
parfor ii=1:length(n1)
    tt=tt1;
    t1=t1a{ii};
    t2=t2a{ii};
    t1(isnan(t1))=[];
    t2(isnan(t2))=[];
    if isempty(t1)||isempty(t2)
        rho(ii)=nan;
        pval(ii)=nan;
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
        [~,r1,~] = intersect(tt,t1);
        [~,r2,~] = intersect(tt,t2);
        tt([r1;r2])=[];
        ttb = histc(tt,0:120:min(temp2));
        [rho(ii),pval(ii)]=partialcorrwithlag(t1b,t2b,ttb,round(numel(ttb)*0.01));
    end
end

CorrsMat = zeros(size(ic,2),size(ic,2));
SigMat = zeros(size(ic,2),size(ic,2));
for ii=1:length(n1)
    CorrsMat(n1(ii),n2(ii))=rho(ii);
    SigMat(n1(ii),n2(ii))=pval(ii);
end
CorrsMat = CorrsMat + CorrsMat'+eye(size(CorrsMat));
SigMat = SigMat + SigMat';
end