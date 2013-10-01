function EAfile = EA_EVENTDETECTION(EAfile,varargin)
% 
% AC_SC = unique(EAfile.CLEANDATA.SPIKECHANNEL);
% [AC_SC,first] = unique(EAfile.CLEANDATA.SPIKECHANNEL,'first');
% AC_SC = EAfile.CLEANDATA.SPIKECHANNEL(first);
% AC_N = length(AC_SC);
% single channel event detection
min_SPE   = 1;            % define the minimal number of spikes to be an event
max_ISI   = 100e3;        % maximal Interspike interval to group spikes to events
min_IEI   = 100e3;        % minimal interevent interval, events will otherwise be grouped 
%network event detection onsets
onset_window    = 25e3; % better use 50 or 75ms in some cases
%network event detection offsets
offset_window   = 25e3;
% merge network events that are to close (intervall between offset and onset)
onset_deadtime  = 25e3;
% onset_deadtime  = 2500e3;

% network event definition (minimal number of events)
% min_EPNE  =  ceil(0.5*(sqrt(1e6/((EAfile.INFO.MEA.PITCH)^2))+1)^2);
% min_EPNE  = min(max(3,ceil(AC_N/10)),30);  %number of events
min_EPNE = nan; % is calculated on the basis of number of channels with bursts (eventsize >=3), but can be set here..
% minimal number of spikes per network event
min_SPNE = 1;% is calculated on the basis of number of channels with bursts (eventsize >=3), but can be set here..

PVPMOD(varargin);
 
%sort according to spike channel (since EVENTID will have the same sorting)
[EAfile.CLEANDATA.SPIKECHANNEL,id]=sort(EAfile.CLEANDATA.SPIKECHANNEL);
EAfile.CLEANDATA.SPIKETIME = EAfile.CLEANDATA.SPIKETIME(id);
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
   EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(id);
   EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(id);
end
% if isfield(EAfile.CLEANDATA,'SPIKEWAVES'),
% end


% EAfile.CLEANDATA.SPIKETIME = EAfile.CLEANDATA.SPIKETIME(:);
% EAfile.CLEANDATA.SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(:);
%--------------------------------------------------------------------------
% EVENTDETECTION
%--------------------------------------------------------------------------

[temp2,eventid]=eventdetection_events(EAfile.CLEANDATA.SPIKETIME,'max_ISI',max_ISI,'min_SPE',min_SPE+(min_SPE==1),'min_IEI',min_IEI);    
onsets_id = find(diff([0;eventid])>0);
temp = find(flipud(diff([flipud(eventid)])<0));
offsets_id = sort([find(diff([eventid;0])<0);temp(eventid(temp)>0)]);
EVENTID = eventid; %(eventid>0).*(eventid); 
EVENTTIME = EAfile.CLEANDATA.SPIKETIME(onsets_id);
EVENTCHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(onsets_id);
EVENTSIZE = offsets_id-onsets_id+1;
EVENTDURATION = EAfile.CLEANDATA.SPIKETIME(offsets_id)-EAfile.CLEANDATA.SPIKETIME(onsets_id);

if min_SPE==1, %add single spikes
    ID_singlespikes = find(EVENTID==0);
    [temp,resortID]=sort([EAfile.CLEANDATA.SPIKETIME(EVENTID~=0);EAfile.CLEANDATA.SPIKETIME(EVENTID==0)]); %needed later
    EVENTTIME = [EVENTTIME;EAfile.CLEANDATA.SPIKETIME(ID_singlespikes)];
    EVENTCHANNEL = [EVENTCHANNEL;EAfile.CLEANDATA.SPIKECHANNEL(ID_singlespikes)];
    EVENTSIZE = [EVENTSIZE;ones(size(ID_singlespikes))];
    EVENTDURATION = [EVENTDURATION(:);zeros(size(ID_singlespikes))];
    EVENTID= [EVENTID(EVENTID~=0);cumsum(ones(sum(EVENTID==0),1))+max(EVENTID)];
end

% readdress eventid according to time of appearance (sortid)!!
[temp, sortid] = sort(EVENTTIME);
[a,EVENTID]=ismember(EVENTID,sortid);

% sort EVENTDATA according to eventtimes
[EAfile.EVENTDETECTION.EVENTTIME, sortid] = sort(EVENTTIME); 
EAfile.EVENTDETECTION.EVENTDURATION = EVENTDURATION(sortid);
EAfile.EVENTDETECTION.EVENTSIZE = EVENTSIZE(sortid);
EAfile.EVENTDETECTION.EVENTCHANNEL = EVENTCHANNEL(sortid);   
% EAfile.EVENTDETECTION.EVENTID = 1:length(EVENTTIME); % not really necessary

%sort again according to spike time
EAfile.CLEANDATA.EVENTID = EVENTID(resortID);
[EAfile.CLEANDATA.SPIKETIME,sortid] = sort(EAfile.CLEANDATA.SPIKETIME);
EAfile.CLEANDATA.SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(sortid);
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(sortid);
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(sortid);
end
% help entries
EAfile.EVENTDETECTION.HELP.EVENTTIME        ='event times';
EAfile.EVENTDETECTION.HELP.EVENTCHANNEL     ='event channel';
EAfile.EVENTDETECTION.HELP.EVENTDURATION    ='duration of events in microseconds';
EAfile.EVENTDETECTION.HELP.EVENTSIZE        ='number of spikes in events';
% EAfile.EVENTDETECTION.HELP.EVENTSPIKEID     ='event index';

%--------------------------------------------------------------------------
% NETWORKEVENTDETECTION
%--------------------------------------------------------------------------
% only consider channel with bursts
if isnan(min_EPNE)
    AC_N = length(unique(EAfile.EVENTDETECTION.EVENTCHANNEL(EAfile.EVENTDETECTION.EVENTSIZE>2)));
    min_EPNE  = min(max(3,ceil(AC_N/10)),20)*2;  %number of events
%     min_EPNE  = max(3,ceil(AC_N/10));
    % minimal number of spikes per network event (set to zero)
%     min_SPNE = 6*min_EPNE;
    min_SPNE = min_EPNE;
end


% network event detection on the basis of EVENTTIME
[EAfile.CLEANDATA.NETWORKEVENTID,EAfile.EVENTDETECTION.NETWORKEVENTONSETS,EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS] =  eventdetection_networkevents(EAfile.CLEANDATA.SPIKETIME,EAfile.EVENTDETECTION.EVENTTIME,EAfile.CLEANDATA.EVENTID,'onset_window',onset_window,'offset_window',offset_window,'min_EPNE',min_EPNE,'onset_deadtime',onset_deadtime,'min_SPNE',min_SPNE);

% help help entries
EAfile.EVENTDETECTION.HELP.NETWORKEVENTONSETS   ='network event onset times';
EAfile.EVENTDETECTION.HELP.NETWORKEVENTOFFSETS  ='network event offset times';
EAfile.EVENTDETECTION.HELP.NETWORKEVENTID   ='index that assigns events to network events';
% EAfile.EVENTDETECTION.HELP.NETWORKEVENTSIZE ='size of network events (number of spikes)';
EAfile.CLEANDATA.HELP.EVENTID   ='index that assigns spikes to events (sorted by time of event onset)';
EAfile.CLEANDATA.HELP.NETWORKEVENTID   ='index that assigns spikes to network events (sorted by network onset times)';

% save parameters to settings
EAfile.EVENTDETECTION.SETTINGS.min_SPE   = min_SPE;   
EAfile.EVENTDETECTION.SETTINGS.max_ISI   = max_ISI;   
EAfile.EVENTDETECTION.SETTINGS.min_IEI   = min_IEI;   
EAfile.EVENTDETECTION.SETTINGS.onset_deadtime   = onset_deadtime; 
EAfile.EVENTDETECTION.SETTINGS.min_EPNE  = min_EPNE;  
EAfile.EVENTDETECTION.SETTINGS.onset_window  = onset_window;
EAfile.EVENTDETECTION.SETTINGS.offset_window  = offset_window;
EAfile.EVENTDETECTION.HELP.SETTINGS = 'event detection settings'; 
EAfile.EVENTDETECTION.SETTINGS.HELP.min_SPE    = 'define the minimal number of spikes to be an event';
EAfile.EVENTDETECTION.SETTINGS.HELP.max_ISI    = 'maximal Interspike intervall to group spikes to events';
EAfile.EVENTDETECTION.SETTINGS.HELP.min_IEI    = 'minimal interevent interval, events will otherwise be gouped'; 
EAfile.EVENTDETECTION.SETTINGS.HELP.min_EPNE   = 'minimal number of synchronous events defining a network event';
EAfile.EVENTDETECTION.SETTINGS.HELP.onset_deadtime   = 'minimal interval between two seperate network events (offset to onset)';
EAfile.EVENTDETECTION.SETTINGS.HELP.onset_window   = 'time window for onset detection (~recruitment phase)';
EAfile.EVENTDETECTION.SETTINGS.HELP.offset_window   = 'time window for offset detection (~fading phase)';

 