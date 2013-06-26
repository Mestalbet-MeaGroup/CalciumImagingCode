function [astroIndex,astrotraces] = ClasifyAstrocyteTraces(traces)
% Function which takes traces from calcium data and returns the set of
% traces which are astrocytic (and their indicies). Calculates the average time to peak for a trace and specifies a
% minimum time necessary in order to classify the trace as astrocytic.
% Written by: Noah Levine-Small
% Revision 1: 23/04/2013
% Revision 2: 17/05/2013 *Added break if trough is first datapoint
traces = traces';
load('Kernel.mat');
f = savgol(10,1,0);
f1= savgol(100,1,0);
for i=1:size(traces,2)
    y = filtfilt(f,1,traces(:,i));
    pktest = filtfilt(f1,1,traces(:,i));
    [a,~] = find(y>pktest*1.01);
    testAstro = zeros(length(y),1);
    testAstro(a)=y(a);
    [~,maxs]=findpeaks(testAstro,'MINPEAKDISTANCE',30);
    if numel(maxs)>5
        for ii=1:length(maxs)
            index = maxs(ii);
            while y(index)>y(index-1)
                index=index-1;
                if (index-1>0)
                    break;
                end
            end
            mins(ii)=index;
        end
        meantimetopeak(i) = mean(maxs-mins');
    else
        y = filtfilt(f,1,traces(:,i));
        pktest = filtfilt(f1,1,traces(:,i).*1.005);
        [a,~] = find(y>pktest);
        testAstro = zeros(length(y),1);
        testAstro(a)=y(a);
        [~,maxs]=findpeaks(testAstro,'MINPEAKDISTANCE',30);
        for ii=1:length(maxs)
            index = maxs(ii);
            while (index>1)&&(y(index)>y(index-1))
                index=index-1;
            end
            mins(ii)=index;
        end
        meantimetopeak(i) = mean(maxs-mins');
    end
    
    clear maxs;
    clear mins;
end

astroIndex = find(meantimetopeak>min(meantimetopeak)*2);
astrotraces = traces(:,astroIndex);
end
