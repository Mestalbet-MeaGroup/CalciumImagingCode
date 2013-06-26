function [rho,pval]=partialcorrwithlag(t1b,t2b,ttb,lag)

% t1=1:10;
% t2=2:11;
% c=3:12;
% lag=3;


[~,idx]=max(xcorr(t1b,t2b,lag));
lag = idx-lag-1;
lt1b = lagmatrix(t1b,lag);
lt1b(isnan(lt1b))=0;
[rho,pval]=partialcorr(lt1b,t2b',ttb','type','spearman');
end

% Lagt1 = lagmatrix(t1',1:lag);
% 
% mxLagt1 = max(Lagt1(:,1:lag));
% temp2=[mxLagt1;ones(1,lag).*max(t2)];
% t1b= histc(Lagt1(:,1:lag),0:120:min(temp2,[],1)); %10ms bins
% t2temp=repmat(t2',1,lag);
% t2b= histc(t2temp,0:120:min(temp2,[],1));
% 
% 
% ctemp = histc(c,0:120:min(temp2,[],1));
% ttb=repmat(c',1,lag);

