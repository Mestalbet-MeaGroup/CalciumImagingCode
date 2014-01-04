function burststarts=CalcCaOnsets(glia1)
% Function to find the onsets of calcium increases from traces. Takes
% filtered traces and time vector and returns the onset times for each
% spike.
% Revision 1: 31/05/13 *Taken from an old function I wrote. Changed to
% return index rather than time of onset.
% Written by: Noah Levine-Small
glia1=(glia1-mean(glia1))/var(glia1) ;
glia1=glia1-min(glia1);
divglia1=diff(glia1);
% [pks,locs] = findpeaks(diff(glia1),'MINPEAKHEIGHT',mean(divglia1(divglia1>0)),'MINPEAKDISTANCE',50);
locs = peakfinder(glia1');
onsets=[];
locs = [1 locs'];
counter=1;
for i=1:size(locs,2)-1
    test=diff(glia1(locs(i):locs(i+1)));
    a = test>0;
    b = test<0;
    test1=zeros(size(test));
    test1(a)=1;
    test1(b)=0;
    places = and(test1,~[1;test1(1:end-1)]);
    if sum(places)>=1
        onsets(counter)=max(find(places==1)+locs(i));
        counter=counter+1;
    end
end

burststarts=onsets;
end

