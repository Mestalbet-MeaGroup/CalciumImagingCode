function [h,p]=ChiTest(pre,post)
% bins = min(pre(~isnan(pre))):10:max(post(~isnan(post)));
bins = min(pre(~isnan(pre))):10:1500;
obsCounts=histc(post(~isnan(post)),bins);
expCounts=histc(pre(~isnan(pre)),bins);
[h,p,st] = chi2gof(bins,'ctrs',bins,...
        'frequency',obsCounts, ...
        'expected',expCounts,...
        'nparams',0,'emin',5);
end
