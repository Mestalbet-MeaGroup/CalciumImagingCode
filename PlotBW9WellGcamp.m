function PlotBW9WellGcamp(DataSet)
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

bins=linspace(0,5000,100);
for ii=1:size(DataSet,2)
    %% Load Select Culture
    for i=1:size(DataSet{ii}.bwGcamp,2)
        bwBase = DataSet{ii}.bwBase{i};
        bwGcamp = DataSet{ii}.bwGcamp{i};
        
        s = subplot(4,2,2*i-1);
        if (length(bwBase)>5)
            hist(s,bwBase(bwBase>50*12)./12,bins);
            h = findobj(s,'Type','patch');
            set(h,'FaceColor','b');
            xlim([bins(1) bins(end)]);
        end
        
        q = subplot(4,2,2*i);
        if (length(bwGcamp)>5)
            hist(q,bwGcamp(bwGcamp>50*12)./12,bins);
            r = findobj(q,'Type','patch');
            set(r,'FaceColor','r');
            xlim([bins(1) bins(end)]);
        end
        
    end
end

bwBase=[];
bwGcamp=[];
for ii=1:size(DataSet,2)
    %% Load Select Culture
    for i=1:size(DataSet{ii}.bwGcamp,2)
        bwBase = [bwBase,DataSet{ii}.bwBase{i}];
        bwGcamp = [bwGcamp,DataSet{ii}.bwGcamp{i}];
    end
end
figure;
s = subplot(1,2,1);
hist(s,bwBase(bwBase>50*12)./12,bins);
h = findobj(s,'Type','patch');
set(h,'FaceColor','b');
xlim([bins(1) bins(end)]);
q = subplot(1,2,2);
hist(q,bwGcamp(bwGcamp>50*12)./12,bins);
r = findobj(q,'Type','patch');
set(r,'FaceColor','r');
xlim([bins(1) bins(end)]);
[h,p,~,~] = ttest2(bwBase(bwBase>50*12)./12,bwGcamp(bwGcamp>50*12)./12);
display(h);
display(p); 
[h,p] = ChiTest(bwGcamp(bwGcamp>50*12)./12,bwBase(bwBase>50*12)./12);
display(h);
display(p);
end