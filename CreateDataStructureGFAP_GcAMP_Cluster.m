%% Create file list
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
homedir = [home,'\Documents\GitHub\CalciumImagingCode\DataSet\'];
% homedir = '/home/nl1001/MdcsDataLocation/freiburg/R2013a/remote/';
fileListTIC = getAllFiles([homedir,'Spike Mat Files/']); % select directory with Mat files containing t,ic,trigger variables
fileListTraces = getAllFiles([homedir,'Trace Mat Files/']); % select directory with Mat files containing trace variables:
% ROIcenters: Coordinates for ROI centroids
% Intensitymat: NroixFrames, raw trace values (average pixel intensity per frame per ROI)
% mask: 2D binary matrix where ones indicate ROIs. Each ROIcenter corresponds to an ROI in the mask and to the Nroi dimension of intensitymat
% region: Hippo output. Software used to select ROIs.

if size(fileListTraces,1)~=size(fileListTIC,1)
    error('Different number of trace files and electrode files');
end
DataSet = cell(size(fileListTraces,1),1);

for ii=1:size(fileListTraces,1)
    try
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
        DataSet{ii}.triggers     = triggers; %CCD triggers to MCD file
        DataSet{ii}.RawTime      = linspace(triggers(1),triggers(end),size(intensitymat,2)); %Time when each image frame was taken
        DataSet{ii}.fs           = 1/mean(diff(DataSet{ii}.RawTime)); %Sampling rate
        [DataSet{ii}.Schematic,... %adjacency matrix of connects based on lags for max corr
            DataSet{ii}.NodeID,...    %label for each node in adjacaceny matrix
            DataSet{ii}.A2Npc,...     %correlation between astro traces and neuronal FRs (sampled at same rate) with correlations between neuronal FRs subtracted
            DataSet{ii}.N2Npc,...     %partial correlation between electrode FRs
            DataSet{ii}.A2Apc,...     %partial correlation between filtered, df/f astrocyte traces
            DataSet{ii}.FR,...        %firing rate profile for each channel taken with the same fs as the Ca imaging
            DataSet{ii}.dfTraces,...  %df/f normalized traces
            DataSet{ii}.dfTime]=CalcInteractions3([],DataSet{ii}.ic,[], DataSet{ii}.triggers,DataSet{ii}.RawTraces,DataSet{ii}.t); %function to calcute all the above parameters
        
        % Mean firing rate
        DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2);
        
        % Burst Detect
        [DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw,DataSet{ii}.sbs,DataSet{ii}.sbe,DataSet{ii}.sbw]=UnsupervisedBurstDetection2(DataSet{ii}.t,DataSet{ii}.ic); %burst detection
        
        % CorrMats
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
        
        % Calculate partial correlations between astrocytes and neurons controlling for the global firing rate
        
        lags=-2000:100;
        combs = allcomb(1:size(DataSet{ii}.FR,2),1:size(DataSet{ii}.dfTraces,2));
        vec1=DataSet{ii}.FR(:,combs(:,1));
        vec2=DataSet{ii}.dfTraces(:,combs(:,2));
        numcom=size(combs,1);
        GFR = DataSet{ii}.GFR;
        
        keyMAT1 = '00001';
        obMAT1 = shmobject(keyMAT1,vec1);
        clear vec1;
        keyMAT2 = '00002';
        obMAT2 = shmobject(keyMAT2,vec2);
        clear vec2;
        
        parfor i=1:numcom
            Rvec1 = shmref(keyMAT1);
            Rvec2 = shmref(keyMAT2);
            v2 = lagmatrix(Rvec2.data(:,i),lags);
            [Pcorr(i,:),Pval(i,:)] = CalcPCwithLag(Rvec1.data(:,i),v2, GFR);
            delete(Rvec1);
            delete(Rvec2);
        end
        
        clear(obMAT1);
        clear(obMAT2);
        
        Pcorr(Pval<0.05)=nan;
        [ParCor,ind]=nanmax(Pcorr,[],2);
        lags=lags(ind);
        DataSet{ii}.A2NpcGFR=zeros(max(combs(:,1)),max(combs(:,2)));
        DataSet{ii}.A2NpcGFRlags=zeros(max(combs(:,1)),max(combs(:,2)));
        for i=1:numcom;
            DataSet{ii}.A2NpcGFR(combs(i,1),combs(i,2))=ParCor(i);
            DataSet{ii}.A2NpcGFRlags(combs(i,1),combs(i,2))=lags(i);
        end
        
        % Calculate PSTH of spike activity using Ca peaks as triggers
        [DataSet{ii}.PairWisePSTH, DataSet{ii}.PairWiseLags]=CalcPSTHastroNeuro(DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.dfTraces,DataSet{ii}.dfTime,DataSet{ii}.bs,DataSet{ii}.be,0); %raw
        [DataSet{ii}.PairWisePSTHnorm,DataSet{ii}.PairWiseLagsnorm]=CalcPSTHastroNeuro(DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.dfTraces,DataSet{ii}.dfTime,DataSet{ii}.bs,DataSet{ii}.be,2); %norm
        
        % Calculate PSTH of Ca activity using burst start peaks as triggers
        [DataSet{ii}.BurstTrigTrace,DataSet{ii}.BurstTrigSmoothTrace,DataSet{ii}.BurstTrigLags,DataSet{ii}.BurstTrigSmoothLags] = CalcBurstTriggeredAstroTrace(DataSet{ii}.bs,DataSet{ii}.RawTracesDataSet{ii}.RawTime,30);
        [DataSet{ii}.AlignedMat,DataSet{ii}.lags] = AlignTimeSeries(DataSet{ii}.BurstTrigTrace,DataSet{ii}.BurstTrigLags);
        
        % Regular Correlations
        DataSet{ii}.A2Ncc = CalculateA2Ncc(DataSet{ii}.dfTraces,DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.FR,DataSet{ii}.dfTime);
        DataSet{ii}.N2Ncc = CalculateN2Ncc(DataSet{ii}.t,DataSet{ii}.ic); %Correlation of firing rates
        DataSet{ii}.A2Acc = CalculateA2Acc(DataSet{ii}.dfTraces);
        
        % Store some meta data
        DataSet{ii}.date=[];
        DataSet{ii}.SpikesFileName=fileListTIC{sameCu};
        DataSet{ii}.TraceFileName=fileListTraces{ii};
        DataSet{ii}.RawTiffdir = 'E:\CalciumImagingArticleDataSet\GcAMP6 Data\Hippo Files\GFAP-GcAMP6\Tiffs';
        DataSet{ii}.RawMCDdir = 'E:\CalciumImagingArticleDataSet\GcAMP6 Data\Mcd Files';
        
        % Function text for all applied functions not within the matlab library
        if ii==1
            DataSet{ii}.CustomfunctionsApplied{1} = fileread('CalcDf_f.m');
            DataSet{ii}.CustomfunctionsApplied{2} = fileread('CalcPartCorri.m');
            DataSet{ii}.CustomfunctionsApplied{3} = fileread('PartialCorrWithLag3.m');
            DataSet{ii}.CustomfunctionsApplied{4} = fileread('CalcInteractions3.m');
            DataSet{ii}.CustomfunctionsApplied{5} = fileread('CalcPSTHastroNeuro.m');
            DataSet{ii}.CustomfunctionsApplied{6} = fileread('mpsth.m');
            DataSet{ii}.CustomfunctionsApplied{7} = fileread('CalcBurstTriggeredAstroTrace.m');
            DataSet{ii}.CustomfunctionsApplied{8} = fileread('AlignTimeSeries.m');
            DataSet{ii}.CustomfunctionsApplied{9} = fileread('UnsupervisedBurstDetection2.m');
            DataSet{ii}.CustomfunctionsApplied{10} = fileread('CalculateA2Ncc.m');
            DataSet{ii}.CustomfunctionsApplied{11} = fileread('CalculateN2Ncc.m');
            DataSet{ii}.CustomfunctionsApplied{12} = fileread('CalculateA2Acc.m');
        end
        display('Completed Loading Data...');
    catch err
        mail = 'noahmatlab@gmail.com'; %Your GMail email address
        password = '821405il';  %Your GMail password
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','E_mail',mail);
        setpref('Internet','SMTP_Username',mail);
        setpref('Internet','SMTP_Password',password);
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        % Send the email.  Note that the first input is the address you are sending the email to
        sendmail({'mestalbet@gmail.com'},'Test from MATLAB',err.identifier);
        continue;
    end
end
save([homedir,'DataSet_GFAP_GcAMP6_withSchematic_withMask_withLags_ParCor.mat'],'DataSet');