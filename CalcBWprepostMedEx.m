function CalcBWprepostMedEx(DataSet)
% Calculates and plots two columns of pre/post 9 well firing rates. Where
% the first column is the change after removing and returning the medium and the second column is after adding Rhod3
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

for j=1:round(size(DataSet,2)/2)
bwPresBase = DataSet{2*j}.bwBase;
bwPresMedEx = DataSet{2*j}.bwMedEx;
bwPostsBase = DataSet{2*j-1}.bwBase;
bwPostsMedEx = DataSet{2*j-1}.bwMedEx;

bins=linspace(0,5000,100);
for i=1:size(bwPresBase,2)
    bwpre=bwPresBase{i}; %pre
    bwpost=bwPostsBase{i}; %post
    s = subplot(4,2,2*i-1);
    if i==1
        title('Baseline');
    end
    if (length(bwpre)>5)
        hold on;
        hist(s,bwpre./12,bins);
        h = findobj(s,'Type','patch');
        set(h,'FaceColor','b');
        hist(s,bwpost./12,bins);
        h = findobj(s,'Type','patch');
        set(h(2),'FaceColor','r','FaceAlpha',0.5);
        hold off;
    end
end

for i=1:size(bwPresMedEx,2)
    
    bwpre=bwPresMedEx{i}; %pre
    bwpost=bwPostsMedEx{i}; %post
    s = subplot(4,2,2*i);
    if i==1
        title('Medium Exchanged');
    end
    if (length(bwpost)>5)
        hold on;
        hist(s,bwpre./12,bins);
        h = findobj(s,'Type','patch');
        set(h,'FaceColor','b');
        hist(s,bwpost./12,bins);
        q = findobj(s,'Type','patch');
        set(q(2),'FaceColor','r','FaceAlpha',0.5);
        hold off;
    end
end

end

bwPresBase=[];
bwPresMedEx=[];
bwPostsBase=[];
bwPostsMedEx=[];
for j=1:size(DataSet,2)
for i=1:size(DataSet{1}.bwMedEx,2)
bwPostsBase = [bwPostsBase,DataSet{2*j-1}.bwBase{i}];
bwPostsMedEx = [bwPostsMedEx,DataSet{2*j-1}.bwMedEx{i}];
end
for i=1:size(DataSet{2}.bwMedEx,2)
bwPresBase = [bwPresBase,DataSet{2*j}.bwBase{i}];
bwPresMedEx =[bwPresMedEx,DataSet{2*j}.bwMedEx{i}];
end
end
bins=linspace(0,5000,100);
figure;
s = subplot(1,2,1);
hold on;
hist(s,bwPresBase(bwPresBase>50*12)./12,bins);
h = findobj(s,'Type','patch');
set(h,'FaceColor','b');
hist(s,bwPostsBase(bwPostsBase>50*12)./12,bins);
h = findobj(s,'Type','patch');
set(h(2),'FaceColor','r','FaceAlpha',0.3);
xlim([bins(1) bins(end)]);
hold off;
title('Control');
[h,p,~,~] = ttest2(bwPresBase(bwPresBase>50*12)./12,bwPostsBase(bwPostsBase>50*12)./12);
display('Control = ');
display(h);
display(p); 
q = subplot(1,2,2);
hold on;
hist(q,bwPresMedEx(bwPresMedEx>50*12)./12,bins);
r = findobj(q,'Type','patch');
set(r,'FaceColor','b');
hist(q,bwPostsMedEx(bwPostsMedEx>50*12)./12,bins);
r = findobj(q,'Type','patch');
set(r(2),'FaceColor','r','FaceAlpha',0.3);
xlim([bins(1) bins(end)]);
hold off;
title('Medium Exchanged');
[h,p,~,~] = ttest2(bwPresBase(bwPresBase>50*12)./12,bwPostsBase(bwPostsBase>50*12)./12);
display('Experiment = ');
display(h);
display(p); 
end