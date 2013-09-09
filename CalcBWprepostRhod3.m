function CalcBWprepostRhod3(DataSet)
% Calculates and plots two columns of pre/post 9 well firing rates. Where
% the first column is the change after removing and returning the medium and the second column is after adding Rhod3
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

bwPresBase = DataSet{2}.bwBase;
bwPresRhod3 = DataSet{2}.bwRhod3;

bwPostsBase = DataSet{1}.bwBase;
bwPostsRhod3 = DataSet{1}.bwRhod3;


bins=linspace(0,5000,100);
for i=1:size(bwPresBase,2)
    bwpre=bwPresBase{i}; %pre
    bwpost=bwPostsBase{i}; %post
    s = subplot(4,2,2*i-1);
    if i==1
        title('Baseline');
    end
    if (length(bwpre)>5)&&(length(bwpost)>5)
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

for i=1:size(bwPresRhod3,2)
    
    bwpre=bwPresRhod3{i}; %pre
    bwpost=bwPostsRhod3{i}; %post
    s = subplot(4,2,2*i);
    if i==1
        title('Rhod3 Added');
    end
    if (length(bwpre)>5)
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

bwPresBase=[];
bwPresRhod3=[];
bwPostsBase=[];
bwPostsRhod3=[];
for i=1:size(DataSet{1}.bwRhod3,2)
bwPostsBase = [bwPostsBase,DataSet{1}.bwBase{i}];
bwPostsRhod3 = [bwPostsRhod3,DataSet{1}.bwRhod3{i}];
end
for i=1:size(DataSet{2}.bwRhod3,2)
bwPresBase = [bwPresBase,DataSet{2}.bwBase{i}];
bwPresRhod3 =[bwPresRhod3,DataSet{2}.bwRhod3{i}];
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
hist(q,bwPresRhod3(bwPresRhod3>50*12)./12,bins);
r = findobj(q,'Type','patch');
set(r,'FaceColor','b');
hist(q,bwPostsRhod3(bwPostsRhod3>50*12)./12,bins);
r = findobj(q,'Type','patch');
set(r(2),'FaceColor','r','FaceAlpha',0.3);
xlim([bins(1) bins(end)]);
hold off;
title('Rhod3 Added');
[h,p,~,~] = ttest2(bwPresRhod3(bwPresRhod3>50*12)./12,bwPostsRhod3(bwPostsRhod3>50*12)./12);
display('Experiment = ');
display(h);
display(p); 
end