function [AdMat,ids,A2N,N2N,A2A,fr,traces,time]=CalcInteractions(fr,ic,traces,varargin)
% Calculates correlations and a schematic of interaction based on lags with the
% maximum correlation between each pair of astrocytes and neurons. Outputs
% the adjacency matrix and the ids for each node.



%% Prepare data
if ~isempty(varargin)
    triggers=varargin{1};
    intensitymat=varargin{2};
    t=varargin{3};
    rawTime=linspace(triggers(1),triggers(end),size(intensitymat,2));
    [traces,time]  = CalcDf_f(intensitymat,1/mean(diff(rawTime)),rawTime);
    for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)));
        fr(:,i)  =  histc(t1,time*12000);
    end
    traces = traces(:,1:end-50);
    time   = time(:,1:end-50);
    fr     = fr(:,1:end-50);
end
%% Remove outliers from trace
fun =@(block_struct) deleteoutliers(block_struct.data, 0.05, 1);
traces = blockproc(traces,[1,size(traces,2)],fun,'UseParallel',true);
traces = inpaint_nans(traces,4)+abs(min(traces(:)));
%% Calculate correlation between every pair of electrode and astrocyte
if size(traces,2)>size(traces,1)
    traces=traces';
end
combs = allcomb(1:size(fr,2),1:size(traces,2));
neuros = combs(:,1);
astros = combs(:,2);
lags = zeros(size(combs,1),1);
corrs = zeros(size(combs,1),1);
temp = fr(:,combs(:,1));
frs=mat2cell(temp',ones(size(temp,2),1));
clear temp;
temp = traces(:,combs(:,2));
trc=mat2cell(temp',ones(size(temp,2),1));
clear temp;

parfor i=1:size(combs,1)
    [lags(i),corrs(i)]=CalcCorr(trc{i},frs{i});
end
A2N = [neuros,astros,lags,corrs];
corrs = (corrs-min(corrs))./(max(corrs)-min(corrs));
%% Select optimum subset
lags   = lags(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
neuros = neuros(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
astros = astros(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
corrs  = corrs(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
%% Calculate Electrode to Electrode lags for subset
combs = nchoosek(1:size(fr,2),2);
e1 = combs(:,1);
e2 = combs(:,2);
temp = fr(:,e1);
fr1=mat2cell(temp',ones(size(temp,2),1));
temp = fr(:,e2);
fr2=mat2cell(temp',ones(size(temp,2),1));
clear temp;

parfor i=1:size(e1,1)
    [Elags(i),Ecorrs(i)]=CalcCorrNeuro(fr1{i},fr2{i});
end
N2N = [e1,e2,Elags,Ecorrs];
Ecorrs = (Ecorrs-min(Ecorrs))./(max(Ecorrs)-min(Ecorrs));
%% Select optimum subset
fac = 2;
Elags   = Elags(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
e1      = e1(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
e2      = e2(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
Ecorrs  = Ecorrs(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
%% Calculate Astrocyte to Astrocyte lags for subset
combs = nchoosek(1:size(traces,2),2);
a1 = combs(:,1);
a2 = combs(:,2);
temp = traces(:,a1);
tr1=mat2cell(temp',ones(size(temp,2),1));
temp = traces(:,a2);
tr2=mat2cell(temp',ones(size(temp,2),1));
clear temp;

parfor i=1:size(a1,1)
    [Alags(i),Acorrs(i)]=CalcCorrAstro(tr1{i},tr2{i});
end
A2A = [a1,a2,Alags,Acorrs];
Acorrs = (Acorrs-min(Acorrs))./(max(Acorrs)-min(Acorrs));
%% Select optimum subset
Alags   = Alags(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
a1      = a1(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
a2      = a2(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
Acorrs  = Acorrs(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
%% Calculate Network Schematic using Lags

CorrSummary(1,:)=[ic(1,neuros),ic(1,e1),a1'+256];
CorrSummary(2,:)=[astros'+256,ic(1,e2),a2'+256];
CorrSummary(3,:)=[corrs',Ecorrs,Acorrs]';
CorrSummary(4,:)=[lags',Elags,Alags]';

%% Restrict to Only Top Scores
CorrSummary = CorrSummary(:,CorrSummary(3,:)>nanmean(CorrSummary(3,:))+sqrt(nanvar(CorrSummary(3,:))));
%% Create Node Names

list = unique([CorrSummary(1,:),CorrSummary(2,:)]);
for i=1:length(list)
    if list(i)>256
        ids{i} = ['Astrocyte ',num2str(list(i)-256)];
    else
        ids{i} = ['Elec ',num2str(list(i))];
    end
    CorrSummary(1,CorrSummary(1,:)==list(i))=i;
    CorrSummary(2,CorrSummary(2,:)==list(i))=i;
end
%% Create Adjacency Matrix and Plot Network
AdMat = zeros(length(list));
pos = find(CorrSummary(4,:)>0);
neg = find(CorrSummary(4,:)<0);

for i=1:length(pos)
    AdMat(CorrSummary(1,pos(i)),CorrSummary(2,pos(i)))=1;
end
for i=1:length(neg)
    AdMat(CorrSummary(2,neg(i)),CorrSummary(1,neg(i)))=1;
end
% opengl software;
% bg = biograph(AdMat,ids);
% view(bg);
end