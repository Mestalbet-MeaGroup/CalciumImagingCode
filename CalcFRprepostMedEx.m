function CalcFRprepostMedEx(DataSet)
% Calculates and plots two columns of pre/post 9 well firing rates. Where
% the first column is the change after removing and returning the medium and the second column is after adding Rhod3
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

tPresBase = DataSet{2}.tBase;
icPresBase = DataSet{2}.icBase;
tPresRhod3 = DataSet{2}.tMedEx;
icPresRhod3 = DataSet{2}.icMedEx;

tPostsBase = DataSet{1}.tBase;
icPostsBase = DataSet{1}.icBase;
tPostsRhod3 = DataSet{1}.tMedEx;
icPostsRhod3 = DataSet{1}.icMedEx;


for i=1:size(icPresRhod3,2)
%     if i==3
%         [tPostsBase{3},icPostsBase{3}]  = removeNeuronsWithoutPrompt(tPostsBase{3},icPostsBase{3},[39;1]);
%     end

    tpre=tPresBase{i}; %pre
    icpre=icPresBase{i}; %pre
    tpost=tPostsBase{i}; %post
    icpost=icPostsBase{i}; %post
    subplot(4,2,2*i-1)
    if i==1
        title('Control');
    end
    if (size(icpre,2)>1)&&(size(icpost,2)>1)
        PlotPrePost(tpre,icpre,tpost,icpost);
    end
end

for i=1:size(icPresRhod3,2)
%     if i==4
%         [tPresRhod3{4},icPresRhod3{4}] = removeNeuronsWithoutPrompt(tPresRhod3{4},icPresRhod3{4},[219;1]);
%     end
    tpre=tPresRhod3{i}; %pre
    icpre=icPresRhod3{i}; %pre
    tpost=tPostsRhod3{i}; %post
    icpost=icPostsRhod3{i}; %post
    subplot(4,2,2*i)
    if i==1
        title('Medium Exchanged');
    end
    
    if (size(icpre,2)>1)&&(size(icpost,2)>1)
        PlotPrePost(tpre,icpre,tpost,icpost);
    end
end

    function PlotPrePost(tpre,icpre,tpost,icpost)
        
        %% Calculate Firing Rate
%         [~,pre]=FindNeuronFrequency(tpre,icpre,500,1);
%         [~,post]=FindNeuronFrequency(tpost,icpost,500,1);
        interval = 500; %ms
        recend = 30*60*1000; %(30 minutes/recording * 60 sec/min *1000 ms/sec)
        pre = (histc(sort(tpre)./12,0:interval:recend)./1000)./(size(icpre,2));
        post = (histc(sort(tpost)./12,0:interval:recend)./1000)./(size(icpost,2));
        %% Setup window
        startpre=1;
        stoppre=length(pre);
        startpost=stoppre+1;
        stoppost=startpost+length(post)-1;
        
        %% Normalize Firing Rates (standard error)
        y=pre(startpre:stoppre);
        pres=y.*1000;
        posts=post.*1000;
        
        %% Calculate Index
        postIndex=(startpost:stoppost).*(max(tpre)+max(tpost))/12000/60/length(post);
        preIndex=(startpre:stoppre).*max(tpre)/12000/60/length(pre);
        preIndex=preIndex-postIndex(1);
        preIndex=preIndex+min(abs(preIndex));
        postIndex=postIndex-postIndex(1);
        
        %% Calculate Mean and Standard Deviation of Firing Rates
%         meanlinepres=ones(length(preIndex),1).*mean(pres);
%         stdlow_linepres=ones(length(preIndex),1).*(mean(pres)-std(pres));
%         stdhigh_linepres=ones(length(preIndex),1).*(mean(pres)+std(pres));
%         meanlineposts=ones(length(postIndex),1).*mean(posts);
%         stdlow_lineposts=ones(length(postIndex),1).*(mean(posts)-std(posts));
%         stdhigh_lineposts=ones(length(postIndex),1).*(mean(posts)+std(posts));
        
        
        %% Plot Firing Rate and Mean/STD lines
        hold on;
        plot(preIndex,pres,'-b');
        plot(postIndex,posts,'-r');
        %     if i==7
        %         ylabel('Spike Rate [Spikes per neuron per second]','FontSize',18);
        %     end
        if max(abs(preIndex))>=max(postIndex)
            xlim([-max(postIndex) max(postIndex)]);
        else
            xlim([-1*max(abs(preIndex)) max(abs(preIndex))]);
        end
%         plot(preIndex,stdlow_linepres,'--b','LineWidth',2);
%         plot(preIndex,stdhigh_linepres,'--b','LineWidth',2);
%         ha = patch([preIndex fliplr(preIndex)], [stdlow_linepres',fliplr(stdhigh_linepres')],'b');
%         plot(postIndex,stdlow_lineposts,'--r','LineWidth',2);
%         plot(postIndex,stdhigh_lineposts,'--r','LineWidth',2);
%         hb = patch([postIndex fliplr(postIndex)], [stdlow_lineposts',fliplr(stdhigh_lineposts')],'r');
%         set(ha,'FaceAlpha',0.2);
%         set(hb,'FaceAlpha',0.2);
%         [ymin, ymax]=CalcLimitsWithoutOutliers(pres,posts);
        ylim([-1,max(pres)]);
        %     ratio(i)  = ((numel(tpost)/max(tpost))/(numel(tpre)/max(tpre)));
        hold off
    end

% subplot(3,4,i+1:12)
% bar(ratio);
% lenLine = 0:1:14;
% line(lenLine,ones(length(lenLine)),'LineStyle','-.','Color','r');
% ylabel('Post/Pre number of spikes','FontSize',16);
% xlabel('Cultures','FontSize',16);
% set(gca,'FontSize',16);
% maximize(gcf);
% set(gcf,'color','w');
end

