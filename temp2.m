fileList = getAllFiles(uigetdir);
for ii=1:length(fileList) 
    load(fileList{ii});
    [DataSet{ii}.astroidx,DataSet{ii}.Manual.FiltTraces] = ClasifyAstrocyteTraces3(time,filtTraces);
    DataSet{ii}.Manual.traces  =traces(DataSet{ii}.astroidx,:);
end    

ii=4;
loc = 'E:\CalciumImagingArticleDataSet\';
PlotCorrelationMatrices(DataSet{ii}.a2a.cc ,DataSet{ii}.a2a.ccOrder,DataSet{ii}.a2a.ccOrder,0,'test');
print([loc DataSet{ii}.Record 'ccA2A.png'],'-dpng','-r400');
close all;
PlotCorrelationMatrices(DataSet{ii}.n2n.cc ,DataSet{ii}.n2n.ccOrder,DataSet{ii}.n2n.ccOrder,0,'test');
print([loc DataSet{ii}.Record 'ccN2N.png'],'-dpng','-r400');
close all;
PlotCorrelationMatrices(DataSet{ii}.a2n.cc ,DataSet{ii}.a2n.AccOrder,DataSet{ii}.a2n.NccOrder,1,'test');
print([loc DataSet{ii}.Record 'ccA2N.png'],'-dpng','-r400');
close all;

%%
close all;
for i=1:size(DataSet,1)
[NCorrs,NccOrder,AccOrder]=DendrogramOrderMatrix2(CorrsNsb{i}');
figure; PlotCorrelationMatrices(CorrsNsb{i},AccOrder,NccOrder,1,['Non-Superbursting ' DataSet{i}.Record]);

[NCorrs,NccOrder,AccOrder]=DendrogramOrderMatrix2(CorrsSB{i}');
figure; PlotCorrelationMatrices(CorrsNsb{i},AccOrder,NccOrder,1,['Superbursting ' DataSet{i}.Record]);
end
