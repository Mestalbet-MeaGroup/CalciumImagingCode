fileList = getAllFiles(uigetdir); %select directory with Mat files containing t,ic, time, data variables
DataSet = cell(length(fileList),1); %take off comment

for ii=1:length(fileList) 
    load(fileList{ii});
    eval(['DataSet{' num2str(ii) '}.Record=fileList{' num2str(ii) '}(1:end-4)']); 
    [tWell,icWell] = OrganizeTICintoWells(t,ic);
    DataSet{ii}.icBase=icWell(1:5);
    DataSet{ii}.icGcamp = icWell(6:end);
    DataSet{ii}.tBase = tWell(1:5);
    DataSet{ii}.tGcamp = tWell(6:end);
    [DataSet{ii}.isiG, DataSet{ii}.isiB]=CalcISI9Well(DataSet{ii}.tGcamp,DataSet{ii}.icGcamp,DataSet{ii}.tBase,DataSet{ii}.icBase);
    [DataSet{ii}.ibiG,DataSet{ii}.ibiB,DataSet{ii}.bwG,DataSet{ii}.bwB]=CalcIBI9Well(DataSet{ii}.tGcamp,DataSet{ii}.icGcamp,DataSet{ii}.tBase,DataSet{ii}.icBase);
    [DataSet{ii}.frG,DataSet{ii}.frB]=CalcFR9Well(DataSet{ii}.tGcamp,DataSet{ii}.icGcamp,DataSet{ii}.tBase,DataSet{ii}.icBase,10000);
    clear_all_but('DataSet','ii','fileList');
end

save('DataSetGcamp6.mat','DataSet');

