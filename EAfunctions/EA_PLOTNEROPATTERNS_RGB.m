function  EA_PLOTNEROPATTERNS_RGB(EAfile,varargin)
%
%
%
%
%
colmap = 'jet';
mode = 'classes'; % showall
biggest = 0;
plot_origin = 0;
lines = 1;
intensity = 3;
invert = 1;
noentry = 1;
NE_range = 1:size(EAfile.NERO.NERO_CHANNELMAT,1);
sequence_plot = 0;
limit = 2000e3;
notitle=1;
chm = EAfile.CLEANDATA.CHANNELMAP;
% chm(chm==1025)=nan;
pvpmod(varargin);
Nel = numel(find(EAfile.CLEANDATA.CHANNELMAP));
chm = EAfile.CLEANDATA.CHANNELMAP;
cm = createcolormap(chm,'intensity',intensity,'invert',invert,'N',Nel+1);
% if ~isfield(EAfile.NERO,'NERO_CLASSID')
%     EAfile.NERO.NERO_CLASSID=1:length(EAfile.NERO.NERO_TIME);
% end
NERO_CHANNELMAT = EAfile.NERO.NERO_CHANNELMAT(NE_range,:);
NERO_CHANNELMAT(EAfile.NERO.NERO_TIMEMAT(NE_range,:)>limit)=nan;
% NERO_CHANNELMAT(isnan(NERO_CHANNELMAT))=Nan;
if biggest,
    mode = 'showbiggest';
end    
if isequal(mode,'classes')
    CLASSID = EAfile.NERO.NERO_CLASSID(NE_range);
elseif isequal(mode,'showall')
    CLASSID = 1:length(NE_range);
elseif isequal(mode,'showall_sortclasses')
     [temp, id] = sort(EAfile.NERO.NERO_CLASSID(NE_range));
     NERO_CHANNELMAT = EAfile.NERO.NERO_CHANNELMAT(NE_range(id),:);
    CLASSID = 1:length(NE_range);
elseif isequal(mode,'showbiggest')
    CLASSID = EAfile.NERO.NERO_CLASSID(NE_range);    
    NEid = 1:max(EAfile.NERO.NERO_CLASSID);
    NEcts = histc(EAfile.NERO.NERO_CLASSID,NEid);
    [NEcts,id] = sort(NEcts,'descend');
    [temp,EAfile.NERO.NERO_CLASSID] = ismember(EAfile.NERO.NERO_CLASSID,id);
    if (biggest<=1)& (biggest>0)
        N=ceil(max(max(CLASSID),biggest)*biggest);
    else % take first
        N=min(max(CLASSID),biggest);
    end
    CLASSID(CLASSID>N)= N+1;
end
 
[temp,ID] = sort(CLASSID,'descend');
% chm = EAfile.INFO.MEA.CHANNELMAP;
% chm(chm==1025)=nan;
% cm = createcolormap2(chm,'intensity',intensity,'invert',invert);
% % cm = createcolormap2(chm,'intensity',1,'invert',0);
% figure, imagesc(NERO_CHANNELMAT(ID,:)),colormap(cm);
if sequence_plot
    figure,  
    temp = NERO_CHANNELMAT;
    temp(isnan(temp)) = Nel+1;
    imagesc_RGB(temp(ID,:),colormap(cm),'noentry',noentry);

    % if isequal(EAfile.INFO.MEA.TYPE,'8x8'),
    %     cm = colormap8x8_60	;
    % elseif isequal(EAfile.INFO.MEA.TYPE,'6x10'),
    %     cm = colormap6x10_ch8x8_60;
    % elseif isequal(EAfile.INFO.MEA.TYPE,'KMEA'),
    %     cm = colormap_KMEA;
    % end
    if lines,
        c = [find(diff([1;temp(:)]));length(CLASSID)+1];
        hold on;
        for ii=2:(length(c))
            plot([0 Nel],[c(ii)-0.5,c(ii)-0.5],'w','LineWidth',1);    
            text((numel(chm)*0.97),c(length(c)-ii+1),num2str(ii-1),'Color',[1,1,1],'FontWeight','Bold','FontSize',8,'VerticalAlignment','bottom');
        end
    end
    % set(gca,'CLIM',[1 Nel-1)]);
    set(gcf,'Position',[520 4 560 1121]);
    set(gca,'YDir','normal');
end
%
f_min = 0.0;
clfreq=[];
NCL = length(unique(CLASSID));
if biggest>1
    NCL=min(NCL,biggest);
end
NERO_CLASSMOTIFS = ones(NCL,(Nel-1))*Nel;
for ii=1:NCL
    temp = nan((Nel-1),1);
    NERO_SINGLE_CLASS = NERO_CHANNELMAT(CLASSID==ii,:); % select all bursts of one cluster
    f = histc(NERO_SINGLE_CLASS(NERO_SINGLE_CLASS<=Nel),1:(Nel-1));
    cl = 1:(Nel-1);
    cl=cl(f>=(size(NERO_SINGLE_CLASS,1)*f_min));
    clfreq(ii,:) = f/size(NERO_SINGLE_CLASS,1); %#ok<AGROW> %% frequency is coded in intensity
    % most frequent order within the cluster
    for jj=1:length(cl);
        [r,c]=find(NERO_SINGLE_CLASS==cl(jj));
        temp(cl(jj)) = ceil(median(c));
    end
    [a,temp]=sort(temp);    
    temp(isnan(a))=Nel;
    NERO_CLASSMOTIFS(ii,:) = temp;
end
if sequence_plot
    figure,

    imagesc_RGB(EAfile.CLEANDATA.CHANNELMAP,cm,'noentry',noentry);
    axis equal; axis image;
end
% figure, imagesc(NERO_CLASSMOTIFS),colormap(cm);
% figure, imagesc_RGB(NERO_CLASSMOTIFS,cm);

% set(gca,'CLIM',[1 Nel]);
% spread of activity based on NERO_CLASSMOTIFS
% figure,
AC = unique(NERO_CLASSMOTIFS);
% AC=AC(AC<61);
NAC = length(AC);

% NCL = size(NERO_CLASSMOTIFS,1);
A = floor(sqrt(NCL)); B=A;
% A=60;B=10;
% cc=[[1 1 1];jet(NAC)];
inc=1/(Nel-1); T=1; 
% cc=[[T:-inc:inc]',[inc:inc:T]',ones(60,1)*0];
% cc = [[[T:-(2*inc):inc]';zeros(30,1)],[[0:(2*inc):(T-2*inc)]';[T:-(2*inc):inc]'],[zeros(30,1);[0:(2*inc):(T-2*inc)]']].^0.5;
% clfreq = ones(size(clfreq));
if A*B<NCL, B=A+1; end;
if A*B<NCL, B=B+1; end;
% mo = [4,6,1,5,2,3];
mo=1:length(NERO_CLASSMOTIFS);
intensity_on = 0;
%-->% plot all motifs
figure
for nn=1:NCL,
    bb=1.5;
%     cc = [[[T:-(2*inc):inc]';zeros(30,1)],[[0:(2*inc):(T-2*inc)]';[T:-(2*inc):inc]'],[zeros(30,1);[0:(2*inc):(T-2*inc)]']]*1/bb+(bb-1)/bb;
%     cc = [[[0:(2*inc):(T-2*inc)]';[T:-(2*inc):inc]'],[[T:-(2*inc):inc]';zeros(30,1)],[zeros(30,1);[0:(2*inc):(T-2*inc)]']]*1/bb+(bb-1)/bb;
     cc = fliplr(jet(Nel)')';
%     cc = hot(60);
    cc = cc./repmat(max(cc,[],2),1,3);
    bb=10;
    intensity  = (repmat(clfreq(nn,:)',1,3))/bb+(bb-1)/bb;
    if intensity_on
        cc=cc.*intensity;
%         cc=cc.^intensity;        
    end
%     cc=[[0 0 0];cc];% add intesity    
%     cc=[[1 1 1];cc];% add intesity    
%     cc = cc.^0.4
    trajectory = NERO_CLASSMOTIFS(mo(nn),NERO_CLASSMOTIFS(mo(nn),:)<Nel);
    [a,rankorder]=ismember(chm,trajectory);
    temp=chm; 
    temp(temp==Nel)=4;
    subplot2(A,B,nn,0.01,0.01); hold on;   
%     figure; hold on;   
%     title(['motif #' num2str(mo(nn)) ' - trials:' num2str(length(find(CLASSID==nn)))],'Fontsize',6,'FontWeight','bold');
%     imagesc(rankorder);
%     colormap(cc);
%     cc = jet(length(unique(trajectory)));
    cc = eval([colmap '(length(unique(trajectory)))']);
    cc=flipud(cc);
%     cc=[[1 1 1];cc];% add intesity    
    imagesc_RGB(reshape(rankorder,size(chm)),cc,'noentry',noentry); 
    [row,col]=find(rankorder==1);
    if plot_origin
        text(col,row,'x','Color',[1 1 1],'HorizontalAlignment','Center','VerticalAlignment','Middle','Fontsize',5,'FontWeight','bold');
    end

    %     title(num2str(find(CLASSID==nn)'));
    if ~notitle
        if isequal(mode,'showall'),
            title(['network event nr: ' num2str(nn) ', time:' num2str(EAfile.NERO.NERO_TIME(find(CLASSID==nn)))]);
        else
            title(find(CLASSID==nn));
        end
    end
%     caxis([0 60]);
%     caxis([0 NAC]);
     caxis([0 length(unique(rankorder(rankorder<Nel)))]);
    axis off;
    axis equal;
    axis image;
    set(gca,'YDir','normal')    
%     axis([0.5 6.5 0.5 10.5]);    
    set(gcf,'WindowButtonDownFcn' ,'popsubplot_all(gca);');
%     showbursts = 1;
%     if showbursts
%         set(gcf,'WindowButtonDownFcn' ,'popsubplot_all(gca); tt = length(get(get(gca,\''Parent\''),\''Children\''))-find((get(get(gca,\''Parent\''),\''Children\'')==gca))+1; id = find((EAfile.CLEANDATA.SPIKETIME>EAfile.NERO.NERO_TIME(tt)-3e6) & (EAfile.CLEANDATA.SPIKETIME<EAfile.NERO.NERO_TIME(tt)+3e6)); figure, plot(EAfile.CLEANDATA.SPIKETIME(id),EAfile.CLEANDATA.SPIKECHANNEL(id),\''k.\''); hold on; plot([EAfile.NERO.NERO_TIME(tt),EAfile.NERO.NERO_TIME(tt)],[0 max(EAfile.CLEANDATA.SPIKECHANNEL)])');
%     end
end

% SUPTITLE(strrep(EAfile.INFO.FILE.NAME,'_',' '));
set(gcf,'position',[162 9 673 1121]); set(gcf,'paperposition',[0.25 2.5 8 6]);