function [tr,str,lags,slags] = CalcBurstTriggeredAstroTrace(bs,traces,time,lag);
bs= bs./12000;
while bs(1)<lag
    bs(1)=[];
end

sOn  = bs-lag;
sOff = bs+lag;
tt=time-time(1);
numelem = find(tt>=lag,1,'first');
tr = zeros(size(traces,1),numelem,numel(sOn));
for i=1:numel(sOn)
    start = find(time>=sOn(i),1,'first');
    stop = find(time>=sOff(i),1,'first');
    if ((stop-start)>lag*2)
        %         for j=1:size(traces,1)
        %             [psd(:,j,i),~]=pwelch(traces(j,start:stop),[],[],[],14.235);
        %         end
        tr(:,1:(stop-start)+1,i)=traces(:,start:stop);
    end
end
lags = linspace(-lag,lag,size(tr,2));
% figure;
% hold all;
for i=4:size(tr,3)
    for j=1:size(tr,1)
        temp = squeeze(tr(j,:,i));
        if size(temp,2)==size(tr,2) %This is because of squeeze which returns a row vector if there is one trace and column if there is more than one trace
            temp=temp';
        end
        k=size(temp,2);
        while (k<=size(temp,2))&&(k>0)
            if (nanmax(temp(:,k))<=1.2*nanmean(temp(:,k)))
                temp(:,k)=[];
            end
            k=k-1;
        end
        
        if ~isempty(temp)
%             plot(lags,temp);
        end
    end
end
title('All Traces');
xlabel('Lag Time [Sec]');
hold off;

fun = @(block_proc_struct) mean(sum(block_proc_struct.data,2));
sz = size(blockproc(squeeze(tr(1,:,:)),[2,31],fun),1); 
str = zeros(sz,size(tr,1));
tr=tr(:,:,4:end);
for i=1:size(tr,1)
str(:,i) = blockproc(squeeze(tr(i,:,:)),[2,31],fun); %Summing across trials and averaging every 2 time steps for each ROI
end
fun1 = @(block_proc_struct) mean(block_proc_struct.data);
slags = blockproc(lags,[1,2],fun1);

% figure;
% hold all;
%     for j=1:size(tr,1)
%         lh(j)=plot(slags,str(:,j));
%         set(lh(j), 'userdata', j);
%     end
%     set(lh, 'buttondownfcn', 'popgco');
% hold off;
% title('Smoothed All Traces');
% xlabel('Lag Time [Sec]');
end

