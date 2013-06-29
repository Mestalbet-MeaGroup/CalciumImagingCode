function EA_PLOTEVENTDETECTION(EAfile,varargin)
%
% EA_PLOTEVENTS(EAfile,varargin)
%
% input
%    EAfile (Burstdetection required)
%
% output
% --
%
% variable input and default values
%    COLORMAP ='jet'; 
%    COLOR_SINGLESPIKE = 0; %% gray scale value
%    COLOR_BACKGROUND   = [1 1 1];
%    newfigure = 1;
%    MarkerSize = 10;
%    max_SPX = 10;
%    limits = [0 inf];
%    COLOR_BG
%    binsize = 10; %sec



M=max(EAfile.CLEANDATA.SPIKECHANNEL)+1;
COLORMAP ='jet';
newfigure = 1;
COLOR_SINGLESPIKE = 0;
MarkerSize = 10;
max_SPX = 25;
% limits = [0 max(EAfile.CLEANDATA.SPIKETIME)/1e6];
limits =EAfile.INFO.FILE.LIMITS/1e6;
% if isfield(EAfile.INFO.FILE,'SETTINGS')
% if isfield(EAfile.INFO.FILE.SETTINGS,'limits')
%     limits = EAfile.INFO.FILE.SETTINGS.limits/1e6;
% end
% end
ylimits = [0 M*1.05];
% COLOR_BACKGROUND   = [0.7 0.7 0.7];
COLOR_BACKGROUND   = [1 1 1];
STIM = 1;
ADA = 1;
Ymax = max(EAfile.CLEANDATA.SPIKECHANNEL);
nblabel = 1;
drawglobalrate = 1;
binsize = 10; %sec
eventlines = 0;

pvpmod(varargin)
% cut data to limits limits 
id = find(EAfile.RAWDATA.SPIKETIME>(limits(1)*1e6) & EAfile.RAWDATA.SPIKETIME<(limits(2)*1e6));
EAfile.RAWDATA.SPIKECHANNEL = EAfile.RAWDATA.SPIKECHANNEL(id); 
EAfile.RAWDATA.SPIKETIME = EAfile.RAWDATA.SPIKETIME(id);

id = find(EAfile.CLEANDATA.SPIKETIME>(limits(1)*1e6) & EAfile.CLEANDATA.SPIKETIME<(limits(2)*1e6));
EAfile.CLEANDATA.SPIKECHANNEL = EAfile.CLEANDATA.SPIKECHANNEL(id);
EAfile.CLEANDATA.SPIKETIME = EAfile.CLEANDATA.SPIKETIME(id);
EAfile.CLEANDATA.EVENTID = EAfile.CLEANDATA.EVENTID(id);
id = find(EAfile.EVENTDETECTION.EVENTTIME>(limits(1)*1e6) & EAfile.EVENTDETECTION.EVENTTIME<(limits(2)*1e6));
EAfile.EVENTDETECTION.EVENTTIME = EAfile.EVENTDETECTION.EVENTTIME(id);
EAfile.EVENTDETECTION.EVENTSIZE = EAfile.EVENTDETECTION.EVENTSIZE(id);
EAfile.EVENTDETECTION.EVENTCHANNEL = EAfile.EVENTDETECTION.EVENTCHANNEL(id);
if STIM & isfield(EAfile.CLEANDATA,'STIMTIME'),
    id = find(EAfile.CLEANDATA.STIMTIME>(limits(1)*1e6) & EAfile.CLEANDATA.STIMTIME<(limits(2)*1e6));
    EAfile.CLEANDATA.STIMTIME = EAfile.CLEANDATA.STIMTIME(id);
    EAfile.CLEANDATA.STIMCHANNEL = EAfile.CLEANDATA.STIMCHANNEL(id);
end
id = find(EAfile.EVENTDETECTION.NETWORKEVENTONSETS>(limits(1)*1e6) & EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS<(limits(2)*1e6));
EAfile.EVENTDETECTION.NETWORKEVENTONSETS  = EAfile.EVENTDETECTION.NETWORKEVENTONSETS(id);
EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS = EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS(id);

% plot all the stuff
EAfile.EVENTDETECTION.EVENTSIZE(EAfile.EVENTDETECTION.EVENTSIZE>max_SPX)=max_SPX;
if newfigure
    fig = figure;
end
hold on;
NC = max(EAfile.EVENTDETECTION.EVENTSIZE);
NAC  =length(unique(EAfile.CLEANDATA.SPIKECHANNEL));
if drawglobalrate
    subplot(20,1,1:3); hold on;
    set(gca,'XTickLabel',[]);  
    bar(limits(1):binsize:limits(2),histc(EAfile.CLEANDATA.SPIKETIME/1e6,limits(1):binsize:limits(2)),'LineWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
    set(gca,'FontSize',10,'FontWeight','Bold','XLim',limits);
    ylabel(['Counts (binsize' num2str(binsize*1e3) 'ms)']);
%     area(limits(1):binsize:limits(2),histc(EAfile.CLEANDATA.SPIKETIME/1e6,limits(1):binsize:limits(2))/(NAC*binsize),'LineWidth',1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
%     set(gca,'FontSize',10,'FontWeight','Bold','XLim',limits);
%     ylabel('global firing rate [Hz]');
%     ylabel(['MFR [Hz] (binsize' num2str(binsize*1e3) 'ms)']);
    set(gca,'TickDir','out');
    subplot(20,1,4:20); hold on;
end
set(gca,'TickDir','out');    
%     set(fig,'Position',[2 664 1464 420]);
if STIM & isfield(EAfile.CLEANDATA,'STIMTIME'), 
    tt=EAfile.CLEANDATA.STIMTIME(:);
    cc=EAfile.CLEANDATA.STIMCHANNEL(:);
    y =[zeros(size(tt));ones(size(tt))*Ymax+1;ones(size(tt))*Ymax+1;zeros(size(tt))];
    x = [tt;tt;tt+EAfile.CLEANDATA.SETTINGS.poststimulus_deadtime;tt+EAfile.CLEANDATA.SETTINGS.poststimulus_deadtime];
    [x,id]=sort(x);
    area(x/1e6,y(id),'EdgeColor',[0.7 0.9 1],'FaceColor',[0.7 0.9 1]);
    plot(tt/1e6,cc,'ro','MarkerSize',5,'MarkerFaceColor',[1 0 0]); % mark Stimulated Electrode
end

networkeventonset = EAfile.EVENTDETECTION.NETWORKEVENTONSETS/1e6;
networkeventoffset = EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS/1e6;
% subveventonsets = EAfile.EVENTDETECTION.NESUBEVENTONSETS/1e6;
[net,sid]=sort([networkeventonset;networkeventonset;networkeventonset]);
% [net1,sid1]=sort([subveventonsets;subveventonsets;subveventonsets]);
[net2,sid2]=sort([networkeventoffset;networkeventoffset;networkeventoffset]);
yp=repmat([0;M;nan],length(networkeventonset),1);
% yp2=repmat([0;M;nan],length(subveventonsets),1);
hold on;
% plot(net1,yp2,'g-','color',[0.4 0.9 0.4]);
% plot(net2,yp,'r-','color',[1 0.8 0.8]);
% plot(net,yp,'g-','color',[0.5 0.9 0.5]);
%
tt2=networkeventonset*1e6;
tt=networkeventoffset*1e6;
y =[zeros(size(tt));ones(size(tt))*Ymax+1;ones(size(tt))*Ymax+1;zeros(size(tt))];
x = [tt2;tt2;tt;tt];
[x,id]=sort(x);
area(x/1e6,y(id),'EdgeColor',[0.7 0.7 0.7],'FaceColor',[0.9 0.9 0.9]);
%
if nblabel
    text(networkeventonset,networkeventonset*0+M*1.025,{1:length(networkeventonset)},'color',[0.2 0.2 0.2],'FontSize',8,'HorizontalAlignment','center');
end

eval(['COL=' COLORMAP '(NC);']);
if COLOR_SINGLESPIKE<1
    COL(1,:)=[1,1,1]*COLOR_SINGLESPIKE;
end
bgspx = true;
if eventlines
    SCs = unique(EAfile.CLEANDATA.SPIKECHANNEL);
    for ss=1:length(SCs)
        SCID= find(EAfile.CLEANDATA.SPIKECHANNEL==SCs(ss));
        [temp, onid]=unique(EAfile.CLEANDATA.EVENTID(SCID),'first');
        [temp, offid]=unique(EAfile.CLEANDATA.EVENTID(SCID),'last');
        Teid = reshape([EAfile.CLEANDATA.SPIKETIME(SCID(onid)),EAfile.CLEANDATA.SPIKETIME(SCID(offid)),nan(size(onid))]',[3*length(onid),1]);
        hold on, plot(Teid/1e6,(~isnan(Teid))*SCs(ss),'k-','Color',[0.5 0.5 0.5]);
    end
    plot(EAfile.CLEANDATA.SPIKETIME/1e6,EAfile.CLEANDATA.SPIKECHANNEL,'.','Color',[0.5 0.5 0.5],'MarkerSize',MarkerSize);    
elseif bgspx
    plot(EAfile.CLEANDATA.SPIKETIME/1e6,EAfile.CLEANDATA.SPIKECHANNEL,'.','Color',[0.7 0.7 0.7],'MarkerSize',MarkerSize);
end

for ii=1:max(EAfile.EVENTDETECTION.EVENTSIZE)
    id = find(EAfile.EVENTDETECTION.EVENTSIZE==ii);
    if ~isempty(id)
        plot(EAfile.EVENTDETECTION.EVENTTIME(id)/1e6,EAfile.EVENTDETECTION.EVENTCHANNEL(id),'.','Color',COL(ii,:),'MarkerSize',MarkerSize,'MarkerEdgeColor',COL(ii,:));
    end
end

if ADA & isfield(EAfile.INFO,'MERGE'), % debug!
    tt=EAfile.INFO.MERGE.rec_start(2:end);
    tt2=EAfile.INFO.MERGE.rec_stop(1:(end-1));
    y =[zeros(size(tt));ones(size(tt))*Ymax+1;ones(size(tt))*Ymax+1;zeros(size(tt))];
    x = [tt2;tt2;tt;tt];
    [x,id]=sort(x);
    area(x/1e6,y(id),'EdgeColor',[0.5 0.5 0.5],'FaceColor',[0.5 0.5 0.5]);
end
if ADA & isfield(EAfile.INFO,'ADA') & isfield(EAfile.INFO.ADA,'time'),
    tt=EAfile.INFO.ADA.time(:);
    if ~isempty(tt),
        tt2 = EAfile.INFO.ADA.deadtime(:);
        y =[zeros(size(tt));ones(size(tt))*Ymax+1;ones(size(tt))*Ymax+1;zeros(size(tt))];
        x = [tt;tt;tt2;tt2];
        [x,id]=sort(x);
        area(x/1e6,y(id),'EdgeColor',[0.9 0.7 0],'FaceColor',[0.9 0.7 0]);
        for ii=1:length(EAfile.INFO.ADA.time), 
            text(EAfile.INFO.ADA.time(ii)/1e6+0.5*(EAfile.INFO.ADA.deadtime(ii)-EAfile.INFO.ADA.time(ii))/1e6,(NAC+2)/2, [EAfile.INFO.ADA.drug{ii} ' '  num2str(EAfile.INFO.ADA.conc(ii)) '\muM'],'FontSize',8,'Color',[1 1 1],'EdgeColor',[0 0 0],'BackgroundColor',[0.9 0.6 0],'HorizontalAlignment','Center','VerticalAlignment','middle','Rotation',90); 
        end
    end
end
        

suptitle(strrep(EAfile.INFO.FILE.NAME,'_','\_'));
set(gca,'clim',[1 NC],'XLim',limits,'Ylim',ylimits,'FontSize',10,'FontWeight','Bold');
set(gca,'TickDir','out')
colormap(COL);
cb = colorbar;
set(get(cb,'YLabel'),'String','# spikes in event','FontSize',12,'FontWeight','Bold');
set(cb,'position',[0.9219 0.0976 0.0182 0.6405]);

ylabel('channel ID','FontSize',12,'FontWeight','Bold');
xlabel('time [s]','FontSize',12,'FontWeight','Bold');
if newfigure
    set(fig,'Position',[2 664 1464 420])
end
set(gca,'COLOR',COLOR_BACKGROUND);
