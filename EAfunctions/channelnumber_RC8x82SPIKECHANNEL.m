function SPIKECHANNEL = channelnumber_RC8x82SPIKECHANNEL(SPIKECHANNEL,varargin)
%convert from RC to LIN index (gilt nur fuer MEAs mit 60 electroden)
RC  = channelmap8x8_RC; 
LIN = channelmap8x8_SPIKECHANNEL; 
pvpmod(varargin);
[temp,id]=ismember(SPIKECHANNEL,RC); 
SPIKECHANNEL = LIN(id); 