function [rho,pval] = PartialCorrFullLag(t1b,t2b,ttb,lag)
% Calculates the partial correlation spanning the lag specificed. Returns
% vectors rho and pval with length lag (spans -1/2 lag back, +1/2 lag forward).
% Version 1: Noah Levine-Small 27/06/2013

for i=-floor(lag/2):floor(lag/2)
    lt1b = lagmatrix(t1b,i);
    lt1b(isnan(lt1b))=0;
    [rho(i+floor(lag/2)+1),pval(i+floor(lag/2)+1)]=partialcorr(lt1b,t2b',ttb','type','spearman');
end

end