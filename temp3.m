fileList = getAllFiles(uigetdir);
i=3;
load(fileList{i});
% traces = DataSet{i}.Manual.traces;
[a,b]=ClasifyAstrocyteTraces3(time,filtTraces);
PlotRasterTraces(t,ic,filtTraces(:,a),time);