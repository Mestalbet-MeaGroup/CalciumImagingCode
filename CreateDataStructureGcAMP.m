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

    for i=1:size(DataSet{ii}.icBase,2)
        if DataSet{ii}.tBase{i}>100
            [DataSet{ii}.bsBase{i},DataSet{ii}.beBase{i},DataSet{ii}.bwBase{i},DataSet{ii}.ibiBase{i}]=UnsupervisedBurstDetection9Well(DataSet{ii}.tBase{i},DataSet{ii}.icBase{i});
        else
            DataSet{ii}.bsBase{i}=nan; DataSet{ii}.beBase{i}=nan; DataSet{ii}.bwBase{i}=nan;DataSet{ii}.ibiBase{i}=nan;
        end
    end
    for i=1:size(DataSet{ii}.icGcamp,2)
        if DataSet{ii}.tGcamp{i}>100
            [DataSet{ii}.bsGcamp{i},DataSet{ii}.beGcamp{i},DataSet{ii}.bwGcamp{i},DataSet{ii}.ibiGcamp{i}]=UnsupervisedBurstDetection9Well(DataSet{ii}.tGcamp{i},DataSet{ii}.icGcamp{i});
        else
            DataSet{ii}.bsGcamp{i}=nan; DataSet{ii}.beGcamp{i}=nan; DataSet{ii}.bwGcamp{i}=nan;DataSet{ii}.ibiGcamp{i}=nan;
        end
    end
    clear_all_but('DataSet','ii','fileList');
end

% save('DataSetGcamp6.mat','DataSet');

