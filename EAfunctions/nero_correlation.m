function [similarity,score2] = neroclasses_correlation(seq1,seq2)
elis =intersect(seq1,seq2); 
score2 = length(elis)/length(union(seq1,seq2));
seq1 = seq1(ismember(seq1,elis));
seq2 = seq2(ismember(seq2,elis));
[temp,pos_seq1]=unique(seq1,'first');
[temp,pos_seq2]=unique(seq2,'first');
if length(seq1)>1
    cc = corrcoef(pos_seq1,pos_seq2);    
    similarity = cc(1,2); 
else
    similarity = nan; % only one common electrode
end
