function [dfTraces,time]  = CalcDf_f(traces,fs,time);
% calculates df/f of calcium trace according to:
% In vivo two-photon imaging of sensory-evoked dendritic calcium signals in cortical neurons
% Hongbo Jia,	 Nathalie L Rochefort,	 Xiaowei Chen	 & Arthur Konnerth
% Nature Protocols 6, 28–35 (2011) doi:10.1038/nprot.2010.169

% fs = 14.235 Hz normally for GcAMP6
% time = (0:size(traces,2)-1)./fs;
t0 = ceil(0.2 * fs); %seconds -> samples
t1 = ceil(6 * fs); %seconds -> samples
t2 = ceil(10 * fs); %seconds -> samples

%---Time Dependent Baseline---%
fun1 = @(x) (1/t1)*trapz(x,1);
fm  = colfilt([flipud(traces');traces';flipud(traces')],[t1 1],'sliding',fun1);
% fm = [flipud(fm);fm;flipud(fm)];
fun2 = @(x) min(x,[],1);
f0 = colfilt(fm,[t2 1],'sliding',fun2);
f0=f0(length(time)+1:2*length(time),:)';


%---Relative fluoresence signal---%
r = ((traces-f0)./f0)';

%---Apply noise filtering---%
r = [flipud(r);r;flipud(r)];

%-Savitzky-Golay Instead-%
% f = savgol(t0,t0*2,0);
% dfTraces=filtfilt(f,1,r');

%-exponentially weighted moving average from citation-%
dfTraces = EWMA(r',t0); 
%--%

dfTraces=dfTraces(:,length(time)+1:2*length(time));
% dfTraces = dfTraces(:,500:end-100); % cut ends off recording
% time = time(500:end-100);
dfTraces = dfTraces(:,5:end-10); % cut ends off recording
time = time(5:end-10);

%---De-trend data to start at Zero-mean---%
data1 = iddata(dfTraces',[],1/fs);
[data_d1,~] = detrend(data1,0);
dfTraces=data_d1.y';

%---Plot overlay filtered and non-filtered traces---%
% r=r(size(traces,2)+1:2*size(traces,2),:)';
% data2 = iddata(traces',[],1/fs);
% [data_d2,~] = detrend(data2,0);
% traces=data_d2.y';
% 
% data3 = iddata(r',[],1/fs);
% [data_d3,~] = detrend(data3,0);
% r=data_d3.y';
% 
% test1 = (dfTraces(1,:)-min(dfTraces(1,:)))/(max(dfTraces(1,:))-min(dfTraces(1,:)));
% test2 = (traces(1,:)-min(traces(1,:)))/(max(traces(1,:))-min(traces(1,:)));
% test3 = (r(1,:)-min(r(1,:)))/(max(r(1,:))-min(r(1,:)));
% hold on;
% plotyy((0:size(traces,2)-1)./fs,test2,time,test1);
% plot((100:size(traces,2)-99)./fs,test3(100:end-99),'-.r');
% hold off;


    function smoothed_z = EWMA(z,L)
        
        % Computes the exponentially weighted moving average (with memory L) of
        % input data z
        
        lambda = 1-2/(L+1);
        
        smoothed_z = zeros(size(z));
        for i = 1:size(z,1)
            smoothed_z(i,1) = z(i,1);
            for j = 2:size(z,2)
                smoothed_z(i,j) = lambda * smoothed_z(i,j-1) + (1-lambda) * z(i,j);
            end
        end
    end
end