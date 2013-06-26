function [CohMat,FreqCat]=CalculateA2Nci(t,ic,traces)
% Calculates Coherence between astrocyte trace and detected spikes
% t  = spike times in sample number, ordered by channel
% ic = index channel
% time - time each flouresnce measurement was taken (generally not used)
% traces - average pixel intensity for each frame for each region of
% interest
% CohMat = integral of the coherence across all frequencies for significant
% coherence results between each electrode and astrocyte trace. For each
% frame (3rd dimension), corresponding to frequency range defined by
% FreqCat
% Written by: Noah Levine-Small
% Revision 1: 30/04/2013
% Revision 2: 11/05/2013 *Revised to include frequency information

choices = allcomb(1:size(ic,2),1:size(traces,2));
n1=choices(:,1);
n2=choices(:,2);

spikes=cell(numel(n1),1);
trace=cell(numel(n2),1);
for i=1:numel(n1)
    spikes{i} = t(ic(3,n1(i)):ic(4,n1(i)))./12000;
    trace{i} = traces(:,n2(i));
end

for i=1:numel(n1)
    [freq,~,~,~,coh,s,~,~,~]=coherence2(trace{i},spikes{i},-1,14.6,1);
    
    if i==1
        FreqCat = quantile(freq,15);
        FreqCat=FreqCat(FreqCat>1);
        FreqCat=FreqCat(FreqCat<=6);
        CohMat=zeros(size(ic,2),size(traces,2),length(FreqCat));
    end
    
    if numel(find(coh(freq>1&freq<6)>s(freq>1&freq<6)))
        
        for ii=1:length(FreqCat)-1
            start=find(freq>=FreqCat(ii),1,'First');
            stop=find(freq<=FreqCat(ii+1),1,'Last');
            CohMat(n1(i),n2(i),ii)=trapz(coh(start:stop));
        end
    else
        CohMat(n1(i),n2(i),:)=nan;
    end
end

% Plot
% %% Astrocyte
% h = figure;
% dist=pdist(CohMat');
% tree=linkage(dist,'weighted');
% axes1 = axes('Parent',h,'XAxisLocation','top','Position',[0.403125 0.11 0.503125 0.18253112033195]);
% [H,T,Aperm] = dendrogram(tree,size(CohMat,2),'Orientation','bottom','ColorThreshold', mean(tree(:,3))+2*std(tree(:,3)) );
% %% Neuron
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