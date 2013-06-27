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

vec = -floor(lag/2):floor(lag/2);
[~,idx]=max(xcorr(t1b,t2b,floor(lag/2)));
if idx>=10
    lag = vec(idx-10:idx+10);
else
    lag  = vec(idx-idx+1:idx+idx);
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