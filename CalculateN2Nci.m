function CohMat=CalculateN2Nci(t,ic)
%% Calculate Coherence between detected spikes on different channels 
% t  = spike times in sample number, ordered by channel
% ic = index channel
% CohMat = integral of the coherence across all frequencies for significant
% coherence results between each electrode.
% Written by: Noah Levine-Small
% Revision 1: 30/04/2013


choices = nchoosek(1:size(ic,2),2);
n1=choices(:,1);
n2=choices(:,2);

spikes=cell(numel(n1),1);
spikes2=cell(numel(n2),1);
for i=1:numel(n1)
    spikes{i} = sort(t(ic(3,n1(i)):ic(4,n1(i))));
    spikes2{i} = sort(t(ic(3,n2(i)):ic(4,n2(i))));
end

parfor i=1:numel(n1)
    if numel(spikes{i})>500 && numel(spikes2{i})>500
        [freq,~,~,~,coh,s,~,~,~]=coherence2(spikes{i},spikes2{i},1,12,500);
        if numel(find(coh(freq>2&freq<6)>s(freq>2&freq<6)))
            tracecoh(i) = trapz(coh);
            %          tracecoh1(i) = trapz(coh(find(freq>1,1,'first'):find(freq>2,1,'first')));
            %          tracecoh2(i) = trapz(coh(find(freq>2,1,'first'):find(freq>3,1,'first')));
        else
            tracecoh(i)=nan;
            %          tracecoh1(i)=nan;
            %          tracecoh2(i)=nan;
        end
    else
        tracecoh(i)=nan;
    end
end

CohMat=zeros(size(ic,2),size(traces,2));
for i =1:length(n1); CohMat(n1(i),n2(i))=tracecoh(i); end;
% CohMat(isnan(CohMat))=0;

% Plot
% %% Neuron 1
% h = figure;
% dist=pdist(CohMat');
% tree=linkage(dist,'weighted');
% axes1 = axes('Parent',h,'XAxisLocation','top','Position',[0.403125 0.11 0.503125 0.18253112033195]);
% [H,T,Aperm] = dendrogram(tree,size(CohMat,2),'Orientation','bottom','ColorThreshold', mean(tree(:,3))+2*std(tree(:,3)) );
% %% Neuron 2
% dist=pdist(CohMat);
% tree=linkage(dist,'weighted');
% % subplot(3,4,[1;5])
% axes2 = axes('Parent',h,'YAxisLocation','right','Position',[0.130520833333333 0.33402489626556 0.25125 0.595124481327801]);
% [H,T,Nperm] = dendrogram(tree,size(CohMat,1),'Orientation','left','ColorThreshold', mean(tree(:,3))+2*std(tree(:,3)));
% %% Ajacency Matrix
% 
% axes3 = axes('Parent',h, 'Position',[0.409755434782609 0.332198054700397 0.494202898550724 0.595913978494624],'Layer','top');
% Nperm=Nperm(end:-1:1);
% imagesc(CohMat(Nperm,Aperm));
% set(gca,'YTick',1:length(Nperm),'YTickLabel',Nperm,'XTick',1:length(Aperm),'XTickLabel',Aperm);
end