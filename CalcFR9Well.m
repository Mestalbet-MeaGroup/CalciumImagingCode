function [frG,frB]=CalcFR9Well(tGcamp,icGcamp,tBase,icBase,res);
%res is in miliseconds.

recordingTime = 30*60*1000; %30min

for i=1:size(icGcamp,2)
    frG(:,i)=histc(sort(tGcamp{i}),0:res*12:recordingTime)./res;
end


for i=1:size(icBase,2)
    frB(:,i)=histc(sort(tBase{i}),0:res*12:recordingTime)./res;
end

end