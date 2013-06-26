function [freq,smcs,smp1,smp2,coh,s,phase,psu,psl]=coherence2(source1,source2,PointOrTS,samplingrate,width)
% Written By: Bjorn Schechter
% Date: Revision 1: 05/12/2012
% Date: Revision 2: 30/04/2013 by Noah Levine-Small
% Input Variables: ts1/2 = Either a time series or point process where at
%                          each index in the vector is either the measurement value at sample i or the event time in seconds.
%                  fts1/2 = Indicates whether input variable ts1 or 2
%                           represents a time series or a point process
%                           (1 = time series, 0 = point process)
%                  samplingrate = number of samples taken per second (Hz)
%                  width = Bin size for smoothing of coherence
%                          (default = 1)
% Output Variables: freq = Frequencies where spectrums and coherence were
%                          calculated
%                   smcs = smoothed cross-spectrum
%                   smp1 = Smoothed Spectrum of ts1
%                   smp2 = Smoothed Spectrum of ts2
%                   coh  = Smoothed Coherence between ts1 and ts2
%                   s    = Significance (at 95% certainity) of Coherence
%                   phase= Phase correlation (only relevant where
%                          coherence is signficant)
%                   psu  = Upper limit of 95% confidence bounds
%                   psl  = Lower limit of 95% confidence bounds.

%% Calc FFT

switch PointOrTS
    case 0 %Both time series
        leng = min([numel(source1),numel(source2)]);
        freq=((1:leng)-1)/(leng-1)*samplingrate/2;
        lengts=leng;
        fftsource1=fft(source1);
        fftsource2=fft(source2);
        fftsource1=fftsource1(1:leng);
        fftsource2=fftsource2(1:leng);
        
    case 1 %Both point processes
        temp1=[min(source1),min(source2)];
        temp2=[max(source1),max(source2)];
        source1(source1<max(temp1))=[];
        source2(source2<max(temp1))=[];
        source1(source1>min(temp2))=[];
        source2(source2>min(temp2))=[];
%         s1 = zeros(round(max(temp2)),1);
%         s1(round(source1))=1;
%         s2 = zeros(round(max(temp2)),1);
%         s2(round(source2))=1;
%         lengts=numel(s1);
%         [fftsource1,freq] = CalcFFTfast(s1,samplingrate);
%         [fftsource2,~] = CalcFFTfast(s2,samplingrate);
%         leng=length(fftsource1);
        leng=(floor(max(temp2)/2)+1);
        freq=((1:leng)-1)/(leng-1)*samplingrate/2;
        lengts=numel(source1);
%         s1 = zeros(round(max(temp2)/12),1);
%         s2=s1;
%         s1(round(source1/12))=1;
%         s1=logical(s1);
%         s2(round(source2/12))=1;
%         s2=logical(s2);
%         [fftsource1,freq] = CalcFFTfast(s1,1);
%         [fftsource2,~] = CalcFFTfast(s2,1);
        fftsource1=zeros(leng,1);
        parfor i=1:length(source1)
            fftsource1=fftsource1+exp(-sqrt(-1)*2*pi*source1(i)/12000.*freq');
        end
        fftsource2=zeros(leng,1);
        parfor i=1:length(source2)
            fftsource2=fftsource2+exp(-sqrt(-1)*2*pi*source2(i)/12000.*freq');
        end
        
    case -1 %Source 1 is a time series, source 2 is a point process
%         source1 = resample(source1,round(max(source2)-min(source2)),round(max(time)-min(time)));
%         source1=source1(samplingrate:end-samplingrate);
        fftsource1=fft(source1);
        leng=floor(length(source1)/2)+1;
        fftsource1=fftsource1(1:leng);
        lengts=length(source1);
        freq=((1:leng)-1)/(leng-1)*samplingrate/2;
        fftsource2=zeros(leng,1);
        for i=1:length(source2)
            fftsource2=fftsource2+exp(-sqrt(-1)*2*pi*source2(i).*freq');
        end
        
        
    case -2 %Source 1 is a point process, source 2 is a time series
%         source2 = resample(source2,round(max(t)-min(t)),round(max(time)-min(time)));
%         source2=source2(samplingrate:end-samplingrate);
        fftsource2=fft(source2);
        leng=floor(length(source2)/2)+1;
        fftsource2=fftsource2(1:leng);
        lengts=length(source2);
        freq=((1:leng)-1)/(leng-1)*samplingrate/2;
        fftsource1=zeros(leng,1);
        for i=1:length(source1)
            fftsource1=fftsource1+exp(-sqrt(-1)*2*pi*source1(i).*freq');
        end
end

%% Calc Spectrum and Cross-Spectrum

cs=fftsource1.*conj(fftsource2); % cross spectrum
spectSource1=fftsource1.*conj(fftsource1);
spectSource2=fftsource2.*conj(fftsource2);


%% Smooth Data
width=2*round(width/(samplingrate/(lengts)))+1;
smooth=triang(width)/sum(triang(width));
smcs=conv(cs,smooth,'same');
smp1=conv(spectSource1,smooth,'same');
smp2=conv(spectSource2,smooth,'same');

%% Calculate Coherence and signficance values
% coh=abs(cs)./sqrt(spectSource1.*spectSource2); % No smoothing
coh=abs(smcs)./sqrt(smp2.*smp1);
phase = atan2(imag(smcs),real(smcs));

nu= 2./sum(smooth.^2);  % 2*number of epochs*1./sum(smooth.^2);
s=ones(leng,1)*sqrt(1-(0.05)^(2/(nu-2))); % 0.05% significance
psu=2*sqrt(ones(leng,1)*1/nu.*(1./coh(:).^2 - 1));
psl=-2*sqrt(ones(leng,1).*1/nu.*(1./coh(:).^2 - 1));
freq=freq';

end
