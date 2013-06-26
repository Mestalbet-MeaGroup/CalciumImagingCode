function [astroIndex,astrotraces] = ClasifyAstrocyteTraces3(time,traces)
% Function which takes traces from calcium data and returns the set of
% traces which are astrocytic (and their indicies). Calculates the number of time to peaks for a trace that are under the mean neuronal peak time and the number over this time and specifies only allows traces where most of the 
% detected peaks are astrocytic.
% Revision 1: 31/05/13 *Improved version of the original
% ClasifyAstrocyteTraces.m
% Written by: Noah Levine-Small

for i=1:size(traces,2)
    x=traces(:,i)';
    burststarts=CalcCaOnsets(time',x');
    index = find((x > [x(1) x(1:(end-1))]) & (x >= [x(2:end) x(end)]));
    n = numel(burststarts);
    burststarts(end+1)=length(x);
    
    for j=1:n
        possibleMaxs = index(find(index>burststarts(j)&index<burststarts(j+1)));
        if isempty(possibleMaxs)
            [~,maxs(j)]=max(x(burststarts(j):burststarts(j+1)));
        else
        [pks,locs]=max(x(possibleMaxs));
        maxs(j)= possibleMaxs(locs);
        end
    end
    
    burststarts(end)=[];
    risetimes{i} = time(maxs)-time(burststarts);
    clear maxs;
    numastroSpikes(i) = numel(find(risetimes{i}>2.5));
    numNeuroSpikes(i) = numel(find(risetimes{i}<2.5));
end
astroIndex = find(numastroSpikes./numNeuroSpikes>1);
astrotraces=traces(:,astroIndex);

end