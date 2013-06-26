function [intensitymat, ROIcenters] = CreateTracesFromMaskSeq(mask,directory);
% Calculates the pixel intensity over time of each cell detected in mask.
% Also returns the centroid for each region of interest.
% Written by: Noah Levine-Small
% Revision 1: 03/03/2013
% Revision 2: 10/04/2013 *Caused load of individual frame to conserve
% memory
% info = imfinfo(fname);
% if size(info,1)>1
%     nframes = size(info,1);
% else
%     nframes =  round(info.FileSize/info.StripByteCounts)-6;
% end
info = dir([directory '\' '*.tif']);
meta.height=size(imread([directory '\' info(1).name]),1);
meta.width=size(imread([directory '\' info(1).name]),2);
meta.nframes=size(info,1);
h = waitbarwithtime(0,'Extracting Traces...');
for ii=1:meta.nframes
    temp = regionprops(~mask, imread([directory '\' info(ii).name]), 'MeanIntensity','Centroid');
    for j=1:length(temp)
        intensitymat(j,ii)=temp(j).MeanIntensity;
        ROIcenters(j,:)=temp(j).Centroid;
    end
    waitbarwithtime(ii/meta.nframes,h);
end
close(h);
% imagesc(mask);
% hold on
% for kk = 1:size(ROIcenters,1)
% cc = ROIcenters(kk,:);
% text(cc(1), cc(2),sprintf('%d', kk),'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle','Color',[1 1 1] );
% end
% hold off
end
