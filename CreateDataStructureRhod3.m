%% Create file list

fileList = getAllFiles(uigetdir); % select directory with Mat files containing t,ic, time, data variables
% counter=1;
% counter2=counter;
% counter3=counter;
baselines=[];
stims=[];
for i=1:size(fileList,1)
    pos=findstr(fileList{i},'\');
    pos=pos(end);
    k = findstr(fileList{i}(pos:end), 'baseline');
    kk = findstr(fileList{i}(pos:end), 'Rhod3');
    
    if (~isempty(k))&&(isempty(kk))
        baselines = [baselines;i];
    end
    if ~isempty(kk)&&isempty(k)
        stims=[stims;i];
    end
    
end
DataSet = cell(length(fileList),1); %take off comment

% if ~exist('DataSet.mat', 'file')  % Checks to make sure an old file is not overwritten without being backed up.
%     save('DataSet.mat','DataSet');
% else
%     java.io.File('DataSet.mat').renameTo(java.io.File('DataSetOld.mat'));
%     save('DataSet','DataSet');
% end

for ii=1:size(fileList,1)
    %% Load Data
    
    if ~isempty(find(ii==baselines, 1))
        DataSet{ii}.base = 1;
    else
        DataSet{ii}.base = 0;
    end
    
    if ~isempty(find(ii==stims, 1))
        DataSet{ii}.stim = 1;
    else
        DataSet{ii}.stim = 0;
    end
    
    %     if ~isempty(find(ii==posts, 1))
    %         DataSet{ii}.post = 1;
    %     else
    %         DataSet{ii}.post = 0;
    %     end
    
    load(fileList{ii});
    k = findstr(fileList{ii}, '\');
    k=k(end)+1;
    eval(['DataSet{' num2str(ii) '}.Record=fileList{' num2str(ii) '}(k:end-4)']);
    [tWell,icWell] = OrganizeTICintoWells(t,ic);
    DataSet{ii}.icBase = icWell(1:5);
    DataSet{ii}.icRhod3 = icWell(6:end);
    DataSet{ii}.tBase = tWell(1:5);
    DataSet{ii}.tRhod3 = tWell(6:end);
    for i=1:size(DataSet{ii}.icBase,2)
        if DataSet{ii}.tBase{i}>100
            [DataSet{ii}.bsBase{i},DataSet{ii}.beBase{i},DataSet{ii}.bwBase{i},DataSet{ii}.ibiBase{i}]=UnsupervisedBurstDetection9Well(DataSet{ii}.tBase{i},DataSet{ii}.icBase{i});
        else
            DataSet{ii}.bsBase{i}=nan; DataSet{ii}.beBase{i}=nan; DataSet{ii}.bwBase{i}=nan;DataSet{ii}.ibiBase{i}=nan;
        end
    end
    for i=1:size(DataSet{ii}.icRhod3,2)
        if DataSet{ii}.tRhod3{i}>100
            [DataSet{ii}.bsRhod3{i},DataSet{ii}.beRhod3{i},DataSet{ii}.bwRhod3{i},DataSet{ii}.ibiRhod3{i}]=UnsupervisedBurstDetection9Well(DataSet{ii}.tRhod3{i},DataSet{ii}.icRhod3{i});
        else
            DataSet{ii}.bsRhod3{i}=nan; DataSet{ii}.beRhod3{i}=nan; DataSet{ii}.bwRhod3{i}=nan;DataSet{ii}.ibiRhod3{i}=nan;
        end
    end
end
clear_all_but('DataSet');
% save('DataSetStim.mat','DataSet');
