function [rho,pval,lag]=partialcorrwithlag(t1b,t2b,ttb,lag)
% Function which calculates the partial correlation between two electrode spike trains using
% the spike times across all electrodes in the same period as the control
% variable.
% Input: t1b - spikes/bin from electrode 1
%        t2b - spikes/bin from electrode 2
%        ttb - spikes/bin from all electrodes (except 1&2)
% Output: rho - Correlation at best lag
%         pval - Signficance of correlation score
%         lag - Lag value for heighest partial correlation
% Revision 1: Noah Levine-Small on 27/06/13
% Revision 2: Noah Levine-Small on 27/06/13 *Added support for the case
% where the maximum cross corr is found to be less than 10 samples from the
% start of trace or less than 10 samples from the end of the trace.
% Revision 3: Noah Levine-Small 17/02/14 *Performed mean/var normalization.

% t1b = (t1b-nanmean(t1b))/nanvar(t1b);
% t2b = (t2b-nanmean(t2b))/nanvar(t2b);
% ttb = (ttb-nanmean(ttb))/nanvar(ttb);

vec = -floor(lag/2):floor(lag/2);
[~,idx]=max(xcorr(t1b,t2b,floor(lag/2)));

if idx>10
    if idx<length(vec)-10
        lag = vec(idx-10:idx+10);
    else
        lag = vec(idx-10:end);
    end
end

counter=1;
for i=lag
lt1b = lagmatrix(t1b,i);
lt1b(isnan(lt1b))=0;
[rho(counter),pval(counter)]=partialcorr(lt1b,t2b',ttb','type','spearman');
counter=counter+1;
end

[rho,index] = max(rho);
pval = pval(index);
lag = lag(index);
end