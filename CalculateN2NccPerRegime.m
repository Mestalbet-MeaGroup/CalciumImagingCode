function [CorrsMatSB,CorrsMatNsb]= CalculateN2NccPerRegime(t,ic,time)
% time=1:max(t)/4000:max(t);
[tSB,icSB,~,~,tNsb,icNsb,~,~]=SBsegmentation(t,ic,time',time);

if ~isempty(tSB)
    for i=1:size(tSB,2)
        NumChannels=size(icSB{i},2);
        choices = VChooseK(1:NumChannels,2);
        n1 = choices(:,1);
        n2 = choices(:,2);
        %         h = waitbarwithtime(0,'Calculating Superbursting Correlations...');
        Corr = zeros(NumChannels,NumChannels);
        %         tic;
        parfor j=1:numel(n1)
            t1 = tSB{i}(icSB{i}(3,n1(j)):icSB{i}(4,n1(j)));
            t2 = tSB{i}(icSB{i}(3,n2(j)):icSB{i}(4,n2(j)));
            t1(isnan(t1))=[];
            t2(isnan(t2))=[];
            temp1=[min(t1),min(t2)];
            temp2=[max(t1),max(t2)];
            t1(t1<max(temp1))=[];
            t2(t2<max(temp1))=[];
            t1(t1>min(temp2))=[];
            t2(t2>min(temp2))=[];
            t1b = histc(t1,0:120:min(temp2)); %Resolution of 10ms
            t2b = histc(t2,0:120:min(temp2));
            if sum(t1b)>200&&sum(t2b)>200
                Corr(j) = NormalizedCorrelation(t1b,t2b);
                %                 CorrPerm=zeros(1,500);
                %% Generate Test Statistic
                %                 for k=1:500
                %                     tperm=ShuffelIntervals(t1);
                %                     tpermb = histc(tperm,0:120:min(temp2));
                %                     CorrPerm(k)=max(NormalizedCorrelation(tpermb,t2b));
                %                 end
                %                 %% Is Correlation higher than test statistic with 95% certainity?
                %                 if Corr(n1(j),n2(j)) <(mean(CorrPerm)+2*std(CorrPerm))
                %                     Corr(n1(j),n2(j))=nan;
                %                 end
            else
                Corr(j)=nan;
            end
        end
        CorrMatSB{i} = Corr;
    end
    for kk=1:length(CorrMatSB)
        Corrs = zeros(size(icSB{1},2),size(icSB{1},2));
        Corr = CorrMatSB{kk};
        for k=1:numel(n1)
            Corrs(n1(k),n2(k))=Corr(k);
        end
        Corrs = Corrs + Corrs'+eye(size(Corrs));
        CorrsMatSB{kk} = Corrs;
    end
end



if ~isempty(tNsb)
    for i=1:size(tNsb,2)
        NumChannels=size(icNsb{i},2);
        choices = VChooseK(1:NumChannels,2);
        n1 = choices(:,1);
        n2 = choices(:,2);
        Corr = zeros(NumChannels,NumChannels);
        parfor j=1:numel(n1)
            t1 = tNsb{i}(icNsb{i}(3,n1(j)):icNsb{i}(4,n1(j)));
            t2 = tNsb{i}(icNsb{i}(3,n2(j)):icNsb{i}(4,n2(j)));
            t1(isnan(t1))=[];
            t2(isnan(t2))=[];
            temp1=[min(t1),min(t2)];
            temp2=[max(t1),max(t2)];
            t1(t1<max(temp1))=[];
            t2(t2<max(temp1))=[];
            t1(t1>min(temp2))=[];
            t2(t2>min(temp2))=[];
            t1b = histc(t1,0:120:min(temp2)); %Resolution of 10ms
            t2b = histc(t2,0:120:min(temp2));
            if sum(t1b)>200&&sum(t2b)>200
                Corr(j) = NormalizedCorrelation(t1b,t2b);
                %                 CorrPerm=zeros(1,500);
                %% Generate Test Statistic
                %                 for k=1:500
                %                     tperm=ShuffelIntervals(t1);
                %                     tpermb = histc(tperm,0:120:min(temp2));
                %                     CorrPerm(k)=max(NormalizedCorrelation(tpermb,t2b));
                %                 end
                %                 %% Is Correlation higher than test statistic with 95% certainity?
                %                 if Corr(n1(j),n2(j)) <(mean(CorrPerm)+2*std(CorrPerm))
                %                     Corr(n1(j),n2(j))=nan;
                %                 end
            else
                Corr(j)=nan;
            end
            
        end
        %         toc
        CorrMatNsb{i} = Corr;
    end
    for kk=1:length(CorrMatNsb)
        Corrs = zeros(size(icNsb{1},2),size(icNsb{1},2));
        Corr = CorrMatNsb{kk};
        for k=1:numel(n1)
            Corrs(n1(k),n2(k))=Corr(k);
        end
        Corrs = Corrs + Corrs'+eye(size(Corrs));
        CorrsMatNsb{kk} = Corrs;
    end
    
end
end