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

%% Plotting

[barsB,binsB]=hist(bwB,50);
barsG = hist(bwG,binsB);
bar([barsB;barsG]','Grouped');
title('Burst Widths');

figure;
[barsB,binsB]=hist(ibiB,40);
barsG = hist(ibiG,binsB);
bar([barsB;barsG]','Grouped');
title('Inter-burst-intervals');