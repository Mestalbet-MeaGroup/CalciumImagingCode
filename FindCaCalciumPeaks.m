function PeakIndex = FindCaCalciumPeaks(trace);

filtTrace = KalFilt(trace);
% filtTrace=filtTrace';
% filtTrace = [flipud(filtTrace);filtTrace;flipud(filtTrace)];
sv_trace=filtfilt(savgol(100,1,0),1,filtTrace);
% filtTrace = filtTrace(length(trace)+726:length(trace)*2+725);
% sv_trace = sv_trace(length(trace)+726:length(trace)*2+725);
tr=filtTrace-sv_trace;
thr = quantile(tr,10);
thr=thr(10);
tr(tr<thr)=0;
tr = zscore(tr);
tr(tr<1)=0;
[bs,be]=initfin(tr>0);
for i=1:numel(bs)
    if bs(i)-10>0
        pk(i) = max(trace(bs(i)-10:be(i)));
    else
        pk(i) = max(trace(1:be(i)));
    end
end
pk = pk(pk>(mean(trace)+2*std(trace)));
pki = ismember(trace,pk);
PeakIndex = find(pki);


% [~,PeakIndex] = findpeaks(tr,'MINPEAKHEIGHT',1.5,'MINPEAKDISTANCE',60);
end