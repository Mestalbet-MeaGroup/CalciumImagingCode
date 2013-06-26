function [CorrMatSB,CorrMatNsb]= CalculateN2NciPerRegime(t,ic,time)
% time=1:max(t)/4000:max(t);
[tSB,icSB,~,~,tNsb,icNsb,~,~]=SBsegmentation(t,ic,time',time);


if ~isempty(tSB)
    for i=1:size(tSB,2)
        NumChannels=size(icSB{i},2);
        choices = VChooseK(1:NumChannels,2);
        n1 = choices(:,1);
        n2 = choices(:,2);
        h = waitbarwithtime(0,'Calculating Coherence...');
        Corr = zeros(NumChannels,NumChannels);
        for j=1:numel(n1)
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
            t1b = histc(t1,0:min(temp2));
            t2b = histc(t2,0:min(temp2));
            if length(t1b)>500&&length(t2b)>500
                [Cxy,F] = mscohere(t1b,t2b,[],[],6000,12000);
                width=100;
                width=2*round(width/(12000/(length(Cxy))))+1;
                smooth=triang(width)/sum(triang(width));
                nu= 2./sum(smooth.^2);  % 2*number of epochs*1./sum(smooth.^2);
                Cxy=conv(Cxy,smooth,'same');
                s=ones(length(Cxy),1)*sqrt(1-(0.05)^(2/(nu-2))); % 0.05% significance
                coh=Cxy(Cxy>s);
                if ~isempty(coh)
                    %             [cs,F] = cpsd(t1b,t2b,[],[],6000,12000);
                    %             Phase(n1(j),n2(j))=-angle(cs);
                    Corr(n1(j),n2(j))=max(coh);
                else
                    Corr(n1(j),n2(j))=nan;
                end
            else
                Corr(n1(j),n2(j))=nan;
            end
            waitbarwithtime(j/numel(n1),h);
            %             display(j);
        end
        close(h);
        CorrMatSB{i} = Corr + Corr'+eye(size(Corr));
    end
end

if ~isempty(tNsb)
    for i=1:size(tNsb,2)
        NumChannels=size(icNsb{i},2);
        choices = VChooseK(1:NumChannels,2);
        n1 = choices(:,1);
        n2 = choices(:,2);
        h = waitbarwithtime(0,'Calculating Coherence...');
        Corr = zeros(NumChannels,NumChannels);
        for j=1:numel(n1)
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
            t1b = histc(t1,0:min(temp2));
            t2b = histc(t2,0:min(temp2));
            if length(t1b)>500&&length(t2b)>500
                [Cxy,F] = mscohere(t1b,t2b,[],[],6000,12000);
                width=100;
                width=2*round(width/(12000/(length(Cxy))))+1;
                smooth=triang(width)/sum(triang(width));
                nu= 2./sum(smooth.^2);  % 2*number of epochs*1./sum(smooth.^2);
                Cxy=conv(Cxy,smooth,'same');
                s=ones(length(Cxy),1)*sqrt(1-(0.05)^(2/(nu-2))); % 0.05% significance
                coh=Cxy(Cxy>s);
                if ~isempty(coh)
                    %             [cs,F] = cpsd(t1b,t2b,[],[],6000,12000);
                    %             Phase(n1(j),n2(j))=-angle(cs);
                    Corr(n1(j),n2(j))=max(coh);
                else
                    Corr(n1(j),n2(j))=nan;
                end
            else
                Corr(n1(j),n2(j))=nan;
            end
            waitbarwithtime(j/numel(n1),h);
            %             display(j);
        end
        close(h);
        CorrMatNsb{i} = Corr + Corr'+eye(size(Corr));
    end
end