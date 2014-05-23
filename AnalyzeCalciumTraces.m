function AnalyzeCalciumTraces(traces,time,bs,t,ic,be) 
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.02 0.02], [0.02 0.02]);

% traces = DataSet{C}.dfTraces';
% time = DataSet{C}.dfTime;
% up=30;
% numTr = size(traces,1);
% % Interpolate
% for i=1:numTr
%     traces2(i,:)=interp(traces(i,:),up);
% end
% traces=traces2;
% clear traces2;
% 
% time=sort(time);
% time=interp(time,up);
% time=sort(time);
fs = 1/mean(diff(time));

lag = 1; %seconds
[TriggeredTrace,lags,bs] = CalcBurstTriggeredAstroTrace(bs,traces,time,lag,t,be);
%% Consider all ROIs together:
TriggeredTrace=permute(TriggeredTrace,[2,1,3]);
N = size(TriggeredTrace,2); %ROI
M = size(TriggeredTrace,3); %Trials
data = reshape(TriggeredTrace,size(TriggeredTrace,1),N*M);
elecs=[];
counter=1;
for j=1:N
    for i=1:M
        elecs(counter)=j;
        counter=counter+1;
    end
end
% 
% % Create a Self-Organizing Map
% dimension1 = 10;
% dimension2 = 10;
% net = selforgmap([dimension1 dimension2]);
% net.trainParam.showWindow = false;
% % Train the Network
% [net,tr] = train(net,data);
% % Test the Network
% outputs = net(data);
% 
% [clustId,~]=find(outputs);
% temp = unique(clustId);
% for i=1:numel(temp)
%     clustId(clustId==temp(i))=i;
% end
% colors = jet(max(clustId));
% ElecColor = cbrewer('qual','Set1',size(TriggeredTrace,2));
% 
% %% Plot Each Cluster Seperately
% f1 = figure('name', 'Clustered Traces');
% for i=1:max(clustId)
%     set(0, 'CurrentFigure', f1)
%     lh1(i) = subplot(ceil(sqrt(max(clustId))),ceil(sqrt(max(clustId))),i);
%     vec = find(clustId==i);
%     hold on;
%     for j=1:numel(vec)
%         if (nanmax(data(:,vec(j))))>(nanmean(data(:,vec(j)))*1.05) %work here
%             lh2(i,j)=plot(lags, data(:,vec(j)),'color',ElecColor(elecs(vec(j)),:));
%             axis tight;
%             [traceProp.ROI,traceProp.trialID]=ind2sub([N,M],vec(j));
%             traceProp.Cluster=i;
%             traceProp.TrigTime=bs(traceProp.trialID)/12000;%+lags(1);
%             plotbuttondown(0,1,lh2(i,j),'ROI',traceProp.ROI,'trialId',traceProp.trialID,'Cluster',traceProp.Cluster,'TriggerTime',traceProp.TrigTime)
%         end
%     end
%     set(lh1(i), 'userdata', traceProp, 'buttondownfcn', 'popgca');
%     hold off;
%     title(['Cluster ', num2str(i)],'color',colors(i,:));
% 
% end
% maximize(gcf);
%% Plot By ROI

ElecColor = jet(size(TriggeredTrace,3));
% start = find(lags>=-1,1,'First');
% stop = find(lags>=4,1,'First');
start = 1;
stop  = length(lags);

f2 = figure('name', ['Traces by ROI - Number of Triggers: ', num2str(size(TriggeredTrace,3))]);
for i=1:N
    set(0, 'CurrentFigure', f2)
    lh3(i) = subplot(ceil(sqrt(N)),ceil(sqrt(N)),i);
    hold on;
    for j=1:M
%         fun = @(i,j) RasterPlotLine(t,ic,(bs(j)+lags(start))*12000,(bs(j)+lags(stop))*12000,squeeze(TriggeredTrace(start:stop,i,j)),lags(start:stop),abs(lags(start)),bs(j)*12000);
         fun = @(i,j) RasterPlotLine2(t,ic,(bs(j)+lags(start))*12000,(bs(j)+lags(stop))*12000,traces(i,:),time,bs(j)*12000);
%        if max(TriggeredTrace(:,i,j))>mean(TriggeredTrace(:,i,j))*1.05
            lh4(i,j)=plot(lags, TriggeredTrace(:,i,j),'color',ElecColor(j,:));
            axis tight;
            traceProp.ROI=i; 
            traceProp.trialID=j;
            traceProp.TrigTime=bs(traceProp.trialID)/12000;%+lags(1);
            traceProp.function=fun;
            set(lh4(i,j), 'userdata', traceProp, 'buttondownfcn',...
    'popgco(''postpopcmd'', ''axis(''''auto'''')''); eval(''get(gcbo, ''''userdata'''')''); eval([''set(gcf,''''KeyPressFcn'''',@keypress_callback)''])');
    end
    set(lh3(i), 'buttondownfcn', 'popgca');
    hold off;
    title(['ROI ', num2str(i)]);
end
maximize(gcf);
end
%To DO:
% (1) add popsubplot functionality popsubplot.m
% (2) Don't fill-in alignment gaps
% (3) Show Burst data for each trigger in graph
