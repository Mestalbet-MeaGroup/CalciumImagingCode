function PlotRasterWithBursts(t,ic,Bind,Bind2,Bind3,Bind4);
% PlotRasterWithBursts(t,ic,Bind);
% Function purpose : Plots Raster plot with Burst index
%
% Function recives :    t [ms] - firing timings
%                       ic - index channel
%                       Bind - Vector of the index of the bursts 
% Function give back :  Plot
%     
% Last updated : 13/11/04

if nargin==3
    PlotRaster4([t Bind],[ic [0;1;(ic(4,end)+1);(length(t)+length(Bind))]]);
end
if nargin==4
    PlotRaster4([t Bind Bind2],[ic [0 0;1 2;(ic(4,end)+1) (length(t)+length(Bind))+1;(length(t)+length(Bind)) (length(t)+length(Bind)+length(Bind2))]]);
end
if nargin==5
    PlotRaster4([t Bind Bind2 Bind3],[ic [0 0 0;1 2 3;(ic(4,end)+1) (length(t)+length(Bind))+1 (length(t)+length(Bind)+length(Bind2))+1;(length(t)+length(Bind)) (length(t)+length(Bind)+length(Bind2)) (length(t)+length(Bind)+length(Bind2)+length(Bind3))]]);
end
if nargin==6
    PlotRaster4([t Bind Bind2 Bind3 Bind4],[ic [0 0 0 0;1 2 3 4;(ic(4,end)+1) (length(t)+length(Bind))+1 (length(t)+length(Bind)+length(Bind2))+1 (length(t)+length(Bind)+length(Bind2)+length(Bind3))+1;(length(t)+length(Bind)) (length(t)+length(Bind)+length(Bind2)) (length(t)+length(Bind)+length(Bind2)+length(Bind3)) (length(t)+length(Bind)+length(Bind2)+length(Bind3)+length(Bind4))]]);
end
