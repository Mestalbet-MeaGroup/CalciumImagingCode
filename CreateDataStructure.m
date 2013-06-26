% function CreateDataStructure();
% Performs the following:
% (1) Loads mat file with mcd recordings.  
% (2) Calls Fernando_CellDetect6 which calculates ROI and traces from Tiff
%     stack.
% (3) Aligns Ca trace to mcd recording using the ccd triggers
% (4) Calculates the firing rate of each channel (so that the sampling is
%     the same as the calcium signal sampling
% (3) Calculates the network firing rate
% (4) Adds the Cross-Correlation, Co-incidence to the structure
% (5) Saves the structure in a matfile

fileList = getAllFiles(uigetdir); %select directory with Mat files containing t,ic, time, data variables
DataSet = cell(length(fileList),1); %take off comment

if ~exist('DataSet.mat', 'file')  % Checks to make sure an old file is not overwritten without being backed up. 
    save('DataSet.mat','DataSet');
else 
    java.io.File('DataSet.mat').renameTo(java.io.File('DataSetOld.mat'));
    save('DataSet','DataSet');
end

for ii=1:length(fileList) 
    load(fileList{ii});
    eval(['DataSet{' num2str(ii) '}.Record=fileList{' num2str(ii) '}(end-21:end-4)']); 
    DataSet{ii}.t            = t; % Spike times arranged by channel
    DataSet{ii}.ic           = ic; % Index in t of channel start times
    %% Extracts Intensity from Tiff Stack
%     [DataSet{ii}.Auto.mask, DataSet{ii}.Auto.traces, DataSet{ii}.Auto.ROIcenters] = Fernando_CellDetect6(); % Finds ROI and calculates traces from detected areas
    %% Filters and Aligns Ca Traces to Mcd Recording
    for j=1:size(DataSet{ii}.traces,1)
        [DataSet{ii}.Auto.FiltTraces(j),DataSet{ii}.Auto.time] = FilterCalciumTraces(DataSet{ii}.Auto.traces(j,:)',sort(resample(triggers,size(DataSet{ii}.Auto.traces(j,:),2),length(triggers))));
    end
    DataSet{ii}.Manual.ROIcenters=ROIcenters;
    DataSet{ii}.Manual.mask=mask;
    [DataSet{ii}.astroidx,DataSet{ii}.Manual.traces] = ClasifyAstrocyteTraces(traces);
    DataSet{ii}.Manual.FiltTraces = filtTraces(:,DataSet{ii}.astroidx);
    DataSet{ii}.Manual.time = time;
    display('Completed Loading Data...');
    %% Calculates Firing Rate for each electrode
     display('Calculating firing rates...');
    for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)))./12;
        DataSet{ii}.FR(:,i)  = histc(t1,DataSet{ii}.Manual.time*1000);     % Calculate the firing rate for each electrode
    end
    DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2); % Mean firing rate 
    %% All Calculations From Manual Trace Extraction
    display('Calculating correlation between neurons...');
    DataSet{ii}.n2n.cc              = CalculateN2Ncc(DataSet{ii}.t,DataSet{ii}.ic); % Neuron to neuron cross-correlation
    [~,DataSet{ii}.n2n.ccOrder,~]   = DendrogramOrderMatrix2(DataSet{ii}.n2n.cc ); % Dendogram order of matrix 
    DataSet{ii}.n2n.ci              = CalculateN2Nci(DataSet{ii}.t ,DataSet{ii}.ic ); % Neuron to neuron co-incidence
    [~,DataSet{ii}.n2n.ciOrder,~]   = DendrogramOrderMatrix2(DataSet{ii}.n2n.ci );% Dendogram order of matrix 
    display('Calculating correlation between astrocytes...');
    DataSet{ii}.a2a.cc              = CalculateA2Acc(DataSet{ii}.Manual.FiltTraces); % Astrocyte to astrocyte cross-correlation
    [~,DataSet{ii}.a2a.ccOrder,~]   = DendrogramOrderMatrix2(DataSet{ii}.a2a.cc ); % Dendogram order of matrix 
    DataSet{ii}.a2a.ci              = []; % Astrocyte to Astrocyte co-incidence
    DataSet{ii}.a2a.ciOrder         = []; % Dendogram order of matrix 
    display('Calculating correlation between neurons and astrocytes (final stage)...');
    DataSet{ii}.a2n.cc              = CalculateA2Ncc(DataSet{ii}.Manual.FiltTraces,DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.FR,DataSet{ii}.Manual.time); % Astrocyte to neuron cross-correlation, requires NormalizedCorrelationwithStat.m and NormalizedCorrelation.m
    [~,DataSet{ii}.a2n.AccOrder, DataSet{ii}.a2n.NccOrder] = DendrogramOrderMatrix2(DataSet{ii}.a2n.cc);  % Dendogram order of matrix for astrocytes, Dendogram order of matrix for neurons
    [DataSet{ii}.a2n.ci,~,~]                               = CalculateA2Nci(DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.Manual.time,DataSet{ii}.Manual.traces); % Astrocyte to Neuron co-incidence 
    [~,DataSet{ii}.a2n.AciOrder, DataSet{ii}.a2n.NciOrder] = DendrogramOrderMatrix2(DataSet{ii}.a2n.ci); % Dendogram order of matrix for astrocytes, Dendogram order of matrix for neurons
    clear_all_but('DataSet','fileList','ii');
    save('DataSet','DataSet','-append');
end
clear_all_but('DataSet');
save('DataSet','DataSet');

% end