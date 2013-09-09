function [bs,be,SpikeOrder,varargout]=CalcBurstsSamora(t,ic,varargin);

% Function to detect burst onset, offset and order of channels in bursts using Samora's method.
% Alogrithm:
% Search out highly active channels and remove for burst detection
% Combine bursts of spikes on a single channel into single long duration events
% Check Overlap of events across multiple channels
% When sufficient channels have overlapping event, classify burst
% Find event with 1st spike in burst
% Search for 25ms prior to 1st spike in burst to detect preceding spikes
% that didn't make into event.
%
% Returns:
% BS = burst starts (in sample number)
% BE = Burst end (in sample number)
% SpikeOrder = matrix of burst number x channel number
% Written by Noah Levine-Small using Samora Okujeni's functions.
% 23/10/2012.

varargout{1}=[];
%% Remove HA Channels
% [Firings,~]=FindNeuronFrequency(t,ic,25,1);
% % Create Matrix of Firing rates (spikes/sec) per recorded channel using 10 msec windows.
% frs=mean(Firings,2);
% thr = mean(frs)+std(frs);
% test=frs>=thr;
% a=find(test==1);
% if ~isempty(a)
%     removeme=ic(1,a);
% end
% for i=1:numel(removeme)
%     [t,ic]=removeNeuronsWithoutPrompt(t,ic,[removeme(i);1]);
% end

ic = ConvertIC2Samora(ic);
%% Setup Samora data structure for Samora's functions
load('16x16MeaMap_90CW_Inverted.mat');
EAfile.INFO.MEA.TYPE = '16x16';
EAfile.RAWDATA.CHANNELMAP = MeaMap; % or your channelmap variable
EAfile.RAWDATA.SPIKETIME = t/12*1000; %Spikes in Microscecond
EAfile.RAWDATA.SPIKECHANNEL = ic;
EAfile.RAWDATA.GROUNDEDCHANNEL = [];
EAfile.RAWDATA.REFERENCECHANNEL = [];
EAfile.INFO.FILE.LIMITS=[0,9.843999995291233e+09];
clear t; clear ic;
clear vec; clear MeaMap;
EAfile = EA_CLEANDATA2(EAfile); %Remove artifacts and detect events
%To maintain all spikes un-comment:
% EAfile = EA_CLEANDATA2(EAfile,'avg_fr_theta',0,'synch_precision',1e-12);

%% Run Samora burst detection
EAfile = EA_EVENTDETECTION(EAfile,'min_EPNE',10);
bs=EAfile.EVENTDETECTION.NETWORKEVENTONSETS;
be=EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS;

bs=(bs./1000)'.*12; % Convert from microsecond to sample number (12khZ)
be=(be./1000)'.*12;
bs=bs-30*12;
be=be+30*12;

%% Determine network event rank order (NERO) sequences:
EAfile = EA_NEROSEQUENCE(EAfile);
SpikeOrder=EAfile.NERO.NERO_CHANNELMAT;

%% Find which burst initiates superbursts
% if numel(varargin)==2
%     
%     load('c:\FirstGliaArticle_Data\Optogenetic Recordings\MergedSuperBurstingData2_correctedCHid.mat',['SBS' varargin{1} varargin{2}]);
%     SBS=SBS3620post;
%     
%     for i=1:numel(SBS)
%         tmp = abs(bs - SBS(i));
%         [idx idx] = min(tmp);
%         varargout{1}(i)=idx(1); %Returns the ID for the burst which initiates the superburst
%     end
%     
% end
% EAfile.NERO.NERO_CHANNELMAT=SpikeOrder(SB_iBurstNumber,:); %Uncomment to
% plot patterns for superbursts only
%% Optional Samora functions
% % view result:
% EA_PLOTEVENTDETECTION(EAfile);
% % calculate NERO similarities by correlation of the rank matrix:
% EAfile = EA_NEROSIMILARITY(EAfile);
%
% % determine NERO motifs by clustering manually
% EAfile = EA_NEROCLUSTER(EAfile);
% 
%% View Burst Propogation:
EA_PLOTNEROPATTERNS_RGB(EAfile,'mode','showall'); % or mode: 'motifs'

end
