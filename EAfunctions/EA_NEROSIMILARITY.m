function [EAfile] = EA_NEROSIMILARITY(EAfile,varargin)
%
% calculate similarity between nerosequences
% type: 'fast'(default),'correlation', 'pairwiserank', 'alignment'

type = 'fast';
% median networkevent size (larger fraction in bimodal eventsize distribution)

CHANNELMAT = EAfile.NERO.NERO_CHANNELMAT;
N_NE = size(CHANNELMAT,1);
NEID = 1:N_NE;

pvpmod(varargin);

NEID = NEID(ismember(NEID,1:N_NE));
CHANNELMAT = CHANNELMAT(NEID,:); 
N_NE = size(CHANNELMAT,1);

NERO_SIMILARITYMAT = nan(N_NE,N_NE);
NERO_OVERLAPMAT = nan(N_NE,N_NE);
% pv = 0;
disp(['similarity measure : ' type]);
switch type
    case 'fast'
        % convert CHANNELMAT into RANKMAT
        NERO_RANKMAT = nero_rankmat(CHANNELMAT);
        % correlate network event rank order
        NERO_SIMILARITYMAT = corr(NERO_RANKMAT', 'rows','pairwise');
%         [NERO_SIMILARITYMAT,PVAL] = corr(NERO_RANKMAT', 'rows','pairwise');        
%         NERO_OVERLAPMAT is not calculated
    case 'pairwiserank'
        for aa=1:(N_NE-1),
            for bb=(aa+1):N_NE
                seq1=CHANNELMAT(aa,:);
                seq1=seq1(seq1<61);
                seq2=CHANNELMAT(bb,:);
                seq2=seq2(seq2<61);
                [similarity,shared] = nero_pairwiserank(seq1,seq2);
%                 similarity = nero_pairwiserank_slow(seq1,seq2);                
                NERO_SIMILARITYMAT(aa,bb)=similarity;
                NERO_SIMILARITYMAT(bb,aa)=similarity;  
                NERO_OVERLAPMAT(aa,bb)=shared;
                NERO_OVERLAPMAT(bb,aa)=shared;                
            end
%             pv0=pv;
%             pv = fix(100*(2*aa/N_NE-(aa/N_NE)^2));
%             if ~isequal(pv,pv0)
%                 disp([num2str(pv) '%']); 
%             end
        end
    case 'alignment'
        for aa=1:(N_NE-1),
            for bb=(aa+1):N_NE
                seq1=CHANNELMAT(aa,:);
                seq1=seq1(seq1<61);
                seq2=CHANNELMAT(bb,:);
                seq2=seq2(seq2<61);
                [similarity,shared] = nero_alignment(seq1,seq2);
                NERO_SIMILARITYMAT(aa,bb)=similarity;
                NERO_SIMILARITYMAT(bb,aa)=similarity;  
                NERO_OVERLAPMAT(aa,bb)=shared;
                NERO_OVERLAPMAT(bb,aa)=shared;                     
            end
%             pv0=pv;
%             pv = fix(100*(2*aa/N_NE-(aa/N_NE)^2));
%             if ~isequal(pv,pv0)
%                 disp([num2str(pv) '%']); 
%             end
        end
    case 'correlation'
        for aa=1:(N_NE-1),
            for bb=(aa+1):N_NE
                seq1=CHANNELMAT(aa,:);
                seq1=seq1(seq1<61);
                seq2=CHANNELMAT(bb,:);
                seq2=seq2(seq2<61);
                [similarity,shared] = nero_correlation(seq1,seq2);
                NERO_SIMILARITYMAT(aa,bb)=similarity;
                NERO_SIMILARITYMAT(bb,aa)=similarity;  
                NERO_OVERLAPMAT(aa,bb)=shared;
                NERO_OVERLAPMAT(bb,aa)=shared;                     
            end
%             pv0=pv;
%             pv = fix(100*(2*aa/N_NE-(aa/N_NE)^2));
%             if ~isequal(pv,pv0)
%                 disp([num2str(pv) '%']); 
%             end
        end
    case '2dcorrelation'
        for aa=1:(N_NE-1),
            for bb=(aa+1):N_NE
                seq1=CHANNELMAT(aa,:);
                seq1=seq1(seq1<61);
                seq2=CHANNELMAT(bb,:);
                seq2=seq2(seq2<61);
                similarity = nero_2dcorrelation(seq1,seq2,EAfile.INFO.MEA.CHANNELMAP);
                NERO_SIMILARITYMAT(aa,bb)=similarity;
                NERO_SIMILARITYMAT(bb,aa)=similarity;  
%                 NERO_OVERLAPMAT(aa,bb)=shared;
%                 NERO_OVERLAPMAT(bb,aa)=shared;                     
            end
%             pv0=pv;
%             pv = fix(100*(2*aa/N_NE-(aa/N_NE)^2));
%             if ~isequal(pv,pv0)
%                 disp([num2str(pv) '%']); 
%             end
        end        
    otherwise
        disp('wrong type - no similarities calculated');
        NERO_SIMILARITYMAT = nan(size(NERO_SIMILARITYMAT));
        NERO_OVERLAPMAT = nan(size(NERO_SIMILARITYMAT));        
end
EAfile.NERO.NERO_SIMILARITYMAT = single(NERO_SIMILARITYMAT);
EAfile.NERO.NERO_OVERLAPMAT    = single(NERO_OVERLAPMAT);
EAfile.NERO.NERO_ID = NEID;
EAfile.NERO.SETTINGS.TYPE = type;
EAfile.NERO.HELP.NERO_SIMILARITYMAT = 'matrix of similarity values between network events';
EAfile.NERO.HELP.NERO_ID = 'index of network events for which similarity was calculated';
EAfile.NERO.HELP.NERO_OVERLAPMAT = 'matrix with fraction of shared electrodes between network events';
EAfile.NERO.SETTINGS.HELP.limits = 'range of network events used for similarity calculation';
EAfile.NERO.SETTINGS.HELP.TYPE = 'type of similarity (distance) measure - pairwiserank (default), alignment, correlation';