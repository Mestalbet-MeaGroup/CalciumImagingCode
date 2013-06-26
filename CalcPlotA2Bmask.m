function CalcPlotA2Bmask(mask,Corr,astroidx)
% Calculates and plots the ratio of correlation to burst types on the mask
% of astrocyte ROIs. Uses the ratio of correlations to color ROIs. 
% Revision 1: 29/05/13
% Written by: Noah Levine-Small

%% CMYK Colors
cyan = [0 255 255] ./255;
magenta = [255 0 255]./255;
yellow = [255 255 0] ./255;
black = [0 0 0];
cmyk = [cyan;magenta;yellow;black];
if max(size(Corr,1)<4)
    for i=1:max(clusterInds)
        colors(i,:) = cmyk(i,:);
    end
else
    colors=cmyk;
end
%% Initialize variables
coloredMask1 = zeros(size(mask,1),size(mask,2)); %Ones for white background, zeros for black background
coloredMask2=coloredMask1;
coloredMask3=coloredMask1;
Corr(isnan(Corr))=0;
%% Find ROIs
cells = regionprops(~mask,'PixelIdxList');
cells=cells(astroidx);

%% Calculate color for each ROI as ratio of the correlations
for i=1:size(cells,1)
    colorscore=zeros(1,3);
    if sum(Corr(:,i))>0
        for j=1:size(Corr,1);          
            %     eval(['c' num2str(j) ' = Corr(' num2str(j) ', num2str(i) ')/sum(Corr(' num2str(j) ',:));']);
            colorscore = colorscore + colors(j,:).* (abs(Corr(j,i))/sum(abs(Corr(:,i))));
        end
    else
        colorscore=zeros(1,3);
    end
    
    coloredMask1(cells(i).PixelIdxList) = colorscore(1);
    coloredMask2(cells(i).PixelIdxList) = colorscore(2);
    coloredMask3(cells(i).PixelIdxList) = colorscore(3);
end
coloredMask(:,:,1)=coloredMask1;coloredMask(:,:,2)=coloredMask2;coloredMask(:,:,3)=coloredMask3; % Create an RGB mask
imshow(coloredMask);  %Plot mask
end


