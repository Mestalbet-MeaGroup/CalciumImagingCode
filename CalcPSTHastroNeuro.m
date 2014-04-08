function [PairWisePSTH,PairWiseLags]=CalcPSTHastroNeuro(t,ic,traces,time,bursts,burste,varargin)
% Function which calculates the pairwise PSTH using individual astrocytic
% events as triggers and an individual electrode's spikes.
% Input: t = spike times in units of samples, ic = index channel, time =
% time in seconds of astrocytic traces. bursts = burst starts. burste =
% burst ends. optional inputs, if 0 don't perform normalization, if 1 or 2 then perform normalization of psth (see below).
pre= 5000; %ms
post = pre;
bin = 100; %ms
if varargin{1}~=2
    PairWisePSTH=nan(size(traces,2),size(ic,2));
    PairWiseLags=PairWisePSTH;
else
    PairWisePSTH=nan(size(traces,2),size(ic,2),(pre+post)/bin);
    PairWiseLags=[];
end

[t,ic] = RemoveHAneurons(t,ic,bursts,burste);
temp  = mpsth(t(ic(3,1):ic(4,1))./12000,time(floor(end/2)),'tb',1,'fr',0,'pre',pre,'post',post,'binsz',bin);
lagTimes=temp(:,1);
fun = @(block_struct) nanmax(block_struct.data);
for i=1:size(traces,2)
    [~,idx,~] = deleteoutliers(traces(:,i),0.05,0);
    test = zeros(max(idx),1);
    test(idx)=traces(idx,i);
    res = blockproc(test,[50,1],fun);
    res(res==0)=[];
    bs = ismember(traces(:,i),res);
    bs = find(bs);
    bs(diff(bs)<50)=[];
    for j=1:size(ic,2)
        ps = mpsth(t(ic(3,j):ic(4,j))./12000,time(bs),'tb',0,'fr',0,'pre',pre,'post',post,'binsz',bin);
        if varargin{1} == 0 %No Normalization
            [PairWisePSTH(i,j), idx] = max(ps);
            PairWiseLags(i,j) = lagTimes(idx);
        end
        if varargin{1} == 1 %Normalize by the ratio of spikes within sample period to number of spikes times number of trials. 
            [PairWisePSTH(i,j), idx] = max(ps);
            PairWiseLags(i,j) = lagTimes(idx);
            %         PairWisePSTH(i,j)=PairWisePSTH(i,j)/( (ic(4,j)-ic(3,j))*numel(bs));
            %         PairWisePSTH(i,j)=PairWisePSTH(i,j)/( (ic(4,j)-ic(3,j)));
            integral = trapz(ps);
            if integral~=0
                scalefactor = integral/(ic(4,j)-ic(3,j));
                PairWisePSTH(i,j) = PairWisePSTH(i,j)*scalefactor;
            else
                PairWisePSTH(i,j) = 0;
            end
        end
        if varargin{1} == 2 %Normalize by number of trials, convert to Z-score, normalize to variance/mean in firing 
            spks = sort(t(ic(3,j):ic(4,j))).*12;
            fr=histc(spks,min(spks):bin:max(spks))./bin;
            %             PairWisePSTH(i,j,:)=ps./( (ic(4,j)-ic(3,j))*numel(bs) );
            if sum(ps)==0
                PairWisePSTH(i,j,:)=ps;
            else
                ps = ps/numel(bs); %remove the effect of number of ca spikes
                ps =abs(ps - mean(ps))/var(ps); % how many standard deviations above the mean, at a given lag, is a peak in the histogram
                PairWisePSTH(i,j,:)=ps.*(var(fr)/mean(fr)); %normalize by the variance in the firing rate for that channel (what are the odds that randomly during the trials, there was an increase)
            end
            PairWiseLags=[];
            PairWiseLags = lagTimes;
        end
        
    end
end
% if varargin{1} == 1
%     PairWisePSTH = (PairWisePSTH-nanmin(PairWisePSTH(:)))/(nanmax(PairWisePSTH(:))-nanmin(PairWisePSTH(:)));
% end
end
