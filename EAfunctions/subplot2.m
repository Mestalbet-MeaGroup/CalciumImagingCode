function sp=subplot2(r,c,ii,axdist,margin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SYNTAX: subplot2(r,c,ii,axdist,margin) 
%  function uses subplot with additional options:
%  axdist:   set the margins to some relative value between [0 1].
%  margins: set the margins to some relative value between [0 1].
%
%  the intervall [0 1] is subdivided into margin parts and axdist parts and
%  the rest is taken for the axes.
%  (prerequisites 2*margin+(r-1)*axist < 1; 2*margin+(c-1)*axist < 1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
width=(1-(c-1)*axdist-2*margin)/c;
height=(1-(r-1)*axdist-2*margin)/r;
colpos=margin:(width+axdist):(1-margin+axdist);
rowpos=margin:(height+axdist):(1-margin+axdist);
colpos=colpos(1:(end-1));
rowpos=fliplr(rowpos(1:(end-1)));
row=ceil(ii/(c));
col=mod(ii-1,c)+1;
sp=subplot('position',[colpos(col) rowpos(row) width height]);
 