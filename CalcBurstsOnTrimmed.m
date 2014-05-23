function [t,ic,bs,be] = CalcBurstsOnTrimmed(t,ic,bs,be,bw)

[t,ic,~,~,~] = SortChannelsByFR2(t,ic,bs,be,bw);
        [bs,be,~]=CalcBurstsSamora(t,ic);
        for ii=1:numel(bs)
            temp=[];
            for j=1:size(ic,2)
                temp1=histc(sort(t(ic(3,j):ic(4,j))),[bs(ii),be(ii)]);
                temp(j)=temp1(1);
            end
            netpart(ii) = ceil((sum(temp > 5) / size(ic,2))*100) > 10;
        end
        bs = bs((netpart==1)); %modified for ClusterBurstsUsingAllInfo, originally without +sbs
        be = be((netpart==1));
end