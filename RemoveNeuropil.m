function traces = RemoveNeuropil(traces)

traces = traces';
load('Kernel.mat');
f = savgol(2,1,0);
f1= savgol(100,1,0);
for i=1:size(traces,2)
    y = filtfilt(f,1,traces(:,i));
    pktest = filtfilt(f1,1,traces(:,i));
    [a,~] = find(y>pktest*1.01);
    testAstro = zeros(length(y),1);
    testAstro(a)=y(a);
    [~,maxs]=findpeaks(testAstro,'MINPEAKDISTANCE',30);
    for ii=1:length(maxs)
        index = maxs(ii);
        index2 = maxs(ii);
        while y(index)>y(index-1)
            index=index-1;
            if (index-1>0)
                break;
            end
        end
        
        while (index2<length(y))&&y(index2)>y(index2+1)
            index2=index2+1;
        end
        index = index-3;
        index2 = index2+1;
        if maxs(ii)-index<10
            if index -(index2-index)>0
                traces(index:index2,i)=traces(index -(index2-index):index,i);
            else
                traces(index:index2,i)=traces(index:index+(index2-index),i);
            end
        end
        
    end
end

end
