function [PermTimings]=ShuffelIntervals(Timings);
%[PermTimings]=ShuffelIntervals(Timings);
%
% Function purpose    : Function gets a vector with times of an event (like Bind)
%                       and returns a vector with events after shiffeling
%                       intervals between events
%
% Function recives    : Timings - vector with event timings
%                       
% Function give back  : PermTimings - Permutated timings
%
% Last updated : 21/01/05 

DTime = diff(Timings);
p = randperm(size(DTime,2)); 
PermDTime(p) = DTime;
PermTimings = [0 cumsum(PermDTime)] + Timings(1);
end