function EA_PLOTNEROSEQUENCE(EAfile,varargin)

%
% sorted according to time or classes
%
showMEA = 1;
type = 'chronologic'; %'classes';

PVPMOD(varargin);
switch type
    case 'chronologic'
        [NERO_TIME_SORTED,id] = sort(EAfile.NERO.NERO_TIME); 
    case 'classes'
        [NERO_CLASSES_SORTED,id] = sort(EAfile.NERO.NERO_CLASSID,'descend'); 
end
          
b=EAfile.NERO.NERO_CHANNELMAT(id,:); 
% b(isnan(b))=0;
cm = createcolormap(EAfile.CLEANDATA.CHANNELMAP,'intensity',3,'invert',1);
% cm = createcolormap(EAfile.CLEANDATA.CHANNELMAP,'intensity',1,'invert',0);
% cm = colormap([[1 1 1];flipud(jet(numel(EAfile.CLEANDATA.CHANNELMAP)))]);
figure, 
imagesc_RGB(b,[[0,0,0];cm]); 
% set(gca,'CLIM',[0 numel(EAfile.CLEANDATA.CHANNELMAP)])
axis equal;
axis image;
ylabel('network event id');
xlabel('rank');

if isequal(type,'classes'),
    c = [find(diff([1;NERO_CLASSES_SORTED]));length(EAfile.NERO.NERO_CLASSID)+1];
    hold on;
    for ii=1:(length(c)-1)
        plot([0 numel(EAfile.CLEANDATA.CHANNELMAP)],[c(ii)-0.5,c(ii)-0.5],'w','LineWidth',min(max(1000/length(EAfile.NERO.NERO_TIME),1),3));    
        text(58,c(length(c)-ii),num2str(ii),'Color',[1,1,1],'FontWeight','Bold','FontSize',min(max(5000/length(EAfile.NERO.NERO_TIME),4),20),'VerticalAlignment','top','HorizontalAlignment','right');
    end
    set(gca,'CLIM',[1 numel(EAfile.CLEANDATA.CHANNELMAP)]);
end

set(gcf,'Position',[520 4 560 1121]);
if showMEA
    b=EAfile.CLEANDATA.CHANNELMAP;
    b(ismember(EAfile.CLEANDATA.CHANNELMAP,EAfile.CLEANDATA.REFERENCECHANNEL))=nan;
    figure, imagesc_RGB(b,cm); 
    set(gca,'CLIM',[1 numel(EAfile.CLEANDATA.CHANNELMAP)])
    axis equal;
    axis image;
end
set(gcf,'Position',[945 839 256 274]);
end