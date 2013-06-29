function EAfile = EA_CLEANDATA2(EAfile,varargin)
% settings for lowest activity level per electrode
avg_fr_theta = 0.01; %minimal firing rate based on median firing rate
% settings to remove stimulation artefacts
poststimulus_deadtime = 3e3; %5ms
postswitch_deadtime = 3e3;
% settings to remove synchronous artifact spikes
synch_precision=0.1e3; %precision of spike timing
NCtheta = numel(EAfile.RAWDATA.CHANNELMAP)*0.5; %minimal number of electrodes (usually such artifacts are detected by all electrodes)
STIMCHANNEL = [nan];     % can be used to delete a stimulation channel - don't confuse with stimchannel
% REFERENCECHANNEL = EAfile.RAWDATA.REFERENCECHANNEL;% can be used to delete reference elctrode artifacts
convert_SPIKECHANNEL = 1;
xChannelthreshold = 1;

PVPMOD(varargin);

good_spikes = 1:length(EAfile.RAWDATA.SPIKETIME);
% remove stimulation artefacts first if necessary/possible
delspx = zeros(size(EAfile.RAWDATA.SPIKETIME));
if isfield(EAfile.RAWDATA,'STIMTIME'), %improve code!!!!!
    disp('removing stimulus artifacts');    
    for ii=1:length(EAfile.RAWDATA.STIMTIME),
        temp= EAfile.RAWDATA.SPIKETIME-EAfile.RAWDATA.STIMTIME(ii);
        delspx = delspx+(temp<poststimulus_deadtime).*(temp>0); 
%         delspx = delspx+((temp<(EAfile.RAWDATA.STIMTIME(ii)+poststimulus_deadtime) & (temp>=EAfile.RAWDATA.STIMTIME))); 
    end
    good_spikes = intersect(good_spikes,find(~delspx));
end
% remove artefacts marked during loading files
if isfield(EAfile.RAWDATA,'ARTEFACTID'), %improve code!!!!!
    disp('removing artifacts');    
    delspx = EAfile.RAWDATA.ARTEFACTID>0; 
    good_spikes = intersect(good_spikes,find(~delspx));
end
% % remove artefacts based on minmax ratio
% % minmaxratio = 5;
% if minmaxratio
%     disp('removing artifacts based on min/max ratio');    
%     delspx = abs(EAfile.RAWDATA.SPIKEMINIMA./EAfile.RAWDATA.SPIKEMAXIMA)>minmaxratio; 
%     good_spikes = intersect(good_spikes,find(~delspx));
% end
% remove artefacts from drug application
delspx = zeros(size(EAfile.RAWDATA.SPIKETIME));
if isfield(EAfile.INFO,'ADA'), %improve code!!!!!
    if isfield(EAfile.INFO.ADA,'time')
        disp('removing artifacts from drug application');    
        for ii=1:length(EAfile.INFO.ADA.time),
            delspx = delspx+(EAfile.RAWDATA.SPIKETIME<EAfile.INFO.ADA.deadtime(ii)).*(EAfile.RAWDATA.SPIKETIME>EAfile.INFO.ADA.time(ii)); 
        %         delspx+((temp<(EAfile.RAWDATA.STIMTIME(ii)+poststimulus_deadtime) & (temp>=EAfile.RAWDATA.STIMTIME))); 
        end
    end
    good_spikes = intersect(good_spikes,find(~delspx));
end

% reset spike detection threshold
if (isfield(EAfile.RAWDATA,'SPIKEMINIMA') & xChannelthreshold>1) | isfield(EAfile.INFO,'MERGE');
    disp('reseting spikethresholds');        
    theta_spikes = cleandata_setChannelthreshold(EAfile,'xChannelthreshold',xChannelthreshold);
    good_spikes = intersect(good_spikes,theta_spikes);
end


% delspx = (delspx+ismember(EAfile.RAWDATA.SPIKECHANNEL,STIMCHANNEL))>0;
% still implement: deadtime of particular stimchannel is longer than
% srtefact deadtime



% initialise
EAfile.CLEANDATA.SPIKETIME         = EAfile.RAWDATA.SPIKETIME(good_spikes);
EAfile.CLEANDATA.SPIKECHANNEL      = EAfile.RAWDATA.SPIKECHANNEL(good_spikes);
if isfield(EAfile.RAWDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.RAWDATA.SPIKEMINIMA(good_spikes); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.RAWDATA.SPIKEMAXIMA(good_spikes);
end
EAfile.CLEANDATA.SETTINGS.avg_fr_theta = avg_fr_theta;
EAfile.CLEANDATA.SETTINGS.xChannelthreshold = xChannelthreshold;

EAfile.CLEANDATA.HELP.SPIKETIME   =  'spike time';
EAfile.CLEANDATA.HELP.SPIKECHANNEL = 'spike channel';
EAfile.CLEANDATA.HELP.SETTINGS = 'settings of data cleaning';
EAfile.CLEANDATA.SETTINGS.HELP.avg_fr_theta = 'threshold to keep channels: percentage of average-FR at electrods with spike activity';
EAfile.CLEANDATA.SETTINGS.HELP.xChannelthreshold = 'spike detection thresholds were increased by this factor (discarding small spikes)';

% remove switch artifacts
delspx = zeros(size(EAfile.CLEANDATA.SPIKETIME));
if isfield(EAfile.RAWDATA,'SWITCHTIME'),
    disp('removing switch artifacts');
    EAfile.CLEANDATA.SWITCHTIME = EAfile.RAWDATA.SWITCHTIME;
    for ii=1:length(EAfile.CLEANDATA.SWITCHTIME),
        temp= EAfile.CLEANDATA.SPIKETIME-EAfile.CLEANDATA.SWITCHTIME(ii);
        delspx = delspx+(temp<postswitch_deadtime).*(temp>0);
    end
end
delspx = (delspx+ismember(EAfile.CLEANDATA.SPIKECHANNEL,STIMCHANNEL))>0;
EAfile.CLEANDATA.SPIKETIME         = EAfile.CLEANDATA.SPIKETIME(find(~delspx));
EAfile.CLEANDATA.SPIKECHANNEL      = EAfile.CLEANDATA.SPIKECHANNEL(find(~delspx));
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(find(~delspx)); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(find(~delspx));
end


%----->
%remove synchronous artifacts
disp('removing synchronous artifacts');
ST=round(EAfile.CLEANDATA.SPIKETIME/synch_precision); %synch_precision (2ms) precision spike train
STunique=unique(ST);
[a,pos]=ismember(ST,STunique);
id =find(filter(ones(3,1),1,histc(pos,1:length(STunique)))>NCtheta)-1; % filter: take care of jitter by rounding procedure
AT = STunique(id); %artifact times
% del=[]; 
% for ii = 1:length(AT), 
%     del = [del; find(ST==AT(ii))]; % also discard the neighboring bins?
% end
delspx=ismember(ST,AT);
clear AT ST id a pos STunique
% delspx = zeros(size(EAfile.CLEANDATA.SPIKETIME));
% delspx(del)=1;
EAfile.CLEANDATA.SPIKETIME         = EAfile.CLEANDATA.SPIKETIME(find(~delspx));
EAfile.CLEANDATA.SPIKECHANNEL      = EAfile.CLEANDATA.SPIKECHANNEL(find(~delspx));
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(find(~delspx)); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(find(~delspx));
end
EAfile.CLEANDATA.CHANNELMAP        = EAfile.RAWDATA.CHANNELMAP;
EAfile.CLEANDATA.REFERENCECHANNEL  = EAfile.RAWDATA.REFERENCECHANNEL;
EAfile.CLEANDATA.GROUNDEDCHANNEL  = EAfile.RAWDATA.GROUNDEDCHANNEL;
%convert_SPIKECHANNEL
if convert_SPIKECHANNEL && (isequal(EAfile.INFO.MEA.TYPE,'6x10') || isequal(EAfile.INFO.MEA.TYPE,'8x8')),
    EAfile.CLEANDATA.SPIKECHANNEL = channelnumber_RC8x82SPIKECHANNEL(EAfile.CLEANDATA.SPIKECHANNEL);
    EAfile.CLEANDATA.REFERENCECHANNEL  = channelnumber_RC8x82SPIKECHANNEL(EAfile.CLEANDATA.REFERENCECHANNEL);
    EAfile.CLEANDATA.GROUNDEDCHANNEL  = channelnumber_RC8x82SPIKECHANNEL(EAfile.CLEANDATA.GROUNDEDCHANNEL);    
    disp('Channel IDs converted in CLEANDATA');
    if isequal(EAfile.INFO.MEA.TYPE,'6x10'),
        EAfile.CLEANDATA.CHANNELMAP = channelmap6x10_SPIKECHANNEL;
    elseif isequal(EAfile.INFO.MEA.TYPE,'8x8'),
        EAfile.CLEANDATA.CHANNELMAP = channelmap8x8_SPIKECHANNEL;
    end
end
if convert_SPIKECHANNEL && isequal(EAfile.INFO.MEA.TYPE,'6well'),
    RC = EAfile.RAWDATA.CHANNELMAP;
    chm_lin = channelmap6well_lin; 
    LIN = chm_lin(ismember(channelmap6well_8x8_RC,RC));
    EAfile.CLEANDATA.SPIKECHANNEL = channelnumber_RC8x82SPIKECHANNEL(EAfile.CLEANDATA.SPIKECHANNEL,'RC',RC,'LIN',LIN);
    EAfile.CLEANDATA.REFERENCECHANNEL = [];
    EAfile.CLEANDATA.GROUNDEDCHANNEL  = [];    
    disp('Channel IDs converted in CLEANDATA');
    EAfile.CLEANDATA.CHANNELMAP = chm_lin(:,:,1);
end
% remove electrode below a specified level under the average firing rate
% per electrode
duration = (max(EAfile.CLEANDATA.SPIKETIME)-min(EAfile.CLEANDATA.SPIKETIME))/60e6; % in minutes
% spikes = length(EAfile.CLEANDATA.SPIKETIME);
% fr = spikes/duration; %global firing rate - spike per minute
% avg_fr = fr/length(unique(EAfile.CLEANDATA.SPIKECHANNEL)); %spike per minute of average electrode firing rate
avg_fr = median(histc(EAfile.CLEANDATA.SPIKECHANNEL,unique(EAfile.CLEANDATA.SPIKECHANNEL)))/duration;
min_FR = avg_fr*avg_fr_theta; % 1% of mean firing rate spike per minute
min_SPX =min_FR*duration; % minimal number of spikes to keep electrode (exclude noisy electrodes)
AC_SC = find(histc(EAfile.CLEANDATA.SPIKECHANNEL,1:max(EAfile.CLEANDATA.SPIKECHANNEL))>min_SPX); % throw away channels with less than X spikes
AC_SC = setdiff(AC_SC,unique([EAfile.CLEANDATA.REFERENCECHANNEL,EAfile.CLEANDATA.GROUNDEDCHANNEL])); % reference electrode and grounded electrodes
ID = find(ismember(EAfile.CLEANDATA.SPIKECHANNEL,AC_SC));

disp(['discarding ' num2str(length(EAfile.RAWDATA.SPIKECHANNEL)-length(ID)) ' out of ' num2str(length(EAfile.RAWDATA.SPIKECHANNEL)) 'spikes (~' num2str(100-round(1000*length(ID)/length(EAfile.RAWDATA.SPIKECHANNEL))/10) '%)']);

% write EAfile
EAfile.CLEANDATA.SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(ID);
EAfile.CLEANDATA.SPIKETIME = EAfile.CLEANDATA.SPIKETIME(ID);
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(ID); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(ID);
end
EAfile.CLEANDATA.SETTINGS.poststimulus_deadtime=poststimulus_deadtime;
EAfile.CLEANDATA.SETTINGS.postswitch_deadtime = postswitch_deadtime;
EAfile.CLEANDATA.HELP.poststimulus_deadtime   =  'post stimulus artifact dead time';
EAfile.CLEANDATA.HELP.postswitch_deadtime   =  'post switch artifact dead time';
EAfile.CLEANDATA.HELP.SPIKETIME   =  'spike time';
EAfile.CLEANDATA.HELP.SPIKECHANNEL = 'spike channel';
EAfile.CLEANDATA.HELP.SETTINGS = 'settings of data cleaning';
EAfile.CLEANDATA.SETTINGS.HELP.avg_fr_theta = 'threshold to keep channels: percentage of average-FR at electrods with spike activity';

%sort according to spike channel
[temp,id]=sort(EAfile.CLEANDATA.SPIKECHANNEL);
EAfile.CLEANDATA.SPIKECHANNEL=EAfile.CLEANDATA.SPIKECHANNEL(id);
EAfile.CLEANDATA.SPIKETIME=EAfile.CLEANDATA.SPIKETIME(id);
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(id); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(id);
end
% Transfer applied stimuli to CLEANDATA
if isfield(EAfile.RAWDATA,'STIMTIME'),
    EAfile.CLEANDATA.STIMTIME               = EAfile.RAWDATA.STIMTIME;
    EAfile.CLEANDATA.STIMCHANNEL            = EAfile.RAWDATA.STIMCHANNEL;
    if convert_SPIKECHANNEL && (isequal(EAfile.INFO.MEA.TYPE,'6x10') || isequal(EAfile.INFO.MEA.TYPE,'8x8')),
        EAfile.CLEANDATA.STIMCHANNEL = channelnumber_RC8x82SPIKECHANNEL(EAfile.CLEANDATA.STIMCHANNEL);
    end
    EAfile.CLEANDATA.SETTINGS.STIMAMPLITUDE = EAfile.RAWDATA.SETTINGS.STIMAMPLITUDE;
    EAfile.CLEANDATA.SETTINGS.STIMDURATION    = EAfile.RAWDATA.SETTINGS.STIMDURATION;
    EAfile.CLEANDATA.SETTINGS.NCtheta    = NCtheta;
    EAfile.CLEANDATA.SETTINGS.synch_precision    = synch_precision;    
end
% EAfile = orderfields(EAfile,{'INFO','RAWDATA','CLEANDATA','HELP'});
    
%check format
EAfile.CLEANDATA.SPIKETIME   =  EAfile.CLEANDATA.SPIKETIME(:);
EAfile.CLEANDATA.SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(:);
if isfield(EAfile.CLEANDATA,'SPIKEMINIMA'),
    EAfile.CLEANDATA.SPIKEMINIMA = EAfile.CLEANDATA.SPIKEMINIMA(:); 
    EAfile.CLEANDATA.SPIKEMAXIMA = EAfile.CLEANDATA.SPIKEMAXIMA(:);
end