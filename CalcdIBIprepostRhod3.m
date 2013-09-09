function CalcdIBIprepostRhod3(DataSet)
% Calculates and plots two columns of pre/post 9 well firing rates. Where
% the first column is the change after removing and returning the medium and the second column is after adding Rhod3
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

for j=1:round(size(DataSet,2)/2)
IBIpresBase = DataSet{2*j}.ibiBase;
IBIpresRhod3 = DataSet{2*j}.ibiRhod3;
IBIpostsBase = DataSet{2*j-1}.ibiBase;
IBIpostsRhod3 = DataSet{2*j-1}.ibiRhod3;

bins=linspace(0,500,100);
for i=1:size(IBIpresBase,2)
    dibipre= abs(diff(IBIpresBase{i})); %pre
    dibipost= abs(diff(IBIpostsBase{i})); %post
    s = subplot(4,2,2*i-1);
    if i==1
        title('Baseline');
    end
    if (length(dibipre)>5)
        hold on;
        hist(s,dibipre./12000,bins);
        h = findobj(s,'Type','patch');
        set(h,'FaceColor','b');
        hist(s,dibipost./12000,bins);
        h = findobj(s,'Type','patch');
        set(h(2),'FaceColor','r','FaceAlpha',0.5);
        hold off;
    end
end

for i=1:size(IBIpresRhod3,2)
    dibipre=IBIpresRhod3{i}; %pre
    dibipost=IBIpostsRhod3{i}; %post
    s = subplot(4,2,2*i);
    if i==1
        title('Medium Exchanged');
    end
    if (length(dibipost)>5)
        hold on;
        hist(s,dibipre./12000,bins);
        h = findobj(s,'Type','patch');
        set(h,'FaceColor','b');
        hist(s,dibipost./12000,bins);
        q = findobj(s,'Type','patch');
        set(q(2),'FaceColor','r','FaceAlpha',0.5);
        hold off;
    end
end

end

IBIpresBase=[];
IBIpresRhod3=[];
IBIpostsBase=[];
IBIpostsRhod3=[];
for j=1:size(DataSet,2)
for i=1:size(DataSet{1}.ibiRhod3,2)
IBIpostsBase = [IBIpostsBase, abs(diff(DataSet{2*j-1}.ibiBase{i}))];
IBIpostsRhod3 = [IBIpostsRhod3, abs(diff(DataSet{2*j-1}.ibiRhod3{i}))];
end
for i=1:size(DataSet{2}.ibiRhod3,2)
IBIpresBase = [IBIpresBase, abs(diff(DataSet{2*j}.ibiBase{i}))];
IBIpresRhod3 =[IBIpresRhod3, abs(diff(DataSet{2*j}.ibiRhod3{i}))];
end
end
bins=linspace(0,500,200);
figure;
s = subplot(1,2,1);
hold on;
hist(s,IBIpresBase./12000,bins);
h = findobj(s,'Type','patch');
set(h,'FaceColor','b');
hist(s,IBIpostsBase./12000,bins);
h = findobj(s,'Type','patch');
set(h(2),'FaceColor','r','FaceAlpha',0.3);
xlim([bins(1) 250]);
hold off;
title('Control');

[h,p,~,~] = ttest2(IBIpresBase./12000,IBIpostsBase./12000);
display('Control = ');
display(h);
display(p); 

q = subplot(1,2,2);
hold on;
hist(q,IBIpresRhod3./12000,bins);
r = findobj(q,'Type','patch');
set(r,'FaceColor','b');
hist(q,IBIpostsRhod3./12000,bins);
r = findobj(q,'Type','patch');
set(r(2),'FaceColor','r','FaceAlpha',0.3);
xlim([bins(1) 250]);
hold off;
title('Rhod3 Added');

[h,p,~,~] = ttest2(IBIpresRhod3./12000,IBIpostsRhod3./12000);
display('Experiment = ');
display(h);
display(p); 
end