function PlotPeriSBhist2(t,sbs,sbe);
% PlotPeriSBhist2(DataSetStims{i}.Trim.t,DataSetStims{i}.sbs,DataSetStims{i}.sbe);
t=sort(t);
f = savgol(10,1,0);
if numel(sbs)>0
    for i=1:numel(sbs)
        start = find(t>=(sbs(i)),1,'First');
        if start<=0
            start=1;
        end
        
        stop  = find(t<=sbe(i),1,'Last');
        
        t1 = t(start:stop);
        frB = histc(t1,t(start):5:t(stop));
        frtemp1{i} = frB;
        frtemp{i} = filtfilt(f,1,frB);
        frtemp{i} = filtfilt(MakeGaussian(0,30,120),1,frtemp{i});
    end
    sz=cellfun(@numel,frtemp);
    Firings=zeros(max(sz),numel(sbs));
    
    for i=1:numel(sbs);
        Firings(1:numel(frtemp{i}),i)=frtemp{i};
    end
    
    for i=1:size(Firings,2)
        locs=CalcCaOnsets(Firings(:,i));
        starts(i) = locs(2);
    end
    dev=min(starts);
    clear firings;
    for i=1:numel(sbs); sz(i) = numel(frtemp1{i});end
    Firings=zeros(max(sz),numel(sbs));
    for i=1:numel(sbs);
        Firings(1:numel(frtemp1{i}),i)=frtemp1{i};
    end
    
    %%
    
    offset=0;
    for j=2:size(Firings,2)
        offset(j)  = offset(j-1)+max(Firings(:,j-1));
    end
    padsize=[10000,1];
    time = 1:size(Firings,1)+padsize;
    lag(1)=0;
    ws=10000;
    [a,b]=find(Firings>15);
    [~,perm]=sort(a);
    b=b(perm);
    b=b(1);
    vec=1:size(Firings,2);
    vec(vec==b)=[];
    lag = zeros(size(Firings,2),1);
    lag(b)=1;
    FrComp=padarray(Firings(:, b),padsize,0,'pre');
    FrComp=FrComp(:,2);
    filCompFR = filter(ones(1,ws)/ws,1,FrComp);
    
    for j=1:length(vec)
        fr2plot = padarray(Firings(:,vec(j)),padsize,0,'pre');
        fr2plot=fr2plot(:,2);
        filFr = filter(ones(1,ws)/ws,1,fr2plot);
        [corr,lags]=xcorr(filFr,filCompFR,'unbiased');
        lag(vec(j))=lags(find(corr==max(corr),1,'First'));
    end
    hold on;
    for j=1:size(Firings,2)
        fr2plot = padarray(Firings(:,j),padsize,0,'pre')+offset(j);
        fr2plot = fr2plot(:,2);
        if lag(j)>0
            plot(time,[ones(lag(j),1).*min(fr2plot);fr2plot(1:end-lag(j))]);
        elseif lag(j)<0
            plot(time,[fr2plot(abs(lag(j)):end);ones(abs(lag(j))-1,1).*min(fr2plot)]);
        else
            plot(time,fr2plot);
        end
    end
    
    hold off;
    set(gca,'XTick',round(linspace(0,length(fr2plot),6)),'XTickLabel',round((linspace(0,length(fr2plot),6)./12000)),'box','off','TickDir','out');
    xlabel('time [sec]');
else
    SumFirings=[];
    Firings=[];
    display('No Superbursts');
end
set(findall(gcf,'-property','FontSize'),'FontUnits','pixels','FontSize',38);
end