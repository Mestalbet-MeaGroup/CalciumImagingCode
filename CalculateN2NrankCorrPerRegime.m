function [CorrMatSB,SigMatSB,CorrMatNsb,SigMatNsb]= CalculateN2NrankCorrPerRegime(t,ic,time)
[tSB,icSB,~,~,tNsb,icNsb,~,~]=SBsegmentation(t,ic,time',time);

if ~isempty(tSB)
    h = waitbarwithtime(0,'Calculating SBs...');
    for i=8%1:size(tSB,2)
        [CorrMatSB{i},SigMatSB{i}] = CalcRankCorr(tSB{i},icSB{i});
        waitbarwithtime(i/size(tSB,2),h);
    end
end


if ~isempty(tNsb)
    h = waitbarwithtime(0,'Calculating SBs...');
    for i=8%1:size(tNsb,2)
        [CorrMatNsb{i},SigMatNsb{i}] = CalcRankCorr(tNsb{i},icNsb{i});
        waitbarwithtime(i/size(tNsb,2),h);
    end
end