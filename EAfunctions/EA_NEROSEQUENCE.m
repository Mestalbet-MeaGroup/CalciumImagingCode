function [EAfile,nero_channelmat,nero_timemat] = EA_NEROSEQUENCE(EAfile,varargin)
% 
%  optional input
%  dev_max = 0.1
%  dev_dir = lower (default), symmetrical
% alle Networks events smaller than median network event size minus dev_max
% time median network event size are discarded (0 = all smaller than median
% network event size, 1 = take all)
%
dev_max=1; %0.1
dev_dir = 'lower';
pvpmod(varargin)

[SPIKETIME,id] = sort(EAfile.CLEANDATA.SPIKETIME);
SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(id);
NETWORKEVENTID = EAfile.CLEANDATA.NETWORKEVENTID(id);
N_NE = max(NETWORKEVENTID);

nero_time       = nan(N_NE,1);
nero_timemat    = nan(N_NE,numel(EAfile.CLEANDATA.CHANNELMAP));
nero_channelmat = nan(N_NE,numel(EAfile.CLEANDATA.CHANNELMAP));
nero_sizemat    = nan(N_NE,numel(EAfile.CLEANDATA.CHANNELMAP));
for ii=1:N_NE
    neid=find(NETWORKEVENTID==ii); 
    nero_channels = unique(EAfile.CLEANDATA.CHANNELMAP);
    nero_channels = nero_channels(~isnan(nero_channels));
    nero_size = histc(SPIKECHANNEL(neid),nero_channels);
    active = find(nero_size>0);
    nero_channels = nero_channels(active);
    nero_size     = nero_size(active);    
    [temp,id]=unique(SPIKECHANNEL(neid),'first');
    id = sort(id);
    neroid = neid(id);
    nero_time(ii) = SPIKETIME(neroid(1));
    nero_timemat(ii,1:length(neroid)) = SPIKETIME(neroid)-SPIKETIME(neroid(1));
    nero_channelmat(ii,1:length(neroid))= SPIKECHANNEL(neroid);
    [temp,id] = ismember(SPIKECHANNEL(neroid),nero_channels);
    nero_sizemat(ii,1:length(neroid))= nero_size(id);
end    
EAfile.NERO.NERO_TIME       = nero_time;
EAfile.NERO.NERO_TIMEMAT    = nero_timemat;
EAfile.NERO.NERO_CHANNELMAT = nero_channelmat;
EAfile.NERO.NERO_SIZEMAT    = nero_sizemat;

% discard network events in with small channel participation
NERO_SIZE = sum(~isnan(EAfile.NERO.NERO_CHANNELMAT),2);
cds = zeros(max(NERO_SIZE),1);
for ii = 1:max(NERO_SIZE), 
    cds(ii) = median(NERO_SIZE(NERO_SIZE>=ii)); 
end; 
NES = median(cds);
selection = find(NERO_SIZE>= floor(NES-NES*dev_max));
if isequal(dev_dir,'symmetrical')
    max_NES = ceil(NES+NES*dev_max);
    selection = find(NERO_SIZE>= min_NES & NERO_SIZE<=max_NES);
end

EAfile.NERO.NERO_TIME        = EAfile.NERO.NERO_TIME(selection);
EAfile.NERO.NERO_CHANNELMAT  = single(EAfile.NERO.NERO_CHANNELMAT(selection,:));
EAfile.NERO.NERO_TIMEMAT     = EAfile.NERO.NERO_TIMEMAT(selection,:);
EAfile.NERO.NERO_SIZEMAT     = EAfile.NERO.NERO_SIZEMAT(selection,:);
EAfile.NERO.SETTINGS.dev_max = dev_max;
EAfile.NERO.SETTINGS.dev_dir = dev_dir; 

EAfile.NERO.NERO_TIMEMAT(EAfile.NERO.NERO_CHANNELMAT==0)=nan;
EAfile.NERO.NERO_CHANNELMAT(EAfile.NERO.NERO_CHANNELMAT==0)=nan;
EAfile.NERO.NERO_SIZEMAT(EAfile.NERO.NERO_CHANNELMAT==0)=nan;

EAfile.HELP.NERO  ='network event rank order analysis;'; 
EAfile.NERO.HELP.NERO_TIME       ='network event times';
EAfile.NERO.HELP.NERO_CHANNELMAT ='network event channel matrix; row = networkeventid, col=rank in networkevent';
EAfile.NERO.HELP.NERO_TIMEMAT    ='network event time matrix (microseconds);    row = networkeventid, col=rank in networkevent';
EAfile.NERO.HELP.NERO_SIZEMAT    ='network event size matrix (# spikes detected by electrode specified at same position in CHANNELMAT in a network event);    row = networkeventid, col=rank in networkevent';
EAfile.NERO.HELP.SETTINGS        = 'settings of network event rank order analysis;'; 
EAfile.NERO.SETTINGS.HELP.dev_max = 'maximal deviation percentage from median number of electrodes in network events allowed';
EAfile.NERO.SETTINGS.HELP.dev_dir = 'lower: deviation towards lower numbers of electrodes restricted (default), symmetrical: in both direction';