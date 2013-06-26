t = DataSet{4}.t;
ic = DataSet{4}.ic;
tt=sort(t);
ind = find(tt./12000 > time1(end),1,'First');
a=2.232E4;
time = downsample(triggers, floor(352011/32000));
time=time(1:end-1);
traces=traces(:,1:a);
time=time(1:a);
for i=1:46; [filtered(i,:),time1] = FilterCalciumTraces(FiltTraces(:,i),time); end
[t1,ic1]=CutSortChannel(t,ic,0,tt(ind));
PlotRasterTraces(t1,ic1,filtered,time1);

DataSet{4}.CroppedAt=tt(ind);
DataSet{4}.torig=t;
DataSet{4}.icorig = ic;
DataSet{4}.t=t1;
DataSet{4}.ic = ic1;
DataSet{4}.Manual.FiltTraces = filtered;
DataSet{4}.Manual.time=time1;
DataSet{4}.Manual.traces=traces;

ii=4;
ic = DataSet{4}.ic;
t = DataSet{4}.t;

for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)))./12;
    DataSet{ii}.FR(:,i)  = histc(t1,DataSet{ii}.Manual.time*1000);     % Calculate the firing rate for each electrode
end
DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2);

DataSet{ii}.a2n.cc              = CalculateA2Ncc(DataSet{ii}.Manual.FiltTraces,DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.FR,DataSet{ii}.Manual.time); % Astrocyte to neuron cross-correlation, requires NormalizedCorrelationwithStat.m and NormalizedCorrelation.m
[~,DataSet{ii}.a2n.AccOrder, DataSet{ii}.a2n.NccOrder] = DendrogramOrderMatrix2(DataSet{ii}.a2n.cc); 

