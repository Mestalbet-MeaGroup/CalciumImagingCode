icBase=icWell(1:5);
icGcamp = icWell(6:end);
tBase = tWell(1:5);
tGcamp = tWell(6:end);

isiG=[];
for i=1:size(icGcamp,2)
    
    isiG = [isiG,CalculateISIs(tGcamp{i},icGcamp{i})];
    
end
    
isiB=[];
for i=1:size(icBase,2) 
    
     isiB = [isiB,CalculateISIs(tBase{i},icBase{i})];
    
end