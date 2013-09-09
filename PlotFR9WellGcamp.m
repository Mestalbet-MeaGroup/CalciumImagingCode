function PlotFR9WellGcamp(tWellBase,icWellBase,tWellGcamp,icWellGcamp)
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
tWellBase(5)=[];
icWellBase(5)=[];
interval = 500; %ms
recend = 30*60*1000; %(30 minutes/recording * 60 sec/min *1000 ms/sec)
for i=1:size(icWellBase,2)
    %% Load Select Culture
    tpre=tWellBase{i}; %pre
    icpre=icWellBase{i}; %pre
    if ~isempty(icpre)
        %% Calculate Firing Rate
        %     [~,pre]=FindNeuronFrequency(tpre,icpre,500,1);
        pre = (histc(sort(tpre)./12,0:interval:recend)./1000)./(size(icpre,2));
        %% Setup window
        startpre=1;
        stoppre=length(pre);
        
        %% Normalize Firing Rates (standard error)
        y=pre(startpre:stoppre);
        pres=y.*1000;
        preIndex=(startpre:stoppre).*max(tpre)/12000/60/length(pre);
        
        %     meanlinepres=ones(length(preIndex),1).*mean(pres);
        %     stdlow_linepres=ones(length(preIndex),1).*(mean(pres)-std(pres));
        %     stdhigh_linepres=ones(length(preIndex),1).*(mean(pres)+std(pres));
        
        %% Plot Firing Rate and Mean/STD lines
        subplot(4,2,2*i-1)
        hold on;
        plot(preIndex,pres,'-b');
        if i==5
            ylabel('Spike Rate [Spikes per neuron per second]','FontSize',18);
            
        end
        xlim([0 max(abs(preIndex))]);
        ylim([-1 20]);
        %     plot(preIndex,stdlow_linepres,'--b','LineWidth',2);
        %     plot(preIndex,stdhigh_linepres,'--b','LineWidth',2);
        %     ha = patch([preIndex fliplr(preIndex)], [stdlow_linepres',fliplr(stdhigh_linepres')],'b');
        %     set(ha,'FaceAlpha',0.2);
        hold off
    end
end

for i=1:size(icWellGcamp,2)
    %% Load Select Culture
    tpre=tWellGcamp{i}; %pre
    icpre=icWellGcamp{i}; %pre
    if ~isempty(tpre)
        %% Calculate Firing Rate
        %     [~,pre]=FindNeuronFrequency(tpre,icpre,500,1);
        
        pre = (histc(sort(tpre)./12,0:interval:recend)./1000)./(size(icpre,2));
        %% Setup window
        startpre=1;
        stoppre=length(pre);
        
        %% Normalize Firing Rates (standard error)
        y=pre(startpre:stoppre);
        pres=y.*1000;
        preIndex=(startpre:stoppre).*max(tpre)/12000/60/length(pre);
        
        %     meanlinepres=ones(length(preIndex),1).*mean(pres);
        %     stdlow_linepres=ones(length(preIndex),1).*(mean(pres)-std(pres));
        %     stdhigh_linepres=ones(length(preIndex),1).*(mean(pres)+std(pres));
        %% Plot Firing Rate and Mean/STD lines
        subplot(4,2,2*i)
        hold on;
        plot(preIndex,pres,'-r');
        if i==5
            ylabel('Spike Rate [Spikes per neuron per second]','FontSize',18);
            
        end
        xlim([0 max(abs(preIndex))]);
        ylim([-1 20]);
        %     plot(preIndex,stdlow_linepres,'--r','LineWidth',2);
        %     plot(preIndex,stdhigh_linepres,'--r','LineWidth',2);
        %     ha = patch([preIndex fliplr(preIndex)], [stdlow_linepres',fliplr(stdhigh_linepres')],'r');
        %     set(ha,'FaceAlpha',0.2);
        hold off
    end
end
end