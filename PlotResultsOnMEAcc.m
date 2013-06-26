function PlotResultsOnMEAcc(data,ic,cc,centeredchannel,name);

% Function creates 3 plots:
%                   Plot 1: 3D Depiction of relationships between
%                   electrodes and astrocytes in viewframe. The maximum
%                   relationship score for each electrode is plotted along
%                   the Z-axis. Color of relationship scores represents
%                   astrocytic partner (same color = same partner) with
%                   whom maximum correlation score was found. Only those
%                   correlations that are 1 standard deviation about the
%                   mean are plotted.
%                   Plot 2: Ajacency matrix of cross-correlation between
%                   electrodes(subset of electrodes from plot 1). X and Y
%                   axis labels are colored according to astrocytic
%                   partner (same color code as in plot 1).
%                   Plot 3: Bar chart of mean cross correlation within groups
%                           versus mean cross-correlation between groups
% Input variables:
%                   data =  matrix of electrodes x astrocytes where each
%                           value represents a score for the relationship
%                           calculated (correlation, coincidence, etc)
%                   ic  =   channels recorded for this experiment (order is
%                           the same as in the first dimension of matrix data)
%                   cc  =   cross correlation between neurons in recording
%                           (for second plot)
%                   centeredchannel =   channel upon which calcium imaging
%                                       viewframe was centered.
%                   name = recording name to save images under
% Revision 1: 09/05/2013
% Written by: Noah Levine-Small

%% Load schematic data (limit plot to top relationships)
image = [];
load('MeaMapPlot.mat');
[data,ix]=max(data,[],2);
ind = find(data>mean(data(~isnan(data)))+std(data(~isnan(data))));
factor=1;
while numel(ind)<30
    ind = find(data>mean(data(~isnan(data)))+factor*std(data(~isnan(data))));
    factor=factor-0.1;
end
data = data(ind); ix = ix(ind); ic=ic(1,ind);
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
color =jet(max(ix));
colorscale = 1:max(ix);
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
icReordered = [];
posCounter =[];
astroCounter =[];
paintCounter=[];
for i=1:numel(MeaMap);
    if numel(find(ic==MeaMap(i)))>0
        [~,index]=find(ic==MeaMap(i));
        score = data(index);
        paint = color(colorscale==ix(index),:);
        text(xpos(i),ypos(i),score,num2str(MeaMap(i)),'Color',paint);
        surf(X+xpos(i),Y+ypos(i),Z.*score,'FaceColor',paint,'EdgeColor',paint,'FaceAlpha',0.5);
        icReordered = [icReordered ic(index)];
        posCounter = [posCounter i];
        astroCounter = [astroCounter ix(index)];
        paintCounter = [paintCounter;paint];
    end
end

vec = 0:1:size(MeaImage,1)-1;
vec1 = 0-xpos(loc):max_x-xpos(loc)-1;
vec1=round(vec1);
set(gca,'XTick',vec(2:446:end), 'XTickLabel', round(vec1(2:446:end).*scale));
set(gca,'YTick',vec(2:446:end), 'YTickLabel', round(vec1(2:446:end).*scale));
xlabel('Distance in um from Center of Ca Image');
ylabel('Distance in um from Center of Ca Image');
zlabel('Unbiased Normalized Cross Correlation');
maximize(gcf)
export_fig([name 'ccA2N_MEA3D.png'],'-native','-nocrop');
close all;
%% Add Correlation between electrodes on 3D plot
% numcomb = nchoosek(1:numel(elecCounter),2);
% % hold on;
% for i=1:size(numcomb,1)
%     if astroCounter(numcomb(i,1))==astroCounter(numcomb(i,2))
%         electrode1 = ic(1,elecCounter(numcomb(i,1)));
%         electrode2 = ic(1,elecCounter(numcomb(i,2)));
%         ccbetElecs = cc(elecCounter(numcomb(i,1)),elecCounter(numcomb(i,2)));
%         if ccbetElecs>0.8
%             pos1 = posCounter(numcomb(i,1));
%             pos2 = posCounter(numcomb(i,2));
%             XelecPos1=xpos(pos1);
%             XelecPos2=xpos(pos2);
%             YelecPos1=ypos(pos1);
%             YelecPos2=ypos(pos2);
%             tx = [XelecPos1 XelecPos2 XelecPos2 XelecPos1];
%             ty = [YelecPos1 YelecPos2 YelecPos2 YelecPos1];
%             tz = [0 0 ccbetElecs ccbetElecs];
%             paint = color(colorscale==astroCounter(numcomb(i,1)),:);
%             fill3(tx,ty,tz,paint,'EdgeAlpha', 0.3,'FaceAlpha',0.3);
%         end
%     end
% end

%% Plot Cross-Correlation between Neurons (subset from 3D A2N figure)
cc = cc(ind,ind);
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
for i=1:length(ix)
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
print([name 'ccN2N_subsetFrom3Dplot.png'],'-dpng','-r400');
close all;
%% Find Within Group Correlation, Between Group Correlation
findgroups = sum(paintCounter,2);
groups = unique(findgroups);
pc = paintCounter;
if numel(unique(ix))~=numel(groups)
    pc(:,1)=-1*pc(:,1);
    findgroups = sum(pc,2);
    groups = unique(findgroups);
end
for i=1:numel(groups)
    indexG=find(findgroups==groups(i));
    if numel(indexG)>2
        combs = nchoosek(1:numel(indexG),2);
        for ii=1:size(combs,1)
            corr(ii) = cc1(combs(ii,1),combs(ii,2));
        end
        MeanCorrWithinG(i)=mean(corr);
        STDCorrWithinG(i)=std(corr);
        corr=[];
    else
        MeanCorrWithinG(i)=nan;
        STDCorrWithinG(i)=nan;
    end
    ig{i}=indexG;
end

str1 = 'betGindex=allcomb(ig{1},';
str2=[];
for i=2:size(ig,2)
    str2 = [str2 ['ig{' num2str(i) '},']];
end
str3 = [str1 str2(1:end-1) ');'];
eval(str3);

for i=1:size(betGindex,1)
    corr(i)=cc1(betGindex(i,1),betGindex(i,2));
end
MeanCorrBetweenG=mean(corr(~isnan(corr)));
STDCorrBetweenG=std(corr(~isnan(corr)));
for i=1:size(ig,2)
    paintBars(i,:) = paintCounter(ig{i}(1),:);
end

h = barwitherr([STDCorrWithinG STDCorrBetweenG],1:numel(unique(ix))+1,[MeanCorrWithinG MeanCorrBetweenG]);
ch=get(h,'children');
set(ch,'facevertexcdata',[paintBars;[0 0 0]]);
for i=1:numel(unique(ix))
    xtlabel{i} = '';
end
xtlabel{i+1} = 'Correlation Between Groups';
set(gca,'XTick',1:numel(unique(ix))+1,'XTickLabel', xtlabel,'FontSize',18);
print([name 'N2NgroupCCbarPlot.png'],'-dpng','-r400');
close all;
end
