function [lag,Corr] = CalcCorrRaw(a,b,maxlag) %Between Astro's and Neurons
len = length(a); % also equal to length(b)
auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len)); % normalize by values at zero lag
lag = -maxlag:maxlag;
% [Corr,lag] = max(Corr(:));
% lag = lag - maxlag;
end