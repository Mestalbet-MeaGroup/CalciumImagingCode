% [Firings,SumFirings]=FindNeuronFrequency(t,indexchannel,WindowSize,NonPlot);
% Function purpose : Finds Frequency of firings using a moving window
%
% Function recives :    t [1/12 ms] - firing timings
%                       ic - indexchannel
%                       WindowSize - Size of movong window in [ms]
% Function give back :  Firings - a matrix (NeuronNumber X bins) with
%                       frequency of every neuron in 1/ms units 
%                       TotalFirings - a vector with the average frequency
%                       of all neurons 1/ms/(Number Neurons)
%                       NonPlot - if =1 does'nt plot just calculates,
%                       (defult value =0)
%
% To show paster plot use : plot(TotalFirings);
% Last updated : 28/08/05

function [Firings,TotalFirings]=FindNeuronFrequency(t,ic,WindowSize,NonPlot);

if nargin==3
    NonPlot=0;
end
 
t=round(t./12);
NeuNum=size(ic,2);

% NumPoints=ceil((max(t)-1)/WindowSize);
NumPoints=ceil((max(t)-min(t))/WindowSize); %for t that doesnt start from 0

Firings=zeros(NeuNum,NumPoints);
TotalFirings=zeros(1,NumPoints);
% h1=waitbar(0,'Calculating...');

for i=1:NeuNum
    %[ftshist, binpos] = hist([1 t(ic(3,i):ic(4,i)) max(t)],NumPoints);
    if ic(3,i)~=0
        [ftshist, binpos] = hist([min(t) t(ic(3,i):ic(4,i)) max(t)],NumPoints); %for t that doesnt start from 0
    else
        ftshist=zeros(1,NumPoints);ftshist(1)=1;ftshist(end)=1;
    end
    Firings(i,:)=ftshist;
%     waitbar(i/(NeuNum),h1);
end

Firings(:,1)=Firings(:,1)-1;
Firings(:,end)=Firings(:,end)-1; %deleting points added to homogenity (max(t) & min(t)) in times in hist

Firings=Firings./WindowSize; %(Normatization for firings per ms)
if size(ic,2)==1
    TotalFirings=Firings;
else
    TotalFirings=sum(Firings)./NeuNum;
end
% close(h1);

if NonPlot==0
    %plotting...
    figure;
    plot((1:length(TotalFirings)).*WindowSize./60./60./1000,TotalFirings(1:length(TotalFirings))*1000*60);
    xlabel('Time [h]');
    ylabel('Spikes per neuron per minute');
    title('Network Firing Rate');
    
    %plotting all neurons
    figure;
    Shift=[0 (max(Firings')+5e-5)];
    Shift=cumsum(Shift);
    hold on;
    for i=1:NeuNum
        x=(1:length(TotalFirings)).*WindowSize./60./60./1000;
        y=(Firings(i,:)+Shift(i))*60*1000;
        plot(x,y);
        text(max(x)*1.01,mean(y),[num2str(ic(1,i)) '-' num2str(ic(2,i))],'FontSize',7);
    end
    xlabel('Time [h]');
    ylabel('Spikes per neuron per minute');
    title('Network Firing Rate - all neurons');
end
