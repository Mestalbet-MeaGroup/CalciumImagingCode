function PlotFRs(tWell,icWell);
% Function plots the firing rate of data collected on 9-well 256 MEA.
% Expects to receive the output of OrganizeTICintoWells.m
icBase=icWell(1:5);
icGcamp = icWell(6:end);
tBase = tWell(1:5);
tGcamp = tWell(6:end);

for i=1:size(icGcamp,2)
    
    %% Calculate Firing Rate
    [~,base]=FindNeuronFrequency(tBase{i},icBase{i},1000,1);
    [~,gcamp]=FindNeuronFrequency(tGcamp{i},icGcamp{i},1000,1);
    bases{i}=abs((base-mean(base))./std(base));
    gcamps{i}=abs(gcamp-mean(gcamp))./std(gcamp);
    
    axlimb=max(bases{i});
    axlimg=max(gcamps{i});
    axlim(i)=max([axlimb;axlimg]);
end
    %% Normalize Firing Rates (standard error)
    
for i=1:size(icGcamp,2) 
    %% Calculate Index
    indexB =(1:length(bases{i})).*max(tBase{i})/12000/60/length(bases{i});
    indexG =(1:length(gcamps{i})).*max(tGcamp{i})/12000/60/length(gcamps{i});
    %% Calculate Mean and Standard Deviation of Firing Rates
    meanlinebases=ones(length(indexB),1).*mean(bases{i});
    stdlow_linebases=ones(length(indexB),1).*(mean(bases{i})-std(bases{i}));
    stdhigh_linebases=ones(length(indexB),1).*(mean(bases{i})+std(bases{i}));
    
    meanlinegcamps=ones(length(indexG),1).*mean(gcamps{i});
    stdlow_linegcamps=ones(length(indexG),1).*(mean(gcamps{i})-std(gcamps{i}));
    stdhigh_linegcamps=ones(length(indexG),1).*(mean(gcamps{i})+std(gcamps{i}));
    
    %% Plot Firing Rate and Mean/STD lines
%     axlim = [bases(:);gcamps(:)];
    figure;
    hold on;
    plot(indexB,bases{i});    
    plot(indexB,meanlinebases,'-b','LineWidth',3);
    plot(indexB,stdlow_linebases,'--b','LineWidth',2);
    plot(indexB,stdhigh_linebases,'--b','LineWidth',2);
    ha = patch([indexB fliplr(indexB)], [stdlow_linebases',fliplr(stdhigh_linebases')],'b');
    set(ha,'FaceAlpha',0.2);
    xlim([min(indexB)-1 max(indexB)+1]);
    ylim([0 max(axlim)]);
    xlabel('Time [Min]');
    hold off;
    
    figure;
    hold on;
    plot(indexG,gcamps{i},'r');
    plot(indexG,meanlinegcamps,'-r','LineWidth',3);
    plot(indexG,stdlow_linegcamps,'--r','LineWidth',2);
    plot(indexG,stdhigh_linegcamps,'--r','LineWidth',2);
    hb = patch([indexG fliplr(indexG)], [stdlow_linegcamps',fliplr(stdhigh_linegcamps')],'r');
    set(hb,'FaceAlpha',0.2);
    xlim([min(indexG)-1 max(indexG)+1]);
    ylim([0 max(axlim)]);
    xlabel('Time [Min]');
    hold off;
    
    %     eval(['print(f,' '''-r600''' ',' '''-deps'',''' cultures{i,1} '.eps'');']);
    
end
end