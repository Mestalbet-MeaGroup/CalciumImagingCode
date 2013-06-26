function [CorrMatSB,CorrMatNsb]= CalculateA2NccPerRegime(t,ic,traces,time)

[tSB,icSB,traceSB,timeSB,tNsb,icNsb,traceNsb,timeNsb]=SBsegmentation(t,ic,traces',time);


% CorrMatSB=[];
if ~isempty(tSB)
for i=1:size(tSB,2)
    for ii=1:size(icSB{i},2)
        fr(:,ii) = histc(tSB{i}(icSB{i}(3,ii):icSB{i}(4,ii))./12,timeSB{i}*1000);
    end
    CorrMatSB=zeros(size(traceSB{i},1), size(icSB{i},2), size(tSB,2));
    for ij=1:size(traceSB{i},1)
        for jj=1:size(icSB{i},2)
            if length(traceSB{i}(ij,:))==length(filter(MakeGaussian(0,30,120),1,fr(:,jj)))
            CorrMatSB(ij,jj,i) = NormalizedCorrelation(traceSB{i}(ij,:),filter(MakeGaussian(0,30,120),1,fr(:,jj)));
            else
                error('wrong!');
            end
%             display(i); display(ij); display(jj);
        end
    end
    clear fr;
end
CorrMatSB = mean(CorrMatSB,3);

else
    CorrMatSB=zeros(size(traceNsb{1},1), size(icNsb{1},2));
end

for i=1:size(tNsb,2)
    for ii=1:size(icNsb{i},2)
        fr(:,ii) = histc(tNsb{i}(icNsb{i}(3,ii):icNsb{i}(4,ii))./12,timeNsb{i}*1000);
    end
    CorrMatNsb=zeros(size(traceNsb{i},1), size(icNsb{i},2), size(tNsb,2));
    for ij=1:size(traceNsb{i},1)
        for jj=1:size(icNsb{i},2)
            if length(traceNsb{i}(ij,:))==length(filter(MakeGaussian(0,30,120),1,fr(:,jj)))
            CorrMatNsb(ij,jj,i) = NormalizedCorrelation(traceNsb{i}(ij,:),filter(MakeGaussian(0,30,120),1,fr(:,jj)));
            else
                error('wrong!');
            end
%             display(i); display(ij); display(jj);
        end
    end
    clear fr;
end
CorrMatNsb = mean(CorrMatNsb,3);
end


