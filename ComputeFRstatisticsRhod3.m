function ComputeFRstatisticsRhod3(DataSet)

% Computes if there is a difference between control and experiment in FR nested
% pre/post and different cultures.

recordingTime = 30*60*1000; %30min
res=50;
fr=[];
gWell=[];
gType=[];
gCult=[];


for j=1:size(DataSet,1)
    tRhod3 = DataSet{j}.tRhod3;
    icRhod3 = DataSet{j}.icRhod3;
    tBase = DataSet{j}.tBase;
    icBase = DataSet{j}.icBase;
    for i=1:size(icRhod3,2)
        fr1=histc(sort(tRhod3{i}),0:res*12:recordingTime)./res;
        fr=[fr,fr1];
        gWell = [gWell;(ones(length(fr1),1).*i)]; %which well (1-9)
        gCult = [gCult,ones(size(fr1)).*j];
        gType = [gType,ones(size(fr1))]; 
    end
    
    for i=1:size(icBase,2)
        fr1=histc(sort(tBase{i}),0:res*12:recordingTime)./res;
        fr=[fr,fr1];
        gWell = [gWell;(ones(length(fr1),1).*i)+size(icRhod3,2)];
        gCult = [gCult,ones(size(fr1)).*j]; %which culture
        gType = [gType,ones(size(fr1)).*2]; % 1=gcamp,2=baseline
    end

end
gType=gType';
gCult=gCult';

% type nested well nested to culture
[p,table,stats,terms] = anovan(fr',{gType' gWell'},'model','full', 'varnames',{'ControlVsGcamp';'Wells'},'nested',[0,0;1,0]);

% [tempVal,~] = bootstrp(1000,@mean,frG(:,i)');
% valsGcamp = [valsGcamp;tempVal];
% [tempVal,~] = bootstrp(1000,@mean,frB(:,i)');
% valsBase = [valsBase;tempVal];

end