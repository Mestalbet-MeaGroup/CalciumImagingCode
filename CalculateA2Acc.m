function Corrs = CalculateA2Acc(traces)
% Calculates the normalized unbiased cross correlation between two calcium traces.
% Written by: Noah Levine-Small
% Revision 1: 09/04/2013
NumTraces=size(traces,2);
Corrs=zeros(NumTraces,NumTraces);
for ii=1:NumTraces-1
    for ij=ii:NumTraces
        Corrs(ii,ij)=NormalizedCorrelation(traces(:,ii),traces(:,ij)); % Normalized unbiased correlation
    end
end
 Corrs = Corrs + triu(Corrs,1)';
end
