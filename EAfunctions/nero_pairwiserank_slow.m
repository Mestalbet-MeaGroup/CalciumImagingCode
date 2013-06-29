function score = neroclasses_pairwiserank_slow(seq1,seq2)
seqIS = intersect(seq1,seq2);
seqIS = seqIS(~ismember(seqIS,61));
if isempty(seqIS)
    score = 0;
else
    temp = ismember(seq1,seqIS);
    seq1 = seq1(temp);
    temp = ismember(seq2,seqIS);
    seq2 = seq2(temp);
    l = length(seqIS);
    score = 0;
    for ii=1:(l-1)
        for jj = (ii+1):l
            score = score + ((find(seq2==seq1(ii))-find(seq2==seq1(jj)))<0);
       end
    end
    score = score/max(cumsum(1:(l-1)));
end