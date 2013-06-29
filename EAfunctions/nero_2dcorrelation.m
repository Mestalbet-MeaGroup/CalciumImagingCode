function C = neroclasses_2dcorrelation(seq1,seq2,chm)
%---------------------
S1 = nan(size(chm));
S2 = nan(size(chm));
S1(ismember(chm,seq1))=seq1(~isnan(seq1));
S2(ismember(chm,seq2))=seq2(~isnan(seq2));
% C = xcorr2(S1,S2);
% c0 = C(floor(2*size(S1))+1);
C = sum((S1-nanmean(S1(:))).*(S2-nanmean(S2(:))))/((min(length(~isnan(S1)),length(~isnan(S2)))-1)*nanstd(S2(:))*nanstd(S1(:))); 
C=nansum(C);