function [score,score2] = neroclasses_alignments(seq1,seq2)
% scoring parameters
gap=0; 
mismatch = -1;
match = 1;

l1 = length(seq1);
l2 = length(seq2);
% nf = sqrt(l1*l2);
nf = min(l1,l2);
% //alternative: normalize by length of shorter sequence
% nf = min(length(seq1),length(seq2))
% //
%---------------------
alimat = nan(l1+1,l2+1);
alimat(:,1)=gap;
alimat(1,:)=gap;
for ii=2:(l1+1)
   for jj = 2:(l2+1)
        alimat(ii,jj) = max([alimat(ii-1,jj)+gap,alimat(ii,jj-1)+gap,alimat(ii-1,jj-1)+(match-mismatch)*(seq1(ii-1)==seq2(jj-1))+mismatch]);
% //Alternatively: use spatial neighborhood relation as scoring matrix       
% alimat(ii,jj) = max([alimat(ii-1,jj)+gap,alimat(ii,jj-1)+gap,alimat(ii-1,jj-1)+S+EA_ALISCORE(ii-1,jj-1,seq1,seq2,'MEA_Type',MEA_Type,'C',C)]);
% //
   end
end
score = alimat(end,end)/nf; 
score2 = length(intersect(seq1,seq2))/length(union(seq1,seq2));