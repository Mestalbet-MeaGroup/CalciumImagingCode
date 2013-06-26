for i=1:size(DataSet,1)
    if size(DataSet{i}.Manual.traces,2)>10
        PlotResultsOnMEAcc(DataSet{i}.a2n.cc,DataSet{i}.ic,DataSet{i}.n2n.cc,str2num(DataSet{i}.Record(strfind(DataSet{i}.Record,'ch')+2:strfind(DataSet{i}.Record,'ch')+4)),[DataSet{i}.Record '_']);
    end
end

for i=1:size(DataSet,1)
    if size(DataSet{i}.Manual.traces,2)>10
        PlotResultsOnMEAcoh(DataSet{i}.a2n.coh,DataSet{i}.ic,DataSet{i}.a2n.cohFreq,DataSet{i}.n2n.cc,str2num(DataSet{i}.Record(strfind(DataSet{i}.Record,'ch')+2:strfind(DataSet{i}.Record,'ch')+4)),[DataSet{i}.Record '_']);
        delete('MergeCaMEA.png');
    end
end

for i=1:size(DataSet,1)
    if size(DataSet{i}.Manual.traces,2)>10
        [Corr,ic] = CalcCorrA2Bursts(DataSet{i}.t,DataSet{i}.ic,DataSet{i}.Manual.FiltTraces,DataSet{i}.GFR);
        PlotResultsOnMEAbursts(Corr,ic,str2num(DataSet{i}.Record(strfind(DataSet{i}.Record,'ch')+2:strfind(DataSet{i}.Record,'ch')+4)),[DataSet{i}.Record '_']);
        delete('MergeCaMEA.png');
    end
end