function [bs,be,bw,ibi]=UnsupervisedBurstDetection9Well(t,ic)
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
% Revision 2: 28-29/06/2013 *Derived from UnsupervisedBurstDetection, created for 9well recordings. Some internal burst dynamics were counted as
% bursts. Corrected by smoothing gaussbins and lowering the threshold below
% the internal burst dynamics.
t=round(t);

tt=t;
icc=ic;

[Firings,SumFirings]=FindNeuronFrequency(t,ic,100,1);
frChanges = diff(Firings,[],2);
stdFr = abs(std(frChanges'))./(sum(Firings,2))';
[val,ix] = findpeaks(diff(diff(sort(stdFr,'descend'))));
vals = sort(stdFr,'ascend');
vals = vals(1:ix(1)+1);
for i=1:size(vals,2)
    toelim(i)=find(stdFr==vals(i),1,'First');
end
t(ic(3,toelim):ic(4,toelim));
ic(:,toelim)=[];

NeuNum=size(ic,2);
bins=sparse(max(t)-min(t),NeuNum);

for i=1:NeuNum
    t1=sort(t(ic(3,i):ic(4,i)));
    bs=t1(diff(t1)<1000);
    bins(bs,i)=1;
end

gaussbins = filter(MakeGaussian(0,400,900),1,full(sum(bins,2)));
gaussbins=smooth(gaussbins,5000);
thrcross =  gaussbins >= (mean(gaussbins)+1.2*std(gaussbins));

[bs,be]=initfin(thrcross');
if length(bs)<5
    t=tt;
    ic=icc;
    NeuNum=size(ic,2);
    bins=sparse(max(t)-min(t),NeuNum);
    
    for i=1:NeuNum
        t1=sort(t(ic(3,i):ic(4,i)));
        bs=t1(diff(t1)<1000);
        bins(bs,i)=1;
    end
    
    gaussbins = filter(MakeGaussian(0,400,900),1,full(sum(bins,2)));
    gaussbins=smooth(gaussbins,5000);
    thrcross =  gaussbins >= (mean(gaussbins)+1.2*std(gaussbins));
    
    [bs,be]=initfin(thrcross');
    if length(bs)<5
        bs=[];
        bs=nan;
        be=[];
        be=nan;
        bw=nan;
        ibi=nan;
    else
        [~,ix]=findpeaks(diff(sort(bs(2:end)-be(1:end-1))));
        ibi = bs(2:end) - be(1:end-1);
        ibis = sort(bs(2:end)-be(1:end-1));
        bs(find(ibi<=ibis(ix(1)+1)))=[];
        be(find(ibi<=ibis(ix(1)+1)))=[];
        bw= be-bs;
        ibi(find(ibi<=ibis(ix(1)+1)))=[];
    end
else
    [~,ix]=findpeaks(diff(sort(bs(2:end)-be(1:end-1))));
    ibi = bs(2:end) - be(1:end-1);
    ibis = sort(bs(2:end)-be(1:end-1));
    bs(find(ibi<=ibis(ix(1)+1)))=[];
    be(find(ibi<=ibis(ix(1)+1)))=[];
    bw= be-bs;
    ibi(find(ibi<=ibis(ix(1)+1)))=[];
end
end