function [bs,be,bw,sbs,sbe,sbw]=UnsupervisedBurstDetection(t,ic)
% Function to detect the onset and offset of bursts (and super bursts)
% Output: 
%       bs = burst start (time of detected burst beginning 1/12ms)
%       be = burst end
%       bw = time between end and start
%       sbs = super burst start
%       sbe = super burst end (empty if there are no detected super bursts)
% Input: t (spike times in 1/12 ms) and index channel produced from
%        BatchSpikeDetection.m or from McdPrepData.m
% Algorithm:
%       *Removes highly active neurons (neurons whose firing rate exceeds
%        two standard deviations about the mean)
%       *Calculates interspike intervals for each channel and convolutes
%        with a guassian the overlap of ISIs
%       *Places where the ISIs across multiple neurons goes from being
%       short to long (or long to short) is defined as an event on/off set. Long ISIs
%       are defined as larger than 83 ms. 
%       *Superbursts are defined as at least 6 consecutive network bursts
%       with an IBI shorter than 8s.
% Dependecies: FindNeuronFrequency.m, initfin.m
% Written by Noah Levine-Small, Aug 08 2012.

t=round(t);
told=sort(t);
sbs=[];
sbe=[];

[Firings,SumFirings]=FindNeuronFrequency(t,ic,25,1);
frs=mean(Firings,2);
thr = mean(frs)+2*std(frs);
t(ic(3,frs>=thr):ic(4,frs>=thr));
ic(:,frs>=thr)=[];

NeuNum=size(ic,2);
bins=sparse(max(t)-min(t),size(ic,2));

for i=1:NeuNum
    t1=sort(t(ic(3,i):ic(4,i)));
    bs=t1(diff(t1)<1000);
    bins(bs,i)=1;
end

gaussbins = filter(MakeGaussian(0,300,900),1,full(sum(bins,2)));
thrcross =  gaussbins >= (mean(gaussbins)+2*std(gaussbins));

[bs,be]=initfin(thrcross');
bw=(be-bs)./12; %burst widths in ms
% bs(bw<100)=[];
% be(bw<100)=[];
% bw(bw<100)=[];
sb = diff(bs./12000)<=8; %IBI's less than 10s
[a,b]=initfin(sb);
sbs=bs(a);
sbe=be(b+1);

for i=1:numel(sbs)
    if numel(find(bs>=sbs(i)&bs<=sbe(i)))<6
        sbs(i)=nan;
        sbe(i)=nan;
    end
end
sbs(isnan(sbs))=[];
sbe(isnan(sbe))=[];
sbw=(sbe-sbs)./12;
% 
% for i=1:numel(bs)
% a=find(told>=bs(i),'1','First');
% b=a(1);
% a=b-300*12;
% temp=hist(told(a:b),150);
% [val id]=min(temp);
% bs(i)=bs(i)-id(1)*2*12;
% end

end