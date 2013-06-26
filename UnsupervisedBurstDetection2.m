function [bs,be,bw,sbs,sbe,sbw]=UnsupervisedBurstDetection2(t,ic);
[Firings,~]=FindNeuronFrequency(t,ic,25,1);
frs=mean(Firings,2);
thr = mean(frs)+2*std(frs);
t(ic(3,frs>=thr):ic(4,frs>=thr));
ic(:,frs>=thr)=[];


[bs,be,~]=CalcBurstsSamora(t,ic);
sb = diff(bs./12000)<=8; %IBI's less than 10s
[a,b]=initfin(sb);
sbs=bs(a);
sbe=be(b+1);

for i=1:numel(sbs)
    if numel(find(bs>=sbs(i)&bs<=sbe(i)))<10
        sbs(i)=nan;
        sbe(i)=nan;
    end
end
sbs(isnan(sbs))=[];
sbe(isnan(sbe))=[];

counter=1;
sbs1=[];
sbe1=[];
for i=1:numel(sbs)
    index = find(bs>=sbs(i)&bs<=sbe(i));
    testIBI = (bs(index(2:end))-be(index(1:end-1)));
    if (median(testIBI)<mean(testIBI))&&(mean(testIBI)<20000)
        sbs1(counter)=sbs(i);
        sbe1(counter)=sbe(i);
        counter=counter+1;
    end
end

sbs = sbs1;
sbe = sbe1;
bw=(be-bs)./12;
sbw=(sbe-sbs)./12;
end