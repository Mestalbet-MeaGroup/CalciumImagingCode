%% Create file list

fileListTIC = getAllFiles(uigetdir); % select directory with Mat files containing t,ic,trigger variables
fileListTraces = getAllFiles(uigetdir); % select directory with Mat files containing trace variables


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
    
    DataSet{ii}.channel=channel(ii);
    DataSet{ii}.culture=culture(ii);
    DataSet{ii}.t            = t; % Spike times arranged by channel
    DataSet{ii}.ic           = ic; % Index in t of channel start times
    DataSet{ii}.RawTraces    = intensitymat; %
    DataSet{ii}.RawTime      = linspace(triggers(1),triggers(end),size(intensitymat,2));
    DataSet{ii}.fs           = 1/mean(diff(DataSet{ii}.RawTime));
    [DataSet{ii}.dfTraces,DataSet{ii}.dfTime]  = CalcDf_f(DataSet{ii}.RawTraces,DataSet{ii}.fs,DataSet{ii}.RawTime);
    display('Completed Loading Data...');
    
    %% Calculates Firing Rate for each electrode
    display('Calculating firing rates...');
    for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)));
        DataSet{ii}.FR(:,i)  =  histc(t1,DataSet{ii}.dfTime*12000);
    end
    DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2); % Mean firing rate
    %% Calculate Burst Data
    [DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw,DataSet{ii}.sbs,DataSet{ii}.sbe,DataSet{ii}.sbw]=UnsupervisedBurstDetection2(DataSet{ii}.t,DataSet{ii}.ic);
    %% Calculate A2A Correlation
    DataSet{ii}.A2Acc = CalculateA2Acc(DataSet{ii}.dfTraces);
     %% Calculate A2N Correlation
    DataSet{ii}.A2Ncc = CalculateA2Ncc(DataSet{ii}.dfTraces',DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.FR,DataSet{ii}.dfTime);
   %% Calculate N2N Correlation
    DataSet{ii}.N2Ncc = CalculateN2Ncc(DataSet{ii}.t,DataSet{ii}.ic);
end
clear_all_but('DataSet');
