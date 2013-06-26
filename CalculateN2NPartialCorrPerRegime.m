function [CorrMatSB,SigMatSB,CorrMatNsb,SigMatNsb]= CalculateN2NPartialCorrPerRegime(t,ic,time);
[tSB,icSB,~,~,tNsb,icNsb,~,~]=SBsegmentation(t,ic,time',time);

if ~isempty(tSB)
    h = waitbarwithtime(0,'Calculating SBs...');
    for i=8%1:size(tSB,2)
        [CorrMatSB{i},SigMatSB{i}] = CalcPartialCorrParfor(tSB{i},icSB{i});
        waitbarwithtime(i/size(tSB,2),h);
    end
end
% Null hypothesis is that the correlation between r and s electrodes can be explained solely by the correlations of r and s to the mean field. 

if ~isempty(tNsb)
    h = waitbarwithtime(0,'Calculating Nsbs...');
    for i=8%1:size(tNsb,2)
        [CorrMatNsb{i},SigMatNsb{i}] = CalcPartialCorrParfor(tNsb{i},icNsb{i});
        waitbarwithtime(i/size(tNsb,2),h);
    end
end