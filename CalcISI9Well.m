function [isiG,isiB]=CalcISI9Well(tGcamp,icGcamp,tBase,icBase);
isiG=[];
for i=1:size(icGcamp,2)
    
    isiG = [isiG,CalculateISIs(tGcamp{i},icGcamp{i})];
    
end
    
isiB=[];
for i=1:size(icBase,2) 
    
     isiB = [isiB,CalculateISIs(tBase{i},icBase{i})];
    
end
end