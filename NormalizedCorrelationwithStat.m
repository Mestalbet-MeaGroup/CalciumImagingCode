function [Corr]=NormalizedCorrelationwithStat(a,b,t,time)
% a = astrocyte
% b =  neuron fr
% Calculate the normalized unbiased correlation between neurons and
% astrocytes. Permutting the spike train (ISIs) 500x to create a test
% statistic. 
% Written by: Noah Levine-Small
% Revision 1: 30/04/2013
b=filter(MakeGaussian(0,30,120),1,b);
Corr = NormalizedCorrelation(a,b); % Return normalized, unbiased maximum correlation with lag of 2000.
CorrPerm=zeros(1,500);
for i=1:500
    t1=ShuffelIntervals(t);
    FRperm=histc(t1,time*1000);
    CorrPerm(i)=NormalizedCorrelation(a,filter(MakeGaussian(0,30,120),1,FRperm));
end
Corr=max(Corr);
if Corr <(mean(CorrPerm)+2*std(CorrPerm))
    Corr=nan;
end
end