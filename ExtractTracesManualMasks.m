function [intensitymat, ROIcenters, directory,mask] = ExtractTracesManualMasks();
% Function which extracts the mean pixel intensity per frame of a calcium
% imaging stack using the masks generated manually by selecting regions of interest in ImageJ.
% Written By: Noah Levine-Small
% Revision 1: 28/04/2013
directory = uigetdir(); % Select directory containing image stack 
pos= strfind(directory, '\');
pos = pos(end);
mask = imread(['E:\CalciumImagingArticleDataSet\Mask Files\Manual\' directory(pos+1:end) 'Mask.tif']);
mask = mask >0;
[intensitymat, ROIcenters] = CreateTracesFromMaskSeq(mask,directory);
% save(['H:\CalciumImagingArticleDataSet\Mat Files\OpticalData\' directory(pos+1:end) '_TracesManual.mat']);
end