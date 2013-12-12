function mask = CreateMaskFromHippo(region)

% load(uigetfile());

figure('visible','off');
hold on;
for c = 1:length(region.contours)
    patch(region.contours{c}([1:end 1],1),region.contours{c}([1:end 1],2),[0 0 0]);
end
axis tight;
axis off;
maximize(gcf);
set(gca,'YDir','reverse');
export_fig -native 'masktemp.tif';
close all;
mask = imread('masktemp.tif');
mask=imresize(mask,[520,692]);
mask = ~(mask==0);
delete('masktemp.tif');

end

% fun = @(x) mean(x(:)); 
% baseline = nlfilter(intensitymat,[1 100],fun); 
% traces = intensitymat./baseline;
% traces = traces(4,40:end-40);
% time  = (1/15).*(0:size(traces,2)-1);
% [filtered,timef] = FilterCalciumTraces(traces',time);
% hold on;
% plot(timef,filtered,'.-b');
% plot(time,traces,'-r')