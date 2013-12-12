load('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Mat Files\4226_CAG-Gcamp6_ch206_2.mat');
neuron = intensitymat(3,14500:14900);
timeN = (0:length(neuron)-1)./(25.337);

load('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Mat Files\4384_gfap-GcAMP6_ch242.mat', 'intensitymat')
astro = intensitymat(2,6371:6595);
timeA = (0:length(astro)-1)./(14.235);

[AX,H1,H2] = plotyy(timeN,neuron,timeA,astro);
set(get(AX(1),'Ylabel'),'String','Neuronal Trace - CAG-GcAMP6') 
set(get(AX(2),'Ylabel'),'String','Astro Trace - GFAP-GcAMP6') 
xlabel('time [sec]') 
title('GcAMP6 Ca Event');
grid on;
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
export_fig -native 'CompareCaEvents.png';

