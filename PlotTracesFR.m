function PlotTracesFR (t,ic,time,traces,start,minutes);
% Plots the firing rate in a subplot underneath an image scaled plot of the
% astrocyte traces.
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.05 0.05]);
start = find(time>=start,1,'First');
numsamples = round(minutes*60*14.5);

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
set(gca,'XTick',linspace(1,numel(time),10),'XTickLabel', round(linspace(time(1),time(end),10)/100)/10,'YTick',[],'YTickLabel',[],'FontSize',16,'TickDir','out');
box('off');
ylabel('Astrocytes');

subplot(8,1,8);
plot(spikes);
xlim([1 length(time)]);
set(gca,'XTick',[],'YTick',[])
set(gca,'XTickLabel',[],'YTickLabel',[]);
xlabel('Time [Sec]','FontSize',16);
maximize(gcf);
set(gcf,'color','w');
export_fig 'AstroColorTraceFR.png'
end