function [gaussian]=MakeGaussian(avr,sigma,nbins)
% [gaussian]=MakeGaussian(avr,sigma,nbins);
% Function purpose : creates a vector of a normalized gaussian
%
% Function recives :    avr [ms] - center of gaussian (usually zero)
%                       sigma [ms] - standard deviation of gaussian.
%                       nbins - length of gaussian vector (+-1).
%
% Function give back :  gaussian [ms] - a vector of nomalized gaussian                      
% Last updated : 24/6/04

gaussize=-round(nbins/2):round(nbins/2);
gaussian=exp((-gaussize-avr).*(gaussize-avr)/(2*sigma^2));
gaussian=gaussian/sum(gaussian);