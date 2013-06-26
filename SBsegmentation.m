function [tSB,icSB,traceSB,timeSB,tNsb,icNsb,traceNsb,timeNsb]=SBsegmentation(t,ic,traces,time)

[~,~,~,sbs,sbe,~]=UnsupervisedBurstDetection(t,ic);
if ~isempty(sbs)
    
for i=1:length(sbs)
    [tSB{i},icSB{i}]=CutSortChannel(t,ic,sbs(i),sbe(i));
    traceSB{i} = traces(:,find(time>=sbs(i)/12000,1,'First'):find(time>=sbe(i)/12000,1,'First'));
    timeSB{i} = time(find(time>=sbs(i)/12000,1,'First'):find(time>=sbe(i)/12000,1,'First'));
end


[tNsb{1},icNsb{1}]=CutSortChannel(t,ic,0,sbs(1));
traceNsb{1} = traces(:,1:find(time>=sbs(1)/12000,1,'First'));
timeNsb{1} = time(1:find(time>=sbs(1)/12000,1,'First'));

if numel(sbs)>1
    for i=2:length(sbs)
        [tNsb{i},icNsb{i}]=CutSortChannel(t,ic,sbe(i-1),sbs(i));
        traceNsb{i} = traces(:,find(time>=sbe(i-1)/12000,1,'First'):find(time>=sbs(i)/12000,1,'First'));
        timeNsb{i} = time(find(time>=sbe(i-1)/12000,1,'First'):find(time>=sbs(i)/12000,1,'First'));
    end
    [tNsb{i+1},icNsb{i+1}]=CutSortChannel(t,ic,sbe(i),max(t));
    traceNsb{i+1} = traces(:,find(time>=sbe(i)/12000,1,'First'):end);
    timeNsb{i+1} = time(find(time>=sbe(i)/12000,1,'First'):end);
end

temp1= timeSB;
temp2= icSB;
temp3 = tSB;
temp4 =traceSB;

for i=1:size(timeSB)
    if numel(timeSB{i})<100
        temp1(i)=[];
        temp2(i)=[];
        temp3(i)=[];
        temp4(i)=[];
    end
end
clear timeSB; clear icSB; clear tSB;
timeSB = temp1;
icSB = temp2;
tSB = temp3;
traceSB = temp4;

temp1= timeNsb;
temp2= icNsb;
temp3 = tNsb;
temp4 = traceNsb;

for i=1:size(timeNsb)
    if numel(timeNsb{i})<100
        temp1(i)=[];
        temp2(i)=[];
        temp3(i)=[];
        temp4(i)=[];
    end
end
clear timeNsb; clear icNsb; clear tNsb; clear traceNsb;
timeNsb = temp1;
icNsb = temp2;
tNsb = temp3;
traceNsb = temp4;
else
    tSB=[]; icSB=[]; traceSB=[]; timeSB=[];
    tNsb{1}=t;icNsb{1}=ic; traceNsb{1}=traces;timeNsb{1}=time;

end