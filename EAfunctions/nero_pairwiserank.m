function [score,score2] = neroclasses_pairwiserank(seq1,seq2)
% compare sequences - similarity is the fraction of shared same pairwise
% correlations of electrodes within both sequences
% fast version of the function listed below
seqIS = intersect(seq1,seq2);
L=length(seqIS);
score2 = L/length(union(seq1,seq2));
if L>1
    temp = ismember(seq1,seqIS);
    seq1 = reshape(seq1(temp),1,L);
    temp = ismember(seq2,seqIS);
    seq2 = reshape(seq2(temp),1,L);
    
    [temp,pos]=ismember(seq1,seqIS);
    A=repmat(pos,L,1);
    [temp,pos]=ismember(seq2,seqIS); 
    B=repmat(pos,L,1);
    scoremat = uint8([A>=A']==[B>=B']);
    score = (sum(scoremat(:))-L)/(numel(A)-L);
elseif L==1
    score = 1;
else
    score = 0;
end
% end
% compare sequences - similarity is the fraction of shared same pairwise
% correlations of electrodes within both sequences
%
% function score = neroclasses_pairwiserank(seq1,seq2,varargin)
% seqIS = intersect(seq1,seq2);
% seqIS = seqIS(~ismember(seqIS,61));
% if isempty(seqIS)
%     score = 0;
% else
%     temp = ismember(seq1,seqIS);
%     seq1 = seq1(temp);
%     temp = ismember(seq2,seqIS);
%     seq2 = seq2(temp);
%     l = length(seqIS);
%     score = 0;
%     for ii=1:(l-1)
%         for jj = (ii+1):l
%             score = score + ((find(seq2==seq1(ii))-find(seq2==seq1(jj)))<0);
%        end
%     end
%     score = score/max(cumsum(1:(l-1)));
% end
