function [lag,Corr] = CalcCorrAstro(a,b) %Between Astros and Astros
maxlag = 1000;
a=(a-mean(a))/var(a);
b=(b-mean(b))/var(b);
len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,maxlag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len));
[Corr,lag] = max(Corr(:));
lag=lag-maxlag;
end