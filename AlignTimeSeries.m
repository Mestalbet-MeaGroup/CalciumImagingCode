function [AlignedMat,lags,lagmat] = AlignTimeSeries(traces,lags,fs);
% Align two time series. Designed especially for calcium traces. 
AlignedMat=[];
% fs= 14.235; %sampling rate;
%% Align by corr
[~,idx]= max(squeeze(traces(1,:,:)),[],1);
idx=floor(mean(idx));
traces = traces(:,idx-floor(idx/2):idx+floor(idx/2),:);
lags=lags(idx-floor(idx/2):idx+floor(idx/2));
[~,num]=max(max(squeeze((max(traces,[],2))),[],1));

for i=1:size(traces,1)
    for j=6:size(traces,3)
        [lag,~]=CalcCorrRaw(zscore(squeeze(traces(i,:,j))),zscore(squeeze(traces(i,:,num))),30);
        AlignedMat(i,:,j)=lagmatrix(squeeze(traces(i,:,j)),-1*(lag));
        lagmat(i,:,j)=lagmatrix(lags,-1*(lag));
    end
end
[~,idx]=max(mean(squeeze(AlignedMat(1,:,:)),2));
vec = idx-60*4:idx+80*4;
lags=lags(vec);
AlignedMat=AlignedMat(:,vec,:);
lagmat=lagmat(:,vec,:);

%% Cluster each channel
% [colors,clustI]=ClusterTraces(AlignedMat);

%% Align within clusters seperately
% AlignedMat2=zeros(size(AlignedMat));
% for i=1:size(AlignedMat,1)
%     for k = 1:max(clustI{i})
%         indices = find(clustI{i}==k);
%         tempk = squeeze(AlignedMat(i,:,indices));
%         if size(tempk,2)==size(AlignedMat,2) %This is because of squeeze which returns a row vector if there is one trace and column if there is more than one trace
%             tempk=tempk';
%         end
%         [~,num]=max(max(tempk,[],1));
%         if ~isempty(tempk)
%             for j=1:numel(indices)
%                 [lag,~]=CalcCorrRaw(zscore(tempk(:,j)),zscore(tempk(:,num)),30);
%                 AlignedMat2(i,:,indices(j))=lagmatrix(tempk(:,j),-1*(lag));
%             end
%         end
%     end
% end

%% Plot Aligned Traces for 1 channel
% figure;
% hold on;
% i=54;
% for k=1:size(AlignedMat,3);
%     plot(linspace(0,size(squeeze(AlignedMat2(i,:,k)),2)/fs,size(squeeze(AlignedMat2(i,:,k)),2)),squeeze(AlignedMat2(i,:,k)),'color',colors{i}(clustI{i}(k),:));
% end
% hold off;
% title('Aligned Traces for One Channel');
% xlabel('Time [Sec]');

%% Calculate Alignment of mean traces across channels
% AllSet=[];
% for i=1:143
%     for clust=1:9
%         temp = squeeze(AlignedMat2(i,:,clustI{i}==clust));
%         if size(temp,2)==size(AlignedMat2,2) %This is because of squeeze which returns a row vector if there is one trace and column if there is more than one trace
%             temp=temp';
%         end
%         k=size(temp,2);
%         while (k<=size(temp,2))&&(k>0)
%             if (nanmax(temp(:,k))<=1.1*nanmean(temp(:,k)))
%                 temp(:,k)=[];
%             end
%             k=k-1;
%         end
%         if ~isempty(temp)
%             AllSet = [AllSet,temp];
%         end
%     end
% end
% AlignedTrace = AlignTraces(AllSet);

%% Plot Mean Reconstructed Traces from one channel
% figure;
% hold all;
% i=54;
%     for clust=1:9
%         temp = squeeze(AlignedMat2(i,:,clustI{i}==clust));
%         if size(temp,2)==size(AlignedMat2,2) %This is because of squeeze which returns a row vector if there is one trace and column if there is more than one trace
%             temp=temp';
%         end
%         k=size(temp,2);
%         while (k<=size(temp,2))&&(k>0)
%             if (nanmax(temp(:,k))<=1.1*nanmean(temp(:,k)))
%                 temp(:,k)=[];
%             end
%             k=k-1;
%         end
%         if ~isempty(temp)
%              plot(linspace(0,size(temp,1)/fs,size(temp,1)),nanmean(temp,2),'.');
%         end
%     end
% hold off;
% title('Mean Reconstructed Traces for One Channel');
% xlabel('Time [Sec]');

%% Plot Aligned reconstructed mean traces
% figure; plot(linspace(0,size(AllSet,1)/fs,size(AllSet,1)),AllSet);
% title('Aligned Reconstructed Traces for All Channels');
% xlabel('Time [Sec]');
%% 

    function AlignedTrace = AlignTraces(tr)
        [~,numM]=max(max(tr,[],1));
        for jj=1:size(tr,2)
            [lg,~]=CalcCorrRaw(zscore(tr(:,jj)),zscore(tr(:,numM)),30);
            AlignedTrace(:,jj)=lagmatrix(tr(:,jj),-1*(lg));
        end
    end

    function [colors,clustI]=ClusterTraces(AlignedMat);
        for ii=1:size(AlignedMat,1);
            tr{ii} = myNeuralNetworkFunction2(squeeze(AlignedMat(ii,:,:)));
            colors{ii} = cbrewer('qual','Set1',size(tr{ii},1));
            [clustI{ii},~]=find(tr{ii}==1);
        end
    end

%% Align by peaks
%
% for i=1:size(traces,1)
%     [~,t0] = max(zscore(squeeze(traces(i,:,15))));
%     for j=6:size(traces,3)
%         [~,t1] = max(zscore(squeeze(traces(i,:,j))));
%         lag = t1-t0;
%         AlignedMat(i,:,j)=lagmatrix(squeeze(traces(i,:,j)),-1*(lag));
%     end
% end

%% Align by onsets
% for i=1:size(traces,1)
%     t0 = CalcCaOnsets(zscore(squeeze(traces(1,:,15)))');
%     for j=6:size(traces,3)
%         t1 = CalcCaOnsets(zscore(squeeze(traces(i,:,j)))');
%         if ~isempty(t1)&&~isempty(t0)
%             lag = t1(1)-t0(1);
%             AlignedMat(i,:,j)=lagmatrix(squeeze(traces(i,:,j)),-1*(lag));
%         else
%             [lag,~]=CalcCorrRaw(zscore(squeeze(traces(i,:,j))),zscore(squeeze(traces(1,:,15))),20);
%             AlignedMat(i,:,j)=lagmatrix(squeeze(traces(i,:,j)),(lag));
%         end
%     end
% end
%
% [~,t0] = max(zscore(squeeze(AlignedMat(i,:,15))));
% for i=1:size(AlignedMat,1)
%     for j=1:size(AlignedMat,3)
%         [~,t1] = max(zscore(squeeze(AlignedMat(i,:,j))));
%         lag = t1-t0;
%         AlignedMat2(i,:,j)=lagmatrix(squeeze(AlignedMat(i,:,j)),-1*(lag));
%     end
% end


end