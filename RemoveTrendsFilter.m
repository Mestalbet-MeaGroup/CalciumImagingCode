function Hd = RemoveTrendsFilter
%REMOVETRENDSFILTER Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.8 and the Signal Processing Toolbox 6.11.
%
% Generated on: 08-Mar-2012 18:54:33
%

% Equiripple Highpass filter designed using the FIRPM function.

% All frequency values are in Hz.
% Fs = 12.5;  % Sampling Frequency
Fs = 14.235;  % Sampling with Zen
Fstop = 0.0008;          % Stopband Frequency
Fpass = 0.008;           % Passband Frequency
Dstop = 0.1;             % Stopband Attenuation
Dpass = 0.057501127785;  % Passband Ripple
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop, Fpass]/(Fs/2), [0 1], [Dstop, Dpass]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
end
