fclose all; clear all; close all; clc;
load('DataSet_GFAP_GcAMP6_withSchematic_withMask_withLags.mat');
C=3;

% traces = DataSet{C}.dfTraces';
% time = DataSet{C}.dfTime;

traces = DataSet{C}.RawTraces;
time   = DataSet{C}.RawTime;
numTr = size(traces,1);
% Interpolate
 for i=1:numTr
      traces2(i,:)=interp(traces(i,:),4);
 end
 traces=traces2;
 clear traces2;
 
time=interp(time,4);
fs = 1/mean(diff(time));

bs = DataSet{C}.bs;
lag = 15; %seconds
[tr,str,lags,slags] = CalcBurstTriggeredAstroTrace(bs,traces,time,lag);
[AlignedMat,lags,lagmat] = AlignTimeSeries(tr,lags,fs);

%% Consider all ROIs together:

AlignedMat=permute(AlignedMat,[2,1,3]);
lagmat=permute(lagmat,[2,1,3]);
N = size(AlignedMat,2);
M = size(AlignedMat,3);
data = reshape(AlignedMat,size(AlignedMat,1),N*M);
lagdata = reshape(lagmat,size(AlignedMat,1),N*M);
elecs=[];
counter=1;
for j=1:N
    for i=1:M
       elecs(counter)=j;
       counter=counter+1;
    end
end
data(isnan(data))=nanmedian(data(:));
data(data==0)=nanmedian(data(:));
data2=zscore(data');
data2=data2';

% Create a Self-Organizing Map
dimension1 = 10;
dimension2 = 10;
net = selforgmap([dimension1 dimension2]);
net.trainParam.showWindow = false;
% Train the Network
[net,tr] = train(net,data2);
% Test the Network
outputs = net(data2);

[clustId,~]=find(outputs);
temp = unique(clustId);
for i=1:numel(temp)
    clustId(clustId==temp(i))=i;
end
colors = jet(max(clustId));
ElecColor = cbrewer('qual','Set1',size(AlignedMat,2));

% f1 = figure;
% maximize(gcf);
% f2 = figure;
% maximize(gcf);


%---Plot Each Cluster Seperately---%
for i=1:max(clustId)
%     set(0, 'CurrentFigure', f1)
%     subplot(ceil(sqrt(max(clustId))),ceil(sqrt(max(clustId))),i);
%     vec = find(clustId==i);
%     hold on;
%     for j=1:numel(vec)
%         plot(lags, data(:,vec(j)),'color',ElecColor(elecs(vec(j)),:));
%     end
%     hold off;
%     title(['Cluster ', num2str(i)],'color',colors(i,:));
    
%     set(0, 'CurrentFigure', f2)
%     subplot(ceil(sqrt(max(clustId))),ceil(sqrt(max(clustId))),i);
    vec = find(clustId==i);
    figure;
    hold on;
    for j=1:numel(vec)
        plot(lagdata(:,vec(j)), data(:,vec(j)),'color',ElecColor(elecs(vec(j)),:));
%           plot(lags, data(:,vec(j)),'color',ElecColor(elecs(vec(j)),:));
    end
    hold off;
    title(['Cluster ', num2str(i)],'color',colors(i,:));
    maximize(gcf);
    strng= ['C:\Users\Noah\Documents\GitHub\CaTracePics\Cluster_', num2str(i) '.png'];
    export_fig(strng,'-native');
    close all;
end


for i=1:size(AlignedMat,2)
    hold all
    for j=1:size(AlignedMat,3)
        temp = squeeze(AlignedMat(:,i,j));
        if nanmax(temp)>nanmean(temp)*1.05
            plot(temp);
        end
    end
    title(['ROI ', num2str(i)]);
    axis tight;
    maximize(gcf);
    strng= ['C:\Users\Noah\Documents\GitHub\CaTracePics\ByROI\ROI_', num2str(i) '.png'];
    export_fig(strng,'-native');
    close all;
end
