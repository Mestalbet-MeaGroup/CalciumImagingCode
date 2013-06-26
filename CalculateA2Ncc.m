function CorrMat = CalculateA2Ncc(traces,t,ic,FR,time)
% Calculates the normalized unbiased cross correlation between the firing
% rate from an electrode and the calcium trace.
% Written by: Noah Levine-Small
% Revision 2: 25/04/2013
tic
NumChannels=size(ic,2);
NumTraces = size(traces,2);

%% Create Matrix of All Combinations of Electrodes
choices = allcomb(1:NumChannels,1:NumTraces);
elecindex = choices(:,1);
astrindex = choices(:,2);

%%

Corrs = zeros(1,length(elecindex));
start = ic(3,elecindex);
stop = ic(4,elecindex);
channels = cell(length(start),1);

for i=1:length(start)
    channels{i} = t(start(i):stop(i));
    fr{i} = FR(:,elecindex(i));
end

for i=1:length(astrindex)
    astros{i} = traces(:,astrindex(i));
end

for i=1:length(elecindex)
        t1=round(sort(channels{i}));
        Corrs(i)=NormalizedCorrelationwithStat(astros{i},fr{i},t1,time); % Calculates normalized unbiased correlation and compares to randomly permuted interspike interval trace. Returns NaN for non-significant correlation values.
end

CorrMat=zeros(NumChannels,NumTraces);
for i =1:length(elecindex); CorrMat(elecindex(i),astrindex(i))=Corrs(i); end;
% CorrMat = CorrMat + CorrMat'+eye(size(CorrMat));
toc
end