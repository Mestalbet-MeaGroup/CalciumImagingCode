function PlotResultsOnMEAbursts(data,ic,centeredchannel,name);
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
% [data,ix]=max(data,[],3);
[top1,ix1]=max(data,[],2);
for i=1:numel(ix1); data(i,ix1(i))=0; end
[top2,ix2]=max(data,[],2);
for i=1:numel(ix2); data(i,ix2(i))=0; end
[top3,ix3]=max(data,[],2);

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
color =jet(max([ix1;ix2;ix3]));
colorscale = 1:max([ix1;ix2;ix3]);
max_x = size(MeaImage,1);
max_y = size(MeaImage,2);
scale = 0.96; %pix1els/um
[X,Y] = meshgrid(0:1:max_x-1);
Z = zeros(size(X));
mesh(X,Y,Z,'FaceColor','texturemap','CData',double(rgb2ind(image, colormap([jet(65536-numcol);gray(numcol)]))));
set(gcf,'Renderer','OpenGL');
xlim([0 max_x]);
ylim([0 max_y]);
factor=100;
hold on;
[X,Y,Z] = cylinder(5);
for i=1:numel(ic);
        index=find(ic(i)==MeaMap);
        score1 = top1(i);
        paint1 = color(colorscale==ix1(i),:);
        text(xpos(index),ypos(index),score1,num2str(MeaMap(index)),'Color',paint1);
        surf(X+xpos(index),Y+ypos(index),Z.*score1,'FaceColor',paint1,'EdgeColor',paint1,'FaceAlpha',0.25);

        score2 = top2(i);
        paint2 = color(colorscale==ix2(i),:);
        text(xpos(index)+factor,ypos(index)+factor,score2,num2str(MeaMap(index)),'Color',paint2);
        surf(X+xpos(index)+factor,Y+ypos(index)+factor,Z.*score2,'FaceColor',paint2,'EdgeColor',paint2,'FaceAlpha',0.35);
        
        score3 = top3(i);
        paint3 = color(colorscale==ix3(i),:);
        text(xpos(index)-factor,ypos(index)-factor,score3,num2str(MeaMap(index)),'Color',paint3);
        surf(X+xpos(index)-factor,Y+ypos(index)-factor,Z.*score3,'FaceColor',paint3,'EdgeColor',paint3,'FaceAlpha',0.5);
end


% end

vec = 0:1:size(MeaImage,1)-1;
vec1 = 0-xpos(loc):max_x-xpos(loc)-1;
vec1=round(vec1);
set(gca,'XTick',vec(2:446:end), 'XTickLabel', round(vec1(2:446:end).*scale));
set(gca,'YTick',vec(2:446:end), 'YTickLabel', round(vec1(2:446:end).*scale));
xlabel('Distance in um from Center of Ca Image');
ylabel('Distance in um from Center of Ca Image');
zlabel('Unbiased Normalized Cross Correlation');
maximize(gcf)
export_fig([name 'A2bursts_MEA3D.png'],'-native','-nocrop');
close all;
end