function [AdMat,ids,A2N,N2N,A2A,fr,traces,time]=CalcInteractions3(fr,ic,traces,varargin)
% Calculates partial correlations and a schematic of interaction based on lags with the
% maximum correlation between each pair of astrocytes and neurons. Outputs
% the adjacency matrix and the ids for each node.



%% Prepare data
if ~isempty(varargin)
    triggers=varargin{1};
    intensitymat=varargin{2};
    [remx,remy] = find(intensitymat>10*mean(intensitymat(:)));
    intensitymat(remx,remy)=nan;
    intensitymat = inpaint_nans(intensitymat,4); %Deals with artifact in culture 9
    t=varargin{3};
    rawTime=linspace(triggers(1),triggers(end),size(intensitymat,2));
    [traces,time]  = CalcDf_f(intensitymat,1/mean(diff(rawTime)),rawTime);
    for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)));
        fr(:,i)  =  histc(t1,time*12000);
    end
    traces = abs(traces(:,1:end-100))+abs(min(traces(:)));
    time   = time(:,1:end-100);
    fr     = fr(1:end-100,:);
end

%% Calculate Partial correlation between every pair of electrode and astrocyte (with electrode activity subtracted)
if size(traces,2)>size(traces,1)
    traces=traces';
end
% lags = zeros(size(combs,1),1);
% corrs = zeros(size(combs,1),1);
% temp = fr(:,combs(:,1));
% frs=mat2cell(temp',ones(size(temp,2),1));
% clear temp;
% temp = traces(:,combs(:,2));
% trc=mat2cell(temp',ones(size(temp,2),1));
% clear temp;

% parfor i=1:size(combs,1)
%     [lags(i),corrs(i)]=CalcCorr(trc{i},frs{i});
% end

%test here:
combs = allcomb(1:size(fr,2),1:size(traces,2));
neuros = combs(:,1);
astros = combs(:,2);
lag = 10;
lags = -(lag-1):(lag-1);

[rho,pval] = CalcPartCorri(traces,fr,lag);
rho(find(pval<0.05))=nan; 
[corrs,idx]= nanmax(rho,[],3);
corrs=corrs';
lags = lags(idx);
linearInd = sub2ind([size(corrs,1),size(corrs,2)], neuros,astros);

A2N = [neuros,astros,lags(linearInd),corrs(linearInd)];
%% Select optimum subset
% lags   = lags(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
% neuros = neuros(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
% astros = astros(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
% corrs  = corrs(corrs > nanmean(corrs)+sqrt(nanvar(corrs)));
% corrs = (corrs-min(corrs))./(max(corrs)-min(corrs));

%% Calculate Electrode to Electrode lags for subset
[Ecorrs,~,Elags,e1,e2] = PartialCorrWithLag3(fr,10);
e1 = double(e1);
e2 = double(e2);
Elags = Elags';
N2N = [e1,e2,Elags,Ecorrs];

%% Select optimum subset
% fac = 2;
% Elags   = Elags(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
% e1      = e1(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
% e2      = e2(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
% Ecorrs  = Ecorrs(Ecorrs > nanmean(Ecorrs)+fac*sqrt(nanvar(Ecorrs)));
% Ecorrs = (Ecorrs-min(Ecorrs))./(max(Ecorrs)-min(Ecorrs));
%% Calculate Astrocyte to Astrocyte lags for subset
[Acorrs,~,Alags,a1,a2] = PartialCorrWithLag3(traces,10);
a1=double(a1);
a2=double(a2);
Alags=Alags';
A2A = [a1,a2,Alags,Acorrs];

%% Select optimum subset
% Alags   = Alags(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
% a1      = a1(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
% a2      = a2(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
% Acorrs  = Acorrs(Acorrs > nanmean(Acorrs)+sqrt(nanvar(Acorrs)));
% Acorrs = (Acorrs-min(Acorrs))./(max(Acorrs)-min(Acorrs));
%% Organize Correlations so they can be used to calculate Network Schematic using Lags

CorrSummary(1,:)=[ic(1,neuros),ic(1,e1),a1'+256];
CorrSummary(2,:)=[astros'+256,ic(1,e2),a2'+256];
CorrSummary(3,:)=[corrs;Ecorrs;Acorrs]';
CorrSummary(4,:)=[lags;Elags;Alags];

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