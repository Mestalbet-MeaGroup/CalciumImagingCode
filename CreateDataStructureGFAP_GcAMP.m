%% Create file list

fileListTIC = getAllFiles(uigetdir('','Spike Data: t,ic,triggers')); % select directory with Mat files containing t,ic,trigger variables
fileListTraces = getAllFiles(uigetdir('','Trace Data: intensitymat,time')); % select directory with Mat files containing trace variables


if size(fileListTraces,1)~=size(fileListTIC,1)
    error('Different number of trace files and electrode files');
end

for ii=1:size(fileListTraces,1)
    
    flags = isstrdigit(fileListTraces{ii});
    [a,b]=initfin(flags);
    w=b-a;
    culture(ii)=str2double(fileListTraces{ii}(a(w>2):b(w>2)));
    channel(ii)=str2double(fileListTraces{ii}(a((w>0)&(w<3)):b((w>0)&(w<3))));
    sameCu = nan;
    
    for k=1:size(fileListTIC,1)
        if strfind(fileListTIC{k},num2str(culture(ii)))
            if channel(ii)/10<1
                test = ['00',num2str(channel(ii))];
            else
                if channel(ii)/10<10
                    test = ['0',num2str(channel(ii))];
                else
                    test = num2str(channel(ii));
                end
            end
            if strfind(fileListTIC{k},test)
                sameCu=k;
            end
        end
    end
    
    if ~isnan(sameCu)
        load(fileListTraces{ii});
        load(fileListTIC{sameCu});
    else
        DataSet{ii}.channel=channel(ii);
        DataSet{ii}.culture=culture(ii);
        DataSet{ii}.error='mismatch';
        continue;
    end
    DataSet{ii}.mask=mask;
    DataSet{ii}.channel=channel(ii);
    DataSet{ii}.culture=culture(ii);
    DataSet{ii}.t            = t; % Spike times arranged by channel
    DataSet{ii}.ic           = ic; % Index in t of channel start times
    DataSet{ii}.RawTraces    = intensitymat; %raw calcium traces through hippo generated mask
    DataSet{ii}.triggers     = triggers; %LED triggers to MCD file
    DataSet{ii}.RawTime      = linspace(triggers(1),triggers(end),size(intensitymat,2)); %Time when each image frame was taken
    DataSet{ii}.fs           = 1/mean(diff(DataSet{ii}.RawTime)); %Sampling rate
    [DataSet{ii}.Schematic,... %adjacency matrix of connects based on lags for max corr
        DataSet{ii}.NodeID,...    %label for each node in adjacaceny matrix
        DataSet{ii}.A2Ncc,...     %correlation between astro traces and gaussian kernel convolved neuronal FRs
        DataSet{ii}.N2Ncc,...     %correlation between electrode FRs
        DataSet{ii}.A2Acc,...     %correlation between filtered, df/f astrocyte traces
        DataSet{ii}.FR,...        %firing rate profile for each channel taken with the same fs as the Ca imaging
        DataSet{ii}.dfTraces,...  %df/f normalized traces
        DataSet{ii}.dfTime]=CalcInteractions2([],DataSet{ii}.ic,[], DataSet{ii}.triggers,DataSet{ii}.RawTraces,DataSet{ii}.t); %function to calcute all the above parameters
    DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2); % Mean firing rate
    [DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw,DataSet{ii}.sbs,DataSet{ii}.sbe,DataSet{ii}.sbw]=UnsupervisedBurstDetection2(DataSet{ii}.t,DataSet{ii}.ic); %burst detection
    % CorrMat
    DataSet{ii}.A2Ncorrmat=zeros(max(DataSet{ii}.A2Ncc(:,1)),max(DataSet{ii}.A2Ncc(:,2)));
    for i=1:length(DataSet{ii}.A2Ncc(:,1));
        DataSet{ii}.A2Ncorrmat(DataSet{ii}.A2Ncc(i,1),DataSet{ii}.A2Ncc(i,2))=DataSet{ii}.A2Ncc(i,4);
    end
   
    DataSet{ii}.N2Ncorrmat=zeros(max(DataSet{ii}.N2Ncc(:,1)+1),max(DataSet{ii}.N2Ncc(:,2)));
    for i=1:length(DataSet{ii}.N2Ncc(:,1));
        DataSet{ii}.N2Ncorrmat(DataSet{ii}.N2Ncc(i,1),DataSet{ii}.N2Ncc(i,2))=DataSet{ii}.N2Ncc(i,4);
    end
    DataSet{ii}.N2Ncorrmat = DataSet{ii}.N2Ncorrmat + DataSet{ii}.N2Ncorrmat'+eye(size(DataSet{ii}.N2Ncorrmat));
    
    DataSet{ii}.A2Acorrmat=zeros(max(DataSet{ii}.A2Acc(:,1)+1),max(DataSet{ii}.A2Acc(:,2)));
    for i=1:length(DataSet{ii}.A2Acc(:,1));
        DataSet{ii}.A2Acorrmat(DataSet{ii}.A2Acc(i,1),DataSet{ii}.A2Acc(i,2))=DataSet{ii}.A2Acc(i,4);
    end
    DataSet{ii}.A2Acorrmat = DataSet{ii}.A2Acorrmat + DataSet{ii}.A2Acorrmat'+eye(size(DataSet{ii}.A2Acorrmat));
    % Lag mat
    DataSet{ii}.A2Nlagmat=zeros(max(DataSet{ii}.A2Ncc(:,1)),max(DataSet{ii}.A2Ncc(:,2)));
    for i=1:length(DataSet{ii}.A2Ncc(:,1));
        DataSet{ii}.A2Nlagmat(DataSet{ii}.A2Ncc(i,1),DataSet{ii}.A2Ncc(i,2))=DataSet{ii}.A2Ncc(i,3);
    end
    
    DataSet{ii}.N2Nlagmat=zeros(max(DataSet{ii}.N2Ncc(:,1)+1),max(DataSet{ii}.N2Ncc(:,2)));
    for i=1:length(DataSet{ii}.N2Ncc(:,1));
        DataSet{ii}.N2Nlagmat(DataSet{ii}.N2Ncc(i,1),DataSet{ii}.N2Ncc(i,2))=DataSet{ii}.N2Ncc(i,3);
    end
    DataSet{ii}.N2Nlagmat = DataSet{ii}.N2Nlagmat + DataSet{ii}.N2Nlagmat'+eye(size(DataSet{ii}.N2Nlagmat));
    
    DataSet{ii}.A2Alagmat=zeros(max(DataSet{ii}.A2Acc(:,1)+1),max(DataSet{ii}.A2Acc(:,2)));
    for i=1:length(DataSet{ii}.A2Acc(:,1));
        DataSet{ii}.A2Alagmat(DataSet{ii}.A2Acc(i,1),DataSet{ii}.A2Acc(i,2))=DataSet{ii}.A2Acc(i,3);
    end
    DataSet{ii}.A2Alagmat = DataSet{ii}.A2Alagmat + DataSet{ii}.A2Alagmat'+eye(size(DataSet{ii}.A2Alagmat));
    
    display('Completed Loading Data...');
end
clear_all_but('DataSet');
save('DataSet_GFAP_GcAMP6_withSchematic_withMask_withLags.mat','DataSet');