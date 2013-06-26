function results = CalcPlotA2NccLags(fr,trace,ic,time)
% Calculates the optimum lags for each electrode to a specific trace.

%for i=1:size(ic,2); fr(:,i) =
%histc(sort(t(ic(3,i):ic(4,i)))./12,time*1000); end
for i=1:size(fr,2)
    [lag(i),corr(i)]=CalcCorr(fr(:,i),trace);
end
[corr,perm]=sort(corr,'descend');
elec=ic(1,:);
perm(isnan(corr))=[];
corr(isnan(corr))=[];
elec=elec(perm);
lag=lag(perm);
fr=fr(:,perm);
results(1,:)=ones(size(perm)).*-1;
results(2,:)=elec;
results(3,:)=lag;
results(4,:)=corr;
astroset= find(results(4,:)>=(mean(results(4,:))+std(results(4,:))));

%% First Plot: Traces with optimal lags

hold on;
for i=1:10
    fr2plot = (fr(:,i)-min(fr(:,i)))/(max(fr(:,i))-min(fr(:,i)));
    if i>1
        fr2plot=fr2plot+shift;
    end
    if lag(i)>0
        plot(time,[ones(lag(i),1).*min(fr2plot);fr2plot(1:end-lag(i))]);
        plot(time(1:lag(i)-1),ones(lag(i)-1,1).*min(fr2plot),'.r');
        text(max(time)+1,mean(fr2plot),num2str(elec(i)));
    elseif lag(i)<0
        plot(time,[fr2plot(abs(lag(i)):end);ones(abs(lag(i))-1,1).*min(fr2plot)]);
        plot(time(end+lag(i)+1:end),ones(abs(lag(i)),1).*min(fr2plot),'.r');
        text(max(time)+1,mean(fr2plot),num2str(elec(i)));
    else
        plot(time,fr2plot);
        text(max(time)+1,mean(fr2plot),num2str(elec(i)));
    end
    shift = max(fr2plot);
end
trace= (trace-min(trace))/(max(trace)-min(trace));
plot(time,trace*10+shift*1.05,'g','LineWidth',0.5);
title('Shifting');
%% Second Plot: Schematic of Interaction
combs = nchoosek(1:10,2);
numbefore=size(results,2);
for i=1:size(combs,1)
    results(1,numbefore+i)=elec(combs(i,1));
    results(2,numbefore+i)=elec(combs(i,2));
    [results(3,numbefore+i),results(4,numbefore+i)] = CalcCorrNeuro(fr(:,combs(i,1)),fr(:,combs(i,2)));
end
neuroset = find(results(4,:)>=(mean(results(4,:))+std(results(4,:))));
results = results(:,[astroset,neuroset]);
[~,perm]=sort(abs(results(3,:)));
results = results(:,perm);
temp=results(2,results(3,:)>0);
results(2,results(3,:)>0)=results(1,results(3,:)>0);
results(1,results(3,:)>0)=temp;
clear temp;

nodes = unique([results(1,:),results(2,:)]);
numnodes= length(nodes);
adj = zeros(numnodes,numnodes);
for i=1:numnodes
    ids{i}=num2str(nodes(i));
    for j=1:numnodes
        for k=1:size(results,2)
            if results(1,k)==nodes(i)&&results(2,k)==nodes(j)
                adj(i,j)=1;
            end
        end
    end
end
ids{1}='Astrocyte';
bg = biograph(adj,ids);
view(bg);

%%
function [lag,Corr] = CalcCorr(a,b)
maxlag = 1000;
a=(a-mean(a))/var(a);
b = filter(MakeGaussian(0,30,120),1,b);
b=(b-mean(b))/var(b);

len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len)); % normalize by values at zero lag
[Corr,lag] = max(Corr(:));
lag = lag - maxlag;
end

function [lag,Corr] = CalcCorrNeuro(a,b)
maxlag = 1000;
a=(a-mean(a))/var(a);
b=(b-mean(b))/var(b);
len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len));
[Corr,lag] = max(Corr(:));
lag=lag-maxlag;
end
end
