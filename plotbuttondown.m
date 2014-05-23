function plotbuttondown(ax,ob,handle,varargin)
% Function which lends click function to a plot.
% ax = axis, if equal to 1, function creates a new figure with the entire
% contents of the clicked axis. A subsequent click on an object in the new
% figure will create a new figure with just this object.

% ob = object, if equal to 1, function creates a new figure with only the
% clicked upon object. For example,. a trace in a graph.

tag=[];
if ~isempty(varargin)
    for i=1:2:length(varargin)
        eval(['tag.' varargin{i} '=' num2str(varargin{i+1}) ';']);
    end
end

if ax==1
%     set(handle, 'userdata', tag, 'buttondownfcn', 'dothis');
end

if ob==1
    set(handle, 'userdata', tag, 'buttondownfcn',...
    'popgco(''postpopcmd'', ''axis(''''auto'''')''); eval(''get(gcbo, ''''userdata'''')''); eval([''set(gcf,''''KeyPressFcn'''',RasterPlotLine(t,ic,(bs('',num2str(j),'')-lag)*'',num2str(12000),'',(bs('',num2str(j),'')+lag)*'',num2str(12000),'',squeeze(TriggeredTrace(:,'',num2str(i),'','',num2str(j),'')),lags,lag));'']);');
end

%     function dothis
%         figure;
%         hold all
%         i=tag.ROI;
%         for j=1:size(AlignedMat,3)
%             temp = squeeze(AlignedMat(:,i,j));
%             lh(j)=plot(lags,temp);
%             traceProp.trialID=j;
%             set(lh(j), 'userdata', traceProp, 'buttondownfcn', 'popgco(''postpopcmd'', ''axis(''''auto'''')''); eval(''get(gcbo, ''''userdata'''')'')');
%         end
%         
%         title(['ROI ', num2str(i)]);
%         axis tight;
%         maximize(gcf);
%     end
end