function [xtextLabels,ytextLabels] = ColorTextLabels(h,colorrange,varargin);
% Function takes axes handle h and colors and replaces figure handle with
% colors. optional: 'x' only colors x tick labels. 'y' only y tick labels.
% Function returns handles to text labels. Also adds colorbars.

xtextLabels=[]; ytextLabels=[];
vals  = get(get(h,'children'),'CData');
axis image;
pos = get(h,'position');
cb = colorbar('peer',h,'location','WestOutside');
postemp = get(cb,'position');
set(cb,'position',[postemp(1),postemp(2),postemp(3)*0.5,postemp(4)]);

cb1 = colorbar('peer',h,'location','EastOutside');
postemp = get(cb1,'position');
set(cb1,'position',[postemp(1),postemp(2),postemp(3)*0.5,postemp(4)]);
postemp = get(cb1,'position');
cla(cb1);
color = jet(max(colorrange));
% color = cbrewer('qual','Paired',max(colorrange));
if isempty(varargin)
    y = get(h, 'YLim' );
    xlabels = cellstr(get(h, 'XTickLabel' ));
    xvals = get(h, 'XTick' );
    for ll=1:numel(xvals)
        xtextLabels(ll) = text( ...
            'Units', 'Data', ...
            'Position', [xvals(ll), y(2), 1], ...
            'String', {'',xlabels{ll}}, ...
            'Rotation',-30,...
            'Parent', h, ...
            'Clipping', 'off', ...
            'Color', color(colorrange(ll),:), ...
            'UserData', xvals(ll));
        set(xtextLabels(ll), 'HorizontalAlignment','left','VerticalAlignment','top','FontSize',5)
    end
    set(h,'XTickLabel',[]);
    
    x = get(h, 'XLim' );
    ylabels = cellstr(get(h, 'YTickLabel' ));
    yvals = get(h, 'YTick' );
    for ll=1:numel(yvals)
        ytextLabels(ll) = text( ...
            'Units', 'Data', ...
            'Position', [x(1),yvals(ll), 1], ...
            'String', ylabels{ll}, ...
            'Parent', h, ...
            'Clipping', 'off', ...
            'Color', color(colorrange(ll),:), ...
            'UserData', yvals(ll));
        set(ytextLabels(ll), 'HorizontalAlignment','right','VerticalAlignment','middle','FontSize',7);
    end
    set(h,'YTickLabel',[]);
    if numel(xvals)==numel(yvals)
        set(h,'PlotBoxAspectRatio',[1,1,1]);
    end
    freezeColors(h);
    maximize(gcf);
    pos = get(h,'Position');
    hc = axes('Position', [postemp(1),postemp(2),postemp(3),postemp(4)]);
    cb1 = colorbar(hc);
    freezeColors;
    colormap(hc,color);
    set(cb,'XTick',[],'YTick',[]);
    ylabel(cb,'Location Clusters','Color',[1,1,1]);
    set(cb1,'XTick',[],'YTick',[]);
    ylabel(cb1,'Correlation Magnitude','Color',[1,1,1]);
    
else
    switch varargin{1}
        case 'x'
            set(h,'fontsize',5);
            y = get(h, 'YLim' );
            xlabels = cellstr(get(h, 'XTickLabel' ));
            xvals = get(h, 'XTick' );
            for ll=1:numel(xvals)
                if mod(ll,2)==0
                    xtextLabels(ll) = text( ...
                        'Units', 'Data', ...
                        'Position', [xvals(ll), y(2), 1], ...
                        'String', {'',xlabels{ll}}, ...
                        'Parent', h, ...
                        'Clipping', 'off', ...
                        'Color', color(colorrange(ll),:), ...
                        'UserData', xvals(ll));
                else
                    xtextLabels(ll) = text( ...
                        'Units', 'Data', ...
                        'Position', [xvals(ll), y(2)-0.1, 1], ...
                        'String', xlabels{ll}, ...
                        'Parent', h, ...
                        'Clipping', 'off', ...
                        'Color', color(colorrange(ll),:), ...
                        'UserData', xvals(ll));
                end
                set(xtextLabels(ll), 'HorizontalAlignment','center','VerticalAlignment','top','FontSize',7);
                set(h,'XTick',xvals(1:2:end));
                set(h,'XTickLabel',[]);
            end
            set(h,'XTickLabel',[]);
            set(h,'ycolor',[1,1,1],'xcolor',[1,1,1]);
            freezeColors(h);
            maximize(gcf);
            pos = get(h,'Position');
            hc = axes('Position', [postemp(1),postemp(2),postemp(3),postemp(4)]);
            cb1 = colorbar(hc);
            freezeColors;
            colormap(hc,color);
            yticks = get(cb1,'YTick');
            cblabels = linspace(min(vals(:)), max(vals(:)),numel(yticks));
            set(cb1,'YTickLabel',cblabels, 'YColor',[1 1 1],'FontSize',10);
            
            ylabel(cb,'Location Clusters','Color',[1,1,1],'FontSize',10);
            ylabel(cb1,'Correlation Magnitude','Color',[1,1,1],'FontSize',10);
        case 'y'
            x = get(h, 'XLim' );
            ylabels = cellstr(get(h, 'YTickLabel' ));
            yvals = get(h, 'YTick' );
            for ll=1:numel(yvals)
                ytextLabels(ll) = text( ...
                    'Units', 'Data', ...
                    'Position', [x(1),yvals(ll), 1], ...
                    'String', ylabels{ll}, ...
                    'Parent', h, ...
                    'Clipping', 'off', ...
                    'Color', color(colorrange(ll),:), ...
                    'UserData', yvals(ll));
                set(ytextLabels(ll), 'HorizontalAlignment','right','VerticalAlignment','middle')
            end
            set(h,'YTickLabel',[]);
            set(h,'xcolor',[1,1,1]);
            freezeColors(h);
            maximize(gcf);
            pos = get(h,'Position');
            hc = axes('Position', [pos(1)+pos(3)-0.119,pos(2),pos(3)*.03,pos(4)]);
            cb1 = colorbar(hc);
            freezeColors;
            colormap(hc,color);
            set(cb,'XTick',[],'YTick',[]);
            ylabel(cb,'Location Clusters','Color',[1,1,1]);
            set(cb1,'XTick',[],'YTick',[]);
            ylabel(cb1,'Correlation Magnitude','Color',[1,1,1]);
    end
end

set(gcf,'Color',[0,0,0]);

end