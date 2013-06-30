%%
% Calculates the symmetric KL divergence between each GcAMP experiment with
% every other GcAMP experiment, the symmetric KL diveregence between each
% control experiment with every other control experiment and the KL
% divergence between each GcAMP experiment with every control experiment.

ibiG=[];
bwG=[];
choices = VChooseK(1:size(DataSet{ii}.icGcamp,2),2);
n1 =choices(:,1);
n2 = choices(:,2);
betChoices  =allcomb(1:size(DataSet{ii}.icGcamp,2),1:size(DataSet{ii}.icBase,2));
Betn1 = betChoices(:,1);
Betn2 = betChoices(:,2);
ii=1;
parfor ii=1:size(DataSet,1)
    DataSet{ii}.uIBIg=unique(DataSet{ii}.ibiG);
    DataSet{ii}.uIBIb=unique(DataSet{ii}.ibiB);
    DataSet{ii}.uBWg=unique(DataSet{ii}.bwG);
    DataSet{ii}.uBWb=unique(DataSet{ii}.bwB);
    DataSet{ii}.uIBI      = unique([DataSet{ii}.ibiG,DataSet{ii}.ibiB]);
    DataSet{ii}.uBW      = unique([DataSet{ii}.bwG,DataSet{ii}.bwB]);
    % DataSet{ii}.uISIg=unique(DataSet{ii}.isiG);
    % DataSet{ii}.uISIb=unique(DataSet{ii}.isiB);
    for i=1:numel(n1)
        [~,~,bw1,ibi1]=UnsupervisedBurstDetection9Well(DataSet{ii}.tGcamp{n1(i)},DataSet{ii}.icGcamp{n1(i)});
        [~,~,bw2,ibi2]=UnsupervisedBurstDetection9Well(DataSet{ii}.tGcamp{n2(i)},DataSet{ii}.icGcamp{n2(i)});
        probIBI1 = ParseHistToProbs(DataSet{ii}.uIBIg,ibi1);
        probIBI2 = ParseHistToProbs(DataSet{ii}.uIBIg,ibi2);
        probBW1 = ParseHistToProbs(DataSet{ii}.uBWg,bw1);
        probBW2 = ParseHistToProbs(DataSet{ii}.uBWg,bw2);
        DataSet{ii}.klIBIg(i) = kldiv(DataSet{ii}.uIBIg,probIBI1+eps,probIBI2+eps ,'sym');
        DataSet{ii}.klBWg(i) = kldiv(DataSet{ii}.uBWg,probBW1+eps,probBW2+eps ,'sym');
        
        [~,~,bw1,ibi1]=UnsupervisedBurstDetection9Well(DataSet{ii}.tBase{n1(i)},DataSet{ii}.icBase{n1(i)});
        [~,~,bw2,ibi2]=UnsupervisedBurstDetection9Well(DataSet{ii}.tBase{n2(i)},DataSet{ii}.icBase{n2(i)});
        probIBI1 = ParseHistToProbs(DataSet{ii}.uIBIb,ibi1);
        probIBI2 = ParseHistToProbs(DataSet{ii}.uIBIb,ibi2);
        probBW1 = ParseHistToProbs(DataSet{ii}.uBWb,bw1);
        probBW2 = ParseHistToProbs(DataSet{ii}.uBWb,bw2);
        DataSet{ii}.klIBIb(i) = kldiv(DataSet{ii}.uIBIb,probIBI1+eps,probIBI2+eps ,'sym');
        DataSet{ii}.klBWb(i) = kldiv(DataSet{ii}.uBWb,probBW1+eps,probBW2+eps ,'sym');
    end
    
    for i=1:numel(Betn1)
        [~,~,bw1,ibi1]=UnsupervisedBurstDetection9Well(DataSet{ii}.tGcamp{Betn1(i)},DataSet{ii}.icGcamp{Betn1(i)});
        [~,~,bw2,ibi2]=UnsupervisedBurstDetection9Well(DataSet{ii}.tBase{Betn2(i)},DataSet{ii}.icBase{Betn2(i)});
        probIBI1 = ParseHistToProbs(DataSet{ii}.uIBI,ibi1);
        probIBI2 = ParseHistToProbs(DataSet{ii}.uIBI,ibi2);
        probBW1 = ParseHistToProbs(DataSet{ii}.uBW,bw1);
        probBW2 = ParseHistToProbs(DataSet{ii}.uBW,bw2);
        DataSet{ii}.klIBIg(i) = kldiv(DataSet{ii}.uIBI,probIBI1+eps,probIBI2+eps ,'sym');
        DataSet{ii}.klBWg(i) = kldiv(DataSet{ii}.uBW,probBW1+eps,probBW2+eps ,'sym');
    end
end