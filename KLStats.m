for ii=1:size(DataSet,1)
    mIBIg(ii) = mean(DataSet{ii}.klIBIg);
    sIBIg(ii) = std(DataSet{ii}.klIBIg);
    
    mIBIb(ii) = mean(DataSet{ii}.klIBIb);
    sIBIb(ii) = std(DataSet{ii}.klIBIb);
    
    mIBI(ii) = mean(DataSet{ii}.klIBI);
    sIBI(ii) = std(DataSet{ii}.klIBI);
end

[~,baseBet,~]=ttest2(mIBI,mIBIb);
[~,gcampBet,~]=ttest2(mIBI,mIBIg);
[~,baseGcamp,~]=ttest2(mIBIb,mIBIg);
boxPlot([mIBI;mIBIb;mIBIg]')
