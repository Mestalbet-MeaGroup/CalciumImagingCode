function [bs,be] = SreedharBurstDetection(t,ic)
EAFile = ConvertNoahSamora('n2s',ic,t);
[a,b]=sort(EAFile.RAWDATA.SPIKETIME);
SreedFile = [EAFile.RAWDATA.SPIKETIME(b)./1000000;EAFile.RAWDATA.SPIKECHANNEL(b)];
NB_extrema = sreedhar_ISIN_threshold(SreedFile);
bs = NB_extrema(:,1)'.*12000;
be = NB_extrema(:,2)'.*12000;

for i=1:numel(bs)
    temp=[];
    for j=1:size(ic,2)
        temp1=histc(sort(t(ic(3,j):ic(4,j))),[bs(i),be(i)]);
        temp(j)=temp1(1);
    end
    netpart(i) = ceil((sum(temp > 5) / size(ic,2))*100) > 30;
end
bs = bs((netpart==1)); %modified for ClusterBurstsUsingAllInfo, originally without +sbs
be = be((netpart==1));

end