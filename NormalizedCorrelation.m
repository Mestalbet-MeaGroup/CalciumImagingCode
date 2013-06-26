function Corr=NormalizedCorrelation(a,b)
% Calculates the unbiased and normalized correlation between two time
% series.
% a =  used for astrocyte (in astro2neuro correlation calculation)
% b =  used for neuron firing rate (in astro2neuro correlation calculation)
% Written by: Noah Levine-Small
% Revision 1: 3/03/2013
lag = 300;
a=(a-mean(a))/var(a);
b=(b-mean(b))/var(b);
len = length(a); % also equal to length(b)

auto_a = xcorr(a,'unbiased');
auto_b = xcorr(b,'unbiased');
[Corr,~] = xcorr(a,b,lag,'unbiased');
Corr = Corr ./ sqrt(auto_a(len) .* auto_b(len)); % normalize by values at zero lag
Corr = max(Corr(:));
end