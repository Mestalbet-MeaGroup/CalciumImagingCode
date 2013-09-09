function PlotTracesFR (t,ic,time,traces,start,minutes);
% Plots the firing rate in a subplot underneath an image scaled plot of the
% astrocyte traces.
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.05 0.05]);
start = find(time>=start,1,'First');
numsamples = round(minutes*60*14.5);
% load('Neuropil_3334_014.mat');
load('Neuropil_3334_122.mat');
filtNeuropil=(filtNeuropil-min(filtNeuropil))./(max(filtNeuropil)-min(filtNeuropil));
filtNeuropil=repmat(filtNeuropil,1,size(traces,2));
traces = (traces - repmat(min(traces,[],1),size(traces,1),1))./(repmat(max(traces,[],1),size(traces,1),1)-repmat(min(traces,[],1),size(traces,1),1));
traces=traces-filtNeuropil*0.5;
traces = (traces - repmat(min(traces,[],1),size(traces,1),1))./(repmat(max(traces,[],1),size(traces,1),1)-repmat(min(traces,[],1),size(traces,1),1));
fun = @(x) mean(x);
B = nlfilter(traces, [1 100], fun);

time=time(start:start+numsamples);
traces=traces(start:start+numsamples,:);

t=t./12; %ms
time=time.*1000;  %ms
win=floor(length(time)/20);
[tNew,icNew]=CutSortChannel(t,ic,time(1),time(end));
[~,index]=sort( max(traces,[],1));
traces = traces(:,index);

traces = (traces - repmat(min(traces,[],1),size(traces,1),1))./(repmat(max(traces,[],1),size(traces,1),1)-repmat(min(traces,[],1),size(traces,1),1));
spikes=histc(tNew,time);

subplot(8,1,1:7);
imagesc(traces');
set(gca,'YDir','normal');
set(gca,'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[],'FontSize',16,'TickDir','out');
box('off');
ylabel('astrocytes');

subplot(8,1,8);
plot(spikes);
xlim([1 length(time)]);
set(gca,'XTick',[],'YTick',[])
set(gca,'XTick',round(linspace(1,numel(time),10)),'XTickLabel', round((linspace(time(1),time(end),10)-time(1))/1000),'YTickLabel',[]);
xlabel('time [sec]','FontSize',16);
maximize(gcf);
set(gcf,'color','none');
% export_fig 'AstroColorTraceFR.png'
end