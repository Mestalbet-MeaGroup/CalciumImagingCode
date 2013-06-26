% Create pooled SB vs. Non-SB regime correlations

for i=1:size(DataSet,1)
    [CorrMatSB,CorrMatNsb]= CalculateA2NccPerRegime(DataSet{i}.t,DataSet{i}.ic,DataSet{i}.Manual.FiltTraces,DataSet{i}.Manual.time);
    CorrsSB{i}=CorrMatSB;
    CorrsNsb{i}=CorrMatNsb;
end


SB=[];
for i=1:size(DataSet,1)
    vec = CorrsSB{i}(:);
    vec(isnan(vec))=[];
    if  sum(vec)>0
        SB = [SB;vec];
    end
end

nSB=[];
vec=[];
for i=1:size(DataSet,1)
    vec = CorrsNsb{i}(:);
    vec(isnan(vec))=[];
    if  sum(vec)>0
        nSB = [nSB;vec];
    end
end

%% Histograms per culture

for i=1:size(DataSet,1)
    vec = CorrsSB{i}(:);
    vec(isnan(vec))=[];
    figure; hist(vec,50); title([DataSet{i}.Record(1:9) ' ' 'SuperBursting']); xlim([0 1]);
    vec = CorrsNsb{i}(:);
    vec(isnan(vec))=[];
    figure; hist(vec,50); title([DataSet{i}.Record(1:9) ' ' 'Bursting']); xlim([0 1]);
end

%% Probability of a connection
for i=1:size(CorrsSB,2)
    test = CorrsSB{i}(:);
    test(test==0)=[];
    test(isnan(test))=[];
    if ~isempty(test)
        numastro=size(CorrsSB{i},1);
        numNeuro=size(CorrsSB{i},2);
        probconSB(i) = numel(test) / numel(allcomb(1:numNeuro,1:numastro));
    else
        probconSB(i)=nan;
    end
end

for i=1:size(CorrsNsb,2)
    test = CorrsNsb{i}(:);
    test(test==0)=[];
    test(isnan(test))=[];
    numastro=size(CorrsNsb{i},1);
    numNeuro=size(CorrsNsb{i},2);
    probconNsb(i) = numel(test) / numel(allcomb(1:numNeuro,1:numastro));
end

MeanProbSB = mean(probconSB(~isnan(probconSB)));
StdProbSB = std(probconSB(~isnan(probconSB)));

MeanProbNsb = mean(probconNsb);
StdProbNsb = std(probconNsb);

h = barwitherr([StdProbSB;StdProbNsb], [MeanProbSB;MeanProbNsb]);
set(gca,'XTickLabel',{'SuperBursting Regime','Non-Superbursting Regime'},'Xlim',[0.7 2.3],'FontSize',16);
set(gca,'PlotBoxAspectRatio', [1 2 1]);
ylabel('Probability of Finding a Significant Astrocyte-Neuron Correlation','FontSize',14);
xticklabel_rotate(XTick,55,{'Non-Superbursting', 'Super-Bursting'},'interpreter','none');
print('A2NConnectionProbability.png','-dpng','-r400');