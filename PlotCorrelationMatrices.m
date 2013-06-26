function PlotCorrelationMatrices(cc,xCCorder,yCCorder,withcb,name);


h = imagescnan(cc(xCCorder,yCCorder),'NanColor',[0.4,0.4,0.4]);
% set(gca,'XTick',1:length(xCCorder), 'XTickLabel', xCCorder,...
%     'YTick',1:length(yCCorder), 'YTickLabel', yCCorder,'PlotBoxAspectRatio',[length(xCCorder) length(yCCorder) 1]);
set(gca,'XTick',[],'XTickLabel',[]) % remove the labels from axes
if length(xCCorder)==length(yCCorder)
    set(gca,'YTick',[],'YTickLabel',[],'PlotBoxAspectRatio',[length(xCCorder) length(yCCorder) 1])% remove the labels from axes
    axis('tight');
else
    set(gca,'YTick',[],'YTickLabel',[],'PlotBoxAspectRatio',[length(xCCorder) length(yCCorder)/2 1])
end
% caxis([0 1]);
if withcb
    cb = colorbar;
    set(cb,'fontsize',18);
end
box off;
title(name);
% print([name 'ccN2N.png'],'-dpng','-r400');



end