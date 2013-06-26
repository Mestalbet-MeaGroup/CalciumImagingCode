function PlotResultsOnMEAcoh(data,ic,FreqCat,cc, centeredchannel,name);
% Function creates 3 plots:
%                   Plot 1: 3D Depiction of relationships between
%                   electrodes and astrocytes in viewframe. The maximum
%                   relationship score for each electrode is plotted along
%                   the Z-axis. Color of relationship scores represents
%                   frequency band (same color = same frequency band) with
%                   whom maximum coherence score was found. Only those
%                   coherence scores that are *Factor* standard deviations above the
%                   mean are plotted.
%                   Plot 2: Ajacency matrix of cross-correlation between
%                   electrodes(subset of electrodes from plot 1). X and Y
%                   axis labels are colored according to astrocytic
%                   partner (same color code as in plot 1).
% Input variables:
%                   data =  matrix of electrodes x astrocytes x freq ban where each
%                           value represents a score for the relationship
%                           calculated (correlation, coincidence, etc)
%                   ic  =   channels recorded for this experiment (order is
%                           the same as in the first dimension of matrix data)
%                   FreqCat = frequency band between which coherence was
%                   integrated over
%                   cc  =   cross correlation between neurons in recording
%                           (for second plot)
%                   centeredchannel =   channel upon which calcium imaging
%                                       viewframe was centered.
%                   name = recording name to save images under
% Revision 1: 09/05/2013
% Written by: Noah Levine-Small

%%
image = [];
load('MeaMapPlot.mat');
[data,ix]=max(data,[],3);
[data,astro]=max(data,[],2);
% MaxFreqPresent = unique(ix(:));
% freq = FreqCat(MaxFreqPresent);
% FreqMat=ix;
freq=ix(astro);
% for i=1:numel(ix); FreqMat(i)=FreqCat(ix(i)); end
% FreqMat=FreqMat(astro);
ind = find(data>mean(data(~isnan(data)))+std(data(~isnan(data))));
factor=1;
while numel(ind)<30
    ind = find(data>mean(data(~isnan(data)))+factor*std(data(~isnan(data))));
    factor=factor-0.1;
end
data = data(ind); freq = freq(ind); ic=ic(1,ind);
display(factor);
%% Create MeaImage
numcol = 256;
test = colormap([jet(numcol*16*16);gray(numcol)]);
CaImage = zeros(size(MeaImage,1),size(MeaImage,2));
loc = find(MeaMap==centeredchannel);
image2 = imresize(image,0.6175);
offsetx = min(xpos);
offsety = min(ypos);
CaImage(floor(xpos(loc)-size(image2,1)/2-offsetx/2):floor(xpos(loc)+size(image2,1)/2-1-offsetx/2),floor(ypos(loc)-size(image2,2)/2+offsety/2):floor(ypos(loc)+size(image2,2)/2-1+offsety/2))=image2;
patch = size(CaImage,1)-size(CaImage,2);
if patch~=0
    MeaImage =  padarray(MeaImage,[patch/2 patch/2],min(MeaImage(:)));
end
RGB = ind2rgb(MeaImage,test(numcol*16*16+1:end,:));
RGB2 = ind2rgb(CaImage,test(1:numcol*16*16,:));
imshow(RGB);
set(gca,'ydir','normal');
hold on; h = imshow(RGB2);
set(h, 'AlphaData', CaImage);
axis('off');
export_fig MergeCaMEA.png -native
close all;
image = imread('MergeCaMEA.png');
image = imresize(image,[size(MeaImage,1) size(MeaImage,2)]);

%% Plot 3D Figure
colorscale = [0 FreqCat(2:end)];
color = jet(numel(colorscale));
max_x = size(MeaImage,1);
max_y = size(MeaImage,2);
scale = 0.96; %pixels/um
[X,Y] = meshgrid(0:1:max_x-1);
Z = zeros(size(X));
mesh(X,Y,Z,'FaceColor','texturemap','CData',double(rgb2ind(image, colormap([jet(65536-numcol);gray(numcol)]))));  
set(gcf,'Renderer','OpenGL');
xlim([0 max_x]);
ylim([0 max_y]);
hold on;
[X,Y,Z] = cylinder(5);
icReordered =[];
paintCounter = [];
for i=1:16*16; 
    if numel(find(ic(1,~isnan(data))==MeaMap(i)))>0
        [~,index]=find(ic(1,:)==MeaMap(i));
        icReordered = [icReordered ic(1,index)];
        score = data(index);
        paint = color(freq(index),:);
        text(xpos(i),ypos(i),score,num2str(MeaMap(i)),'Color',paint);
        surf(X+xpos(i),Y+ypos(i),Z.*score,'FaceColor',paint,'EdgeColor',paint,'FaceAlpha',0.5);
        paintCounter = [paintCounter;paint];
    end
end
set(gca,'XTick',(0:1000:max_x), 'XTickLabel', (0:1000:max_x).*scale);
set(gca,'YTick',(0:1000:max_x), 'YTickLabel', (0:1000:max_x).*scale);

freezeColors;
cb = colorbar;
colormap(color);
for i=1:numel(colorscale)
    labels{i}=num2str(round(colorscale(i)*100)/100);
end
oldCBticks = get(cb,'YTick');
newCBticks = linspace(0,oldCBticks(end),length(labels));
offset = (1:numel(newCBticks)).*42;
set(cb,'YTick',newCBticks-offset,'YTickLabel',labels);
maximize(gcf)
print([name 'cohA2N_MEA3D.png'],'-dpng','-r600');
% export_fig([name 'cohA2N_MEA3D.png'],'-native','-nocrop');
close all;
%% Add neuronal cross correlation
cc = cc(ind,ind);
% ix=ix(astro);
[cc1,vx,~] = DendrogramOrderMatrix2(cc);
elecDisplay=icReordered(vx);
figure; imagesc(cc1);
set(gca,'XTick',1:length(elecDisplay), 'XTickLabel', elecDisplay,...
    'YTick',1:length(elecDisplay), 'YTickLabel', elecDisplay,'PlotBoxAspectRatio',[1 1 1]);
xticks = get(gca,'XTick'); % x tick positions
yticks = get(gca,'YTick');% y tick positions
xlabels = cellstr(get(gca,'XTickLabel')); % get the x tick labels as cell array of strings
set(gca,'XTickLabel',[]) % remove the labels from axes
set(gca,'YTickLabel',[])% remove the labels from axes
yl = 0;
paintCounter = paintCounter(vx,:);
for i=1:length(vx)
    t= text(xticks(i),repmat(yl(1),1,1), xlabels(i), ...
        'HorizontalAlignment','center','VerticalAlignment','top');
    set(t,'FontWeight','bold','Color',paintCounter(i,:),'FontSize',18);
    t = text(repmat(yl(1),1,1),yticks(i), xlabels(i), ...
        'HorizontalAlignment','center','VerticalAlignment','top');
    set(t,'FontWeight','bold','Color',paintCounter(i,:),'FontSize',18);
end
set(gca,'PlotBoxAspectRatio', [1 1 1]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 25 25])
cb = colorbar;
set(cb,'fontsize',18);
print([name 'cohN2N_subsetFrom3Dplot.png'],'-dpng','-r400');
close all;

% set(cb,'fontsize',18);
% print([name 'ccN2N_subsetFrom3Dplot.png'],'-dpng','-r400');
% close all;
%% Find Within Group Correlation, Between Group Correlation
% findgroups = sum(paintCounter,2);
% groups = unique(findgroups);
% pc = paintCounter;
% if numel(unique(ix))~=numel(groups)
%     pc(:,1)=-1*pc(:,1);
%     findgroups = sum(pc,2);
%     groups = unique(findgroups);
% end
% for i=1:numel(groups)
%     indexG=find(findgroups==groups(i));
%     if numel(indexG)>2
%         combs = nchoosek(1:numel(indexG),2);
%         for ii=1:size(combs,1)
%             corr(ii) = cc1(combs(ii,1),combs(ii,2));
%         end
%         MeanCorrWithinG(i)=mean(corr);
%         STDCorrWithinG(i)=std(corr);
%         corr=[];
%     else
%         MeanCorrWithinG(i)=nan;
%         STDCorrWithinG(i)=nan;
%     end
%     ig{i}=indexG;
% end
% 
% str1 = 'betGindex=allcomb(ig{1},';
% str2=[];
% for i=2:size(ig,2)
%     str2 = [str2 ['ig{' num2str(i) '},']];
% end
% str3 = [str1 str2(1:end-1) ');'];
% eval(str3);
% 
% for i=1:size(betGindex,1)
%     corr(i)=cc1(betGindex(i,1),betGindex(i,2));
% end
% MeanCorrBetweenG=mean(corr(~isnan(corr)));
% STDCorrBetweenG=std(corr(~isnan(corr)));
% for i=1:size(ig,2)
%     paintBars(i,:) = paintCounter(ig{i}(1),:);
% end
% 
% h = barwitherr([STDCorrWithinG STDCorrBetweenG],1:numel(unique(ix))+1,[MeanCorrWithinG MeanCorrBetweenG]);
% ch=get(h,'children');
% set(ch,'facevertexcdata',[paintBars;[0 0 0]]);
% for i=1:numel(unique(ix))
%     xtlabel{i} = '';
% end
% xtlabel{i+1} = 'Correlation Between Groups';
% set(gca,'XTick',1:numel(unique(ix))+1,'XTickLabel', xtlabel,'FontSize',18);
% print([name 'N2NgroupCCbarPlot.png'],'-dpng','-r400');
% close all;
% 
% end