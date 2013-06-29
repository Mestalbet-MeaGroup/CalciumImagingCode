function NERO_RANKMAT = nerorankmat(NERO_CHANNELMAT)
%
% convert CHANNELMAT into RANKMAT where columns depict CHANNELS and entries
% their respective rank in a particular network event
NERO_RANKMAT = nan(size(NERO_CHANNELMAT));
channels = 1:max(unique(NERO_CHANNELMAT(~isnan(NERO_CHANNELMAT))));
for ii=1:length(channels),
    [R,C,L]=find(NERO_CHANNELMAT==channels(ii));
    L = sub2ind(size(NERO_CHANNELMAT),R,ii*ones(size(R)));
    NERO_RANKMAT(L)=C;
end