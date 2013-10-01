function channelmap_colormap=createcolormap(channelmap,varargin)
% creates a colormap for a apeciefied channelmap
% that reflect the SOURCECHANNELNUMBERs
% The color intensity can be set with the argument 'intensity' in the
% variable arguments list (negative values: increase light intensity,
% positive values: decrease light intensity)
intensity=1;
invert =0;
N = length(unique(find(~isnan(channelmap))));
PVPMOD(varargin);
channelmap_colormap  = zeros(N,3);
del=0;
for ii=1:N,
     [r,c]=find(channelmap==ii);
     if ~isempty(r)
         channelmap_colormap(ii,:) = colorcircle(r,c,size(channelmap,1),size(channelmap,2),'intensity',intensity,'invert',invert); 
     else
         del=del+1;
     end
end
channelmap_colormap = [channelmap_colormap;~invert*ones(1,3)]; 
end