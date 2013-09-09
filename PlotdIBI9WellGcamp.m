function PlotdIBI9WellGcamp(DataSet)
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

bins=linspace(0,300,60);
for ii=1:size(DataSet,2)
    %% Load Select Culture
    for i=1:size(DataSet{ii}.ibiGcamp,2)
        ibiBase = abs(diff(DataSet{ii}.ibiBase{i}));
        ibiGcamp = abs(diff(DataSet{ii}.ibiGcamp{i}));
        
        s = subplot(4,2,2*i-1);
        if (length(ibiBase)>5)
            hist(s,ibiBase./12000,bins);
            h = findobj(s,'Type','patch');
            set(h,'FaceColor','b');
            xlim([bins(1) bins(end)]);
        end
        
        q = subplot(4,2,2*i);
        if (length(ibiGcamp)>5)
            hist(q,ibiGcamp./12000,bins);
            r = findobj(q,'Type','patch');
            set(r,'FaceColor','r');
            xlim([bins(1) bins(end)]);
        end
        
    end
end
ibiBase=[];
ibiGcamp=[];
for ii=1:size(DataSet,2)
    %% Load Select Culture
    for i=1:size(DataSet{ii}.ibiGcamp,2)
        ibiBase = [ibiBase,abs(diff(DataSet{ii}.ibiBase{i}))];
        ibiGcamp = [ibiGcamp,abs(diff(DataSet{ii}.ibiGcamp{i}))];
    end
end
figure;
s = subplot(1,2,1);
hist(s,ibiBase./12000,bins);
h = findobj(s,'Type','patch');
set(h,'FaceColor','b');
xlim([bins(1) bins(end)]);
q = subplot(1,2,2);
hist(q,ibiGcamp./12000,bins);
r = findobj(q,'Type','patch');
set(r,'FaceColor','r');
xlim([bins(1) bins(end)]);
[h,p,ci,stats] = ttest2(ibiBase./12000,ibiGcamp./12000);
display(h);
display(p); 
end