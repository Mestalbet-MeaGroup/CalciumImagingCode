function [xtextLabels,ytextLabels] = ColorTextLabels(h,colorrange,varargin);
% Function takes axes handle h and colors and replaces figure handle with
% colors. optional: 'x' only colors x tick labels. 'y' only y tick labels.  Function returns handles to text labels

xtextLabels=[]; ytextLabels=[];
cb = colorbar('peer',h,'location','WestOutside');
color = cbrewer('qual','Paired',max(colorrange));
if isempty(varargin)
    y = get(h, 'YLim' );
    xlabels = cellstr(get(h, 'XTickLabel' ));
    xvals = get(h, 'XTick' );
    for ll=1:numel(xvals)
        xtextLabels(ll) = text( ...
            'Units', 'Data', ...
            'Position', [xvals(ll), y(2), 1], ...
            'String', xlabels{ll}, ...
            'Parent', h, ...
            'Clipping', 'off', ...
            'Color', color(colorrange(ll),:), ...
            'UserData', xvals(ll));
        set(xtextLabels(ll), 'HorizontalAlignment','center','VerticalAlignment','top')
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
        set(ytextLabels(ll), 'HorizontalAlignment','right','VerticalAlignment','middle')
    end
    set(h,'YTickLabel',[]);
    freezeColors(h);
    pos = get(h,'Position');
    hc = axes('Position', [pos(1)+pos(3)+0.01,pos(2),pos(3)*.03,pos(4)]);
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
                        'Position', [xvals(ll), y(2), 1], ...
                        'String', xlabels{ll}, ...
                        'Parent', h, ...
                        'Clipping', 'off', ...
                        'Color', color(colorrange(ll),:), ...
                        'UserData', xvals(ll));
                end
                set(xtextLabels(ll), 'HorizontalAlignment','center','VerticalAlignment','top')
                set(h,'XTickLabel',[]);
            end
            set(h,'XTickLabel',[]);
            set(h,'ycolor',[1,1,1]);
            freezeColors(h);
            pos = get(h,'Position');
            hc = axes('Position', [pos(1)+pos(3)+0.01,pos(2),pos(3)*.03,pos(4)]);
            cb1 = colorbar(hc);
            freezeColors;
            colormap(hc,color);
            set(cb,'XTick',[],'YTick',[]);
            ylabel(cb,'Location Clusters','Color',[1,1,1],'FontSize',10);
            set(cb1,'XTick',[],'YTick',[]);
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
            pos = get(h,'Position');
            hc = axes('Position', [pos(1)+pos(3)+0.01,pos(2),pos(3)*.03,pos(4)]);
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