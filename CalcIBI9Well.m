function [ibiG,ibiB,bwG,bwB]=CalcIBI9Well(tGcamp,icGcamp,tBase,icBase);

ibiG=[];
bwG=[];
for i=1:size(icGcamp,2)
    [bs,be,bw,ibi]=UnsupervisedBurstDetection9Well(tGcamp{i},icGcamp{i});
    ibiG = [ibiG,ibi];
    bwG = [bwG,bw];
end

ibiB=[];
bwB=[];
for i=1:size(icBase,2)
    [~,~,bw,ibi]=UnsupervisedBurstDetection9Well(tBase{i},icBase{i});
    ibiB = [ibiB,ibi];
    bwB = [bwB,bw];
end

end