function [EAfile,ID] = EA_NEROCLUSTER(EAfile,varargin)
%
%
%
%
%
%
type = 'manual'; % manual (default);  min_ics (set minimal inner cluster similarity); max_ics (find maximum inner cluster similarity)
theta     = 1.0; % set if option mannual is chosen
min_clsim = 0.5; % set if option min_ics is chosen
show = 0;
newfigure = 1;
normalize = 'no'; %'overlap

PVPMOD(varargin);

nero_similaritymat = EAfile.NERO.NERO_SIMILARITYMAT;
if isequal(normalize,'overlap'),
    nero_overlap = EAfile.NERO.NERO_OVERLAPMAT;    
    nero_similaritymat = nero_similaritymat.*nero_overlap;
end
distmat = pdist(nero_similaritymat,'correlation'); %spearman, correlation
Z=linkage(distmat,'complete');

 
%iterate until criterion is fullfilled
if isequal(type,'manual'),
    figure,
    dendrogram(Z,0);
    set(gca,'TickDir','out');
    set(gca,'TickLength',[0.001 0.2])
    [temp theta] = ginput(1);
    close;
elseif isequal(type,'fixed'),
    % theta is set    
elseif isequal(type,'min_ics'),
    goon=1;
    while goon
        SCL = cluster(Z,'CutOff',theta,'Criterion','distance','Depth',2);  % set cluster threshold
        [sim,sim_var,scl]=innerClusterSimilarity(nero_similaritymat,SCL);
        temp = min(sim(scl>1));
        if temp > min_clsim    
            goon = 0;
        end
        theta = theta-0.01;
        if theta < 0
            goon =0;
            theta = theta+0.01;        
        end   
    end

elseif isequal(type,'max_ics'),
    %iterate and find maximum (resolution is set to 0.01)
    temp = nan(150,1);
    for ii=1:150,
        theta=0.01*ii;
        SCL = cluster(Z,'CutOff',theta,'Criterion','distance','Depth',2);  % set cluster threshold
        [sim,sim_var,scl]=innerClusterSimilarity(nero_similaritymat,SCL);
        temp(ii) = min(sim);    
    end
    [temp,id]=max(temp);
    theta=0.01*id;
end

EAfile.NERO.NERO_CLASSID = cluster(Z,'CutOff',theta,'Criterion','distance','Depth',2);  % set cluster threshold
NEid = 1:max(EAfile.NERO.NERO_CLASSID);
NEcts = histc(EAfile.NERO.NERO_CLASSID,NEid);
[NEcts,id] = sort(NEcts,'descend');
[temp,EAfile.NERO.NERO_CLASSID] = ismember(EAfile.NERO.NERO_CLASSID,id);

% help entries 
EAfile.NERO.SETTINGS.NERO_CLASSID = 'class assignment of network event rank order sequence';
EAfile.NERO.SETTINGS.HELP.theta = 'threshold for nero classification';
%  show result

if show
    if newfigure
        figure,
    end
    [H T ID]=dendrogram(Z,0,'COLORTHRESHOLD',theta);  % show cluster diagram
    hold on;
    plot([get(gca,'XLim')],[theta theta],'r-');
    set(gca,'TickDir','out');
    set(gca,'TickLength',[0.001 0.2])
    set(gca,'XDir','reverse'); 
end


