function [lag,Corr] = CalcCorr(a,b) %Between Astro's and Neurons
maxlag = 1000;
a=(a-nanmean(a))/nanvar(a);
b = filter(MakeGaussian(0,30,120),1,b);
b=(b-nanmean(b))/nanvar(b);
a(isnan(a))=0;
b(isnan(b))=0;
len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len)); % normalize by values at zero lag
[Corr,lag] = max(Corr(:));
lag = lag - maxlag;
end