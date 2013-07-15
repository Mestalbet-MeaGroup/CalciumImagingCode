%% KL IBIs
for ii=1:size(DataSet,1)
    mIBIg(ii) = mean(DataSet{ii}.klIBIg);
    sIBIg(ii) = std(DataSet{ii}.klIBIg);
    
    mIBIb(ii) = mean(DataSet{ii}.klIBIb);
    sIBIb(ii) = std(DataSet{ii}.klIBIb);
    
    mIBI(ii) = mean(DataSet{ii}.klIBI);
    sIBI(ii) = std(DataSet{ii}.klIBI);
end
figure;
notBoxPlot([mIBIg;mIBIb;mIBI]');
set(gca,'XTick',[1,2,3],'XTickLabels',{'Within GcAMP', 'Within Control', 'Between GcAMP/Control'});
title('IBI: Culture Means');

mIBIg=[];
mIBIb=[];
mIBI=[];
for ii=1:size(DataSet,1)
    mIBIg = [mIBIg,(DataSet{ii}.klIBIg)];
    mIBIb = [mIBIb,(DataSet{ii}.klIBIb)];
    mIBI = [mIBI,(DataSet{ii}.klIBI)];
end
mIBIg(end+1:length(mIBI))=nan;
mIBIb(end+1:length(mIBI))=nan;
figure;
notBoxPlot([mIBIg;mIBIb;mIBI]');
set(gca,'XTick',[1,2,3],'XTickLabels',{'Within GcAMP', 'Within Control', 'Between GcAMP/Control'});
title('IBI: Pooled');

%% KL Burst Widths
for ii=1:size(DataSet,1)
    mBWg(ii) = mean(DataSet{ii}.klBWg);
    sBWg(ii) = std(DataSet{ii}.klBWg);
    
    mBWb(ii) = mean(DataSet{ii}.klBWb);
    sBWb(ii) = std(DataSet{ii}.klBWb);
    
    mBW(ii) = mean(DataSet{ii}.klBW);
    sBW(ii) = std(DataSet{ii}.klBW);
end
figure;
notBoxPlot([mBWg;mBWb;mBW]');
set(gca,'XTick',[1,2,3],'XTickLabels',{'Within GcAMP', 'Within Control', 'Between GcAMP/Control'});
title('BW: Culture Means');

mBWg=[];
mBWb=[];
mBW=[];
for ii=1:size(DataSet,1)
    mBWg = [mBWg,(DataSet{ii}.klBWg)];
    mBWb = [mBWb,(DataSet{ii}.klBWb)];
    mBW = [mBW,(DataSet{ii}.klBW)];
end
mBWg(end+1:length(mBW))=nan;
mBWb(end+1:length(mBW))=nan;
figure;
notBoxPlot([mBWg;mBWb;mBW]');
set(gca,'XTick',[1,2,3],'XTickLabels',{'Within GcAMP', 'Within Control', 'Between GcAMP/Control'});
title('BW: Pooled');


%%

IBIg=[];
IBIb=[];
for ii=1:size(DataSet,1)
    IBIg = [IBIg,(DataSet{ii}.ibiG)];
    IBIb = [IBIb,(DataSet{ii}.ibiB)];
end

BWg=[];
BWb=[];
for ii=1:size(DataSet,1)
    BWg = [BWg,(DataSet{ii}.bwG)];
    BWb = [BWb,(DataSet{ii}.bwB)];
end

figure;
[barsB,binsB]=hist(BWb,50);
barsG = hist(BWg,binsB);
bar([barsB;barsG]','Grouped');
title('Burst Widths');

figure;
[barsB,binsB]=hist(IBIb,40);
barsG = hist(IBIg,binsB);
bar([barsB;barsG]','Grouped');
title('Inter-burst-intervals');