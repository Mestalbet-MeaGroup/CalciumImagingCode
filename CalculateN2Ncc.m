function CorrMat = CalculateN2Ncc(t,ic)
% Calculates the normalized unbiased cross correlation of the firing rate profile for every pair
% of electrodes. Tests for significance. 
% Written by: Noah Levine-Small
% Revision 2: 11/04/2013
tic
NumChannels=size(ic,2);
maxtime = max(t)/12;
%% Create Matrix of All Combinations of Electrodes
choices = VChooseK(1:NumChannels,2); 
n1 = choices(:,1);
n2 = choices(:,2);

%%
spmd
    if labindex == 1
        B = t;
        labBroadcast(1, B);
    else
        B = labBroadcast(1);
    end
    
    Corrs = codistributed.zeros(1,length(n1),codistributor());
    for i = drange(1:length(n1))
        %% Calculate Correlation between each electrode
%         t1=round(sort(tw.Value(ic(3,n1(i)):ic(4,n1(i)))));
%         t2=round(sort(tw.Value(ic(3,n2(i)):ic(4,n2(i)))));
        t1=round(sort(B(ic(3,n1(i)):ic(4,n1(i)))));
        t2=round(sort(B(ic(3,n2(i)):ic(4,n2(i)))));
        t1b = histc(t1./12,1:50:maxtime);
        t2b = histc(t2./12,1:50:maxtime);
        Corrs(i)= NormalizedCorrelation(t1b,t2b); % Normalize to mean/variance, unbiased, divide by dot product of zero-lags
        CorrPerm=zeros(1,500);
        %% Generate Test Statistic
        for j=1:500
            tperm=ShuffelIntervals(t1);
            tpermb = histc(tperm./12,1:50:maxtime);
            CorrPerm(j)=max(NormalizedCorrelation(tpermb,t2b));
        end
        %% Is Correlation higher than test statistic with 95% certainity?
        if Corrs(i) <(mean(CorrPerm)+2*std(CorrPerm))
            Corrs(i)=nan;
        end
    end
    Corrs = gather(Corrs);
end
Corrs = Corrs{1};
%% Re-arrange correlations to an ajancency matrix
CorrMat=zeros(NumChannels,NumChannels);
for i =1:length(n1); CorrMat(n1(i),n2(i))=Corrs(i); end;
CorrMat = CorrMat + CorrMat'+eye(size(CorrMat));
toc;
end

% 
% % Corrs=zeros(NumChannels,NumChannels);
% % spmd
% %     if labindex == 1
% %         tb = t;
% %         labBroadcast(1, tb);
% %     else
% %        tb = labBroadcast(1);
% %     end
% % end
% % tw = WorkerObjWrapper(tb);
% spmd
%     Corrs = codistributed.zeros(NumChannels,codistributor());
%     for ii=drange(1:NumChannels-1)
%         t1=round(sort(t(ic(3,ii):ic(4,ii))));
%         t1b = histc(t1./12,1:50:maxtime);
%         for ij=ii+1:NumChannels
%             t2=round(sort(t(ic(3,ij):ic(4,ij))));
%             t2b = histc(t2./12,1:50:maxtime);
%             Corrs(ii,ij)=NormalizedCorrelation(t1b,t2b);
%             CorrPerm=zeros(1,500);
%             for i=1:500
%                 tperm=ShuffelIntervals(t1);
%                 tpermb = histc(tperm./12,1:50:maxtime);
%                 CorrPerm(i)=max(NormalizedCorrelation(tpermb,t2b));
%             end
%             if Corrs(ii,ij) <(mean(CorrPerm)+2*std(CorrPerm))
%                 Corrs(ii,ij)=nan;
%             end
%         end
%     end
% end
% Corrs = cat(3, Corrs{1},Corrs{2},Corrs{3},Corrs{4},Corrs{5},Corrs{6},Corrs{7},Corrs{8});
% Corrs = sum(Corrs,3);
% Corrs = Corrs + Corrs'+eye(size(Corrs));
% toc
% end
