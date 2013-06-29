function channelmap_colormap=createcolormap(channelmap,varargin)
% creates a colormap for a apeciefied channelmap
% that reflect the SOURCECHANNELNUMBERs
%
% MEA:
%      9    17    25    33    41    49
%     19    28    27    35    36    43
%      2    18    26    34    42    58
%      3    11    10    50    51    59
%      4    12    20    44    52    60
%     61    13    21    45    53    61
%      6    14    15    55    54    62
%      7    23    31    39    47    63
%     22    29    30    38    37    46
%     16    24    32    40    48    56
%
% you can use colormap6x10_ch8x8_60 to create a colormap this MEA matrix 
%
% The color intensity can be set with the argument 'intensity' in the
% variable arguments list (negative values: increase light intensity,
% positive values: decrease light intensity)
%
% see also,
% colormap8x8_64,colormap8x8_60,colormap6x10_60,channelmap8x8_64,channelmap8x8_60,
% channelmap6x10_60colormap6x10_60,colormap6x10_ch8x8_60,channelmap6x10_ch8x8_60
intensity=1;
invert =0;
N = length(unique(find(~isnan(channelmap))));

pvpmod(varargin);

% pvpmod(varargin);
channelmap_colormap  = zeros(N,3);
% chm=channelmap6x10_HC;
% channelmap6x10_60= zeros(10,6);
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