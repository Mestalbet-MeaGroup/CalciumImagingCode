function [astroIndex,astrotraces] = ClasifyAstrocyteTraces2(traces)
% Function which takes traces from calcium data and returns the set of
% traces which are astrocytic (and their indicies). Calculates the average time to peak for a trace and specifies a
% minimum time necessary in order to classify the trace as astrocytic.
% Written by: Noah Levine-Small
% Revision 1: 23/04/2013
% Revision 2: 17/05/2013 *Added break if trough is first datapoint
% Revision 3: 28/05/2013 *Changing peak detection algorithm (requires lower
% SNR to properly identify peaks)
% Revision 4: 28/05/13 *Changed from meantimetopeak for a trace to number of times under 10 samples as a threshold.
% Revision 5: 29/05/13 *Changed peak detection to more accuratly capture
% peaks and troughs
traces = traces';
% load('Kernel.mat');
f = savgol(20,2,0);
Hd  = RemoveTrendsFilter;
for i=1:size(traces,2)
    
    y=traces(:,i);
    y1 = smooth(y,30,'sgolay',10);
    yf = medfilt1(y1,5); yf = medfilt1(yf,3);
    yry = [flipud(yf);yf;flipud(yf)];
    filt=filter(Hd,yry);
    pktest = filtfilt(f,1,filt);
    filt = filt(length(yf)+726:length(yf)*2+725);
    [mins,maxs]=FindExtrema(filt,y);
    %     meantimetopeak(i) = sum((maxs-mins)<40)/numel(maxs); % Fraction of onset times less than 40 samples duration
    spikeAmp = mean(filt(maxs((maxs-mins)<40)));
    astroAmp = mean(filt(maxs((maxs-mins)>60)));
    if astroAmp>spikeAmp
        meantimetopeak(i) = 1;
    else
        meantimetopeak(i)=0;
    end
    
    clear maxs;
    clear mins;
    
end
% astroIndex = find(meantimetopeak>min(meantimetopeak)*2);
astroIndex = find(meantimetopeak<0.4);%Less than 20% of the detected peaks can be neuronal
astrotraces = traces(:,astroIndex);

    function [mins,maxs]=FindExtrema(x,y)
        xf = medfilt1(x,100);
        test = find(x-xf>(mean(x-xf)+std(x-xf)));
        [pks,indx] = findpeaks(x,'MinPeakDistance',20);
        counter=1;
        prebuf = 100;
        
        for ii=1:numel(test)
            if find(indx==test(ii))
                maxs(counter) = test(ii);
                counter=counter+1;
            end
        end
        maxs(maxs<prebuf+16)=[];
        maxs(maxs>length(y)-15)=[];
        
        for ii=1:numel(maxs)
            [~,mLoc] = max(y(maxs(ii)-15:maxs(ii)+15));
            maxs(ii) = maxs(ii) - (16-mLoc);
            
            vec = (diff(diff(y(maxs(ii)-prebuf:maxs(ii)))));
            [~,loc]=max(vec);
            if ii>1 % continue working here
                while maxs(ii)-loc<=min(ii-1)
                    [~,loc]=max(vec);
                    vec(loc)=min(vec);
                end
            end
            
            
            [~,loc1] = min(y(maxs(ii)-prebuf+loc-15:maxs(ii)-prebuf+loc+15));
            mins(ii) = maxs(ii)-prebuf+loc-(16-loc1);
            
            %             display(ii);
        end
        amps = y(maxs) - y(mins); %checks for minimum height difference
        maxsig = max(y(maxs) - y(mins));
        
        maxs(amps<.5*maxsig)=[];
        mins(amps<.5*maxsig)=[];
    end
end
