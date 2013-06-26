function [Corr,ic] = CalculateA2Bcc(t,ic,traces,time);

load('MeaMapPlot.mat', 'MeaMap');
[bs,be,SpikeOrder]=CalcBurstsSamora(t,ic);
close all;
% scale = numel(gfr)/max(t);

for i=1:size(SpikeOrder,1)
    mat = zeros(16,16);
    for ii=1:15
        mat(find(MeaMap == SpikeOrder(i,ii)))=1;
    end
    test = regionprops(mat,'Centroid');
    Xcm(i) = test.Centroid(1);
    Ycm(i) = test.Centroid(2);
end



[~,clusterInds,~] = clusterData([Xcm;Ycm]',0.9);
% numcolors = max(clusterInds);
cyan = [0 255 255] ./255;
magenta = [255 0 255]./255;
yellow = [255 255 0] ./255;
black = [0 0 0];
cmyk = [cyan;magenta;yellow;black];
if max(clusterInds<4)
    for i=1:max(clusterInds)
        colors(i,:) = cmyk(i,:);
    end
else
    colors=cmyk;
end

%% Plot Burst Initiation Center of Mass
hold on;
for i = 1:size(SpikeOrder,1)
    plot(Xcm(i),Ycm(i),'.','Color',colors(clusterInds(i),:),'MarkerSize',15);
end
hold off;

%% Calculate Correlation to Group
% gfr = histc(sort(t),time*1000);
t=sort(t);
for i=1:max(clusterInds);
    burstset = (i==clusterInds);
    xc(i) = mean(Xcm(burstset));
    yc(i) = mean(Ycm(burstset));
    burstsetStarts = bs(burstset);
    burstsetEnds = be(burstset);
    %     fr=zeros(size(gfr));
    t1=[];
    for ii=1:numel(burstsetStarts)
        %         fr(round(burstsetStarts(ii)*scale):round(burstsetEnds(ii)*scale)) = gfr(round(burstsetStarts(ii)*scale):round(burstsetEnds(ii)*scale));
        t1 = [t1 t(find(t>=burstsetStarts(ii),1,'First'):find(t>=burstsetEnds(ii),1,'First'))];
    end
    fr2test(i,:)=histc(sort(t1),time*1000);
    NumBurstsInCluster(i)=sum(burstset);
end;

NumTraces = size(traces,2);
NumBurstClusters=max(clusterInds);
Corr=zeros(NumBurstClusters,NumTraces);
for ii=1:NumBurstClusters
    if NumBurstsInCluster(ii)>10
        for ij=1:NumTraces
            %                 Corr(ii,ij)=NormalizedCorrelationwithStat(traces(:,ij),fr2test(ii,:)',t1,time);
            Corr(ii,ij)=NormalizedCorrelation(fr2test(ii,:)',traces(:,ij)); % Normalized unbiased correlation
            %             Corr(ii,ij)=Corr(ii,ij)*NumBurstsInCluster(ii)/max(NumBurstsInCluster);
        end
    else
        Corr(ii,:)=nan;
    end
end

xc=round(xc);
yc=round(yc);
ic=[];
for i=1:numel(xc)
    ic = [ic;MeaMap(xc(i),yc(i))];
end

end