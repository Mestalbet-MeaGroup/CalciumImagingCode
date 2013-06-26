function [filtered,time] = FilterCalciumTraces(data,time)
%  Calculates the Savitzky-Golay and high-pass filters in order to remove
%  noise, neuron transients and slow flourescent drift from a raw calcium
%  trace.
% 09-03-2012 Noah Levine-Small
%% Step 1, clip ends
data=data(10:end-10);
time=time(10:end-10);
%% Step 2, savitzy-galay filter
f = savgol(10,1,0);
y = filtfilt(f,1,data);
% filtered=y;
% y=data;
%% Step 3, highpass filter to remove slow changes in trace

Hd  = RemoveTrendsFilter;
yry = [flipud(y);y;flipud(y)];

filt=filter(Hd,yry);
filtered=filt(length(y)+726:length(y)*2+725); % Due to the observed kernel size, we fix for the 726 datapoint phase-shift
time=time(1:length(filtered));

% Properties of High-Pass Filter:
% Sampling Frequency, Fs = 12.5; 
% Stopband Frequency, Fstop = 0.0008; 
% Passband Frequency, Fpass = 0.008;   
% Stopband Attenuation, Dstop = 0.1;
% Passband Ripple, Dpass = 0.057501127785;
% Density Factor,dens  = 20;  
end
