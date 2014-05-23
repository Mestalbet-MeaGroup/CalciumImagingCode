function [tr,lags,bs1] = CalcBurstTriggeredAstroTrace(bs,traces,time,lag,t,be);
bs= bs./12000;
be= be./12000;
%---Remove Bursts that would not yield a full cutout (near beginning or end)---%
while bs(1)<lag
    bs(1)=[];
    be(1)=[];
end

while (time(end)-(bs(end)+lag))<0
    bs(end)=[];
    be(end)=[];
end

t1=sort(t);
for i=1:numel(bs)
    numSpks(i) = sum((t1>bs(i)*12000)&(t1<(be(i)*12000)));
end
numSpks=zscore(numSpks);
numSpks=numSpks-min(numSpks);

%------------------------------------------------------%
if sum(diff(bs)<2*lag)>0 
      [bs1,~,lag]=FindOptimumSetofBursts(bs,be,t,lag);
%     fun = @(set)CostFunction(bs,set,lag,t,be,numSpks);
%     objectivesToPlot = [1,2,3]; 
%     plotfn = @(options,state,flag)gaplotpareto(options,state,flag,objectivesToPlot);
%     options = gaoptimset('PlotFcns',plotfn);
%     options = gaoptimset('PopulationSize',300,'PopulationType','bitstring','UseParallel',false,'PlotFcns',plotfn);
%     [x,f,~] = gamultiobj(fun,numel(bs),[],[],[],[],[],[],options);
%     [~,best]=min(f(:,2));
%     bs1=bs(logical(x(best,:)));
    sOn  = bs1-lag;
    sOff = bs1+lag;
else
    bs1=bs;
    sOn  = bs-lag;
    sOff = bs+lag;
end

%---Avoid counting the same peak twice---%
% dist=squareform(pdist(bs'));
% dist(dist<=(2*lag))=0;
% for i=1:numel(bs)
%     TooClose(i)=find(dist(:,i)==0,1,'Last')+1;
% end
% TooClose = unique(TooClose);
% bs1=[bs(1),bs(TooClose(1:end-1))];

% clear dist;
% ----------------------------------------%
starttr=[];
stoptr=[];

for i=1:numel(sOn)
    starttr(i) = find(time>=sOn(i),1,'first');
    stoptr(i) = find(time>=sOff(i),1,'first');
end
numelem=max(stoptr-starttr);
clear time;
tr = nan(size(traces,1),numelem,numel(sOn));
for i=1:numel(sOn);
    tr(:,1:(stoptr(i)-starttr(i))+1,i)=traces(:,starttr(i):stoptr(i));
end
clear traces;
tr=tr(:,1:min(stoptr-starttr),:);
lags = linspace(-lag,lag,size(tr,2));
end

