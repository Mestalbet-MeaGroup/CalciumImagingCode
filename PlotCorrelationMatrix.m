function PlotCorrelationMatrix(varargin)
% Function to plot correlation matrix.
% Input Variables:
%       cc - cross-correlation matrix
%       axis1 - y axis electrodes (ic)
%       axis2 - x axis astrocytes (if present, only for astro-neuro cross
%       correlation plots)
if size(varargin,2)>1
    cc = varargin{1};
    axis1 = varargin{2};
    if size(varargin,2)<3
        [cc1,vx,~] = DendrogramOrderMatrix2(cc);
        elecDisplay=axis1(1,vx);
        figure; imagescnan(cc1,'NanColor',[0.4 0.4 0.4]);
        set(gca,'XTick',1:length(elecDisplay), 'XTickLabel', elecDisplay,...
            'YTick',1:length(elecDisplay), 'YTickLabel', elecDisplay,'PlotBoxAspectRatio',[1 1 1]);
        xticks = get(gca,'XTick'); % x tick positions
        yticks = get(gca,'YTick');% y tick positions
        xlabels = cellstr(get(gca,'XTickLabel')); % get the x tick labels as cell array of strings
        set(gca,'XTickLabel',[]) % remove the labels from axes
        set(gca,'YTickLabel',[])% remove the labels from axes
        yl = 0;
        % paintCounter = paintCounter(vx,:);
        for i=1:length(vx)
            t= text(xticks(i),repmat(yl(1),1,1), xlabels(i), ...
                'HorizontalAlignment','center','VerticalAlignment','top');
            set(t,'FontWeight','bold','FontSize',18);
            t = text(repmat(yl(1),1,1),yticks(i), xlabels(i), ...
                'HorizontalAlignment','center','VerticalAlignment','top');
            set(t,'FontWeight','bold','FontSize',18);
        end
        set(gca,'PlotBoxAspectRatio', [1 1 1]);
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 25 25])
        cb = colorbar;
        set(cb,'fontsize',18);
        % print([name 'ccN2N_subsetFrom3Dplot.png'],'-dpng','-r400');
        % close all;
    elseif size(varargin,2)==3
        axis2=varargin{3};
        [cc1,vx,vy] = DendrogramOrderMatrix2(cc);
        elecDisplay=axis1(1,vx);
        astroDisplay=axis2(vy);
        %         h = figure; imagescnan(cc1,'NanColor',[0.4 0.4 0.4]);
        for i=1:numel(elecDisplay); yticklab{i}=num2str(elecDisplay(i)); end
        yticklabodds=yticklab;
        yticklabodds(1:2:end)={' '};
        yticklabevens=yticklab;
        yticklabevens(2:2:end)={' '};
        [ax, h1, h2] = plotyy([],[],[],[], ...
            @(x,y) imagescnan([0 size(cc1,2)],[0 size(cc1,1)],cc1,'NanColor',[0.4 0.4 0.4]), ...
            @(x,y) imagescnan([0 size(cc1,2)],[0 size(cc1,1)],cc1,'NanColor',[0.4 0.4 0.4]));
        ylim(ax(1),[0 size(cc1,1)])
        ylim(ax(2),[0 size(cc1,1)])
        xlim(ax(1),[0 size(cc1,2)])
        xlim(ax(2),[0 size(cc1,2)])
        set(ax(1),'XTick',0:length(astroDisplay), 'XTickLabel', astroDisplay,...
            'YTick',0:length(elecDisplay), 'YTickLabel', yticklabodds);
        set(ax(2),'XTick',[], 'XTickLabel', [],...
            'YTick',0:length(elecDisplay), 'YTickLabel', yticklabevens);
        set(ax(1),'PlotBoxAspectRatio',[numel(astroDisplay) numel(elecDisplay) 1]);
        set(ax(2),'PlotBoxAspectRatio',[numel(astroDisplay) numel(elecDisplay) 1]);
    else
        display('Error: Incorrect Number of Input Arguments');
    end
end
end

