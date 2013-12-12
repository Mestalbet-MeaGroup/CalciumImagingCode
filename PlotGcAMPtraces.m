% Filter and plot calcium traces from GcAMP6
window=500;
mask=ones(1,window)/window;


f = savgol(5,5,0);
yry = [flipud(intensitymat');intensitymat';flipud(intensitymat')];
yry=yry';
fun = @(x) 0.8*mean(x(:));
baseline = nlfilter(yry,[1 100],fun);
baseline = baseline(:,length(y)+1:length(y)*2);
traces = (intensitymat-baseline);
yry = [flipud(traces');traces';flipud(traces')];
traces = filtfilt(f,1,yry);
traces = traces(length(y)+1:length(y)*2,:);

Dtraces = iddata(traces,[],1/14.235);
[tracesf,T] = detrend(Dtraces,0);

yry = [flipud(intensitymat');intensitymat';flipud(intensitymat')];
raw = iddata(yry,[],1/14.235);
[rawf,T] = detrend(raw,0);


for i=1:size(intensitymat,1)
y=intensitymat(i,:)';
yry = [flipud(y);y;flipud(y)];
baseline = conv(yry,mask,'same');
baseline=baseline(length(y)+1:length(y)*2);
traces(:,i)=filtfilt(f,1,(y-baseline)./baseline);
end
traces = (traces - repmat(min(traces,[],1),size(traces,1),1))./(repmat(max(traces,[],1),size(traces,1),1)-repmat(min(traces,[],1),size(traces,1),1));
imagesc(traces(500:end,:)');

f = savgol(100,1,0);
baseline2 = filtfilt(f,1,y');


for i=1:size(rawdf,2)
eval(['traces(:,' num2str(i) ')=rawdf.y' num2str(i)]);
end
fun = @(block_struct)  min(block_struct.data(:));
baseline = blockproc(intensitymat,[1 100],fun);