function [ffts,fftf] = CalcFFTfast(s,fs)
Tb = 1;
Ts = Tb/fs; 
% t = 0:Ts:(length(s)+2)*Tb-Ts;
L = length(s);
% faster w/ a pow2 length, signal padded with zeros
nfft = 2^nextpow2(L);
% do the nfft-point fft and normalize
S = fft(s,nfft)/L;
% x-axis from 0 to fs/2, nfft/2+1 points
fftf = 1/Ts/2*linspace(0,1,nfft/2+1);
% only plotting the first half since its mirrored, thus 1:nfft/2+1
% why multiplied with 2?
ffts = (2*abs(S(1:nfft/2+1)));
end