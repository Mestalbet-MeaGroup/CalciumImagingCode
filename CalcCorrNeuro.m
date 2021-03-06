function [lag,Corr] = CalcCorrNeuro(a,b) %Between Neurons and Neurons
maxlag = 1000;
a=(a-nanmean(a))/nanvar(a);
b=(b-nanmean(b))/nanvar(b);
len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len));
[Corr,lag] = max(Corr(:));
lag=lag-maxlag;
end