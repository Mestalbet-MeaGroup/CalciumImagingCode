load('DataSet_GFAP_GcAMP6_withSchematic_withMask_withLags.mat');
for i=1:size(DataSet,2)
%     try
        traces = DataSet{i}.RawTraces;
        time   = DataSet{i}.RawTime;
        %         [bs,be] = SreedharBurstDetection(DataSet{i}.t,DataSet{i}.ic);
        %         close all;
        %         bs=DataSet{i}.bs;
        %         be=DataSet{i}.be;
        %         [bs,be] = SreedharBurstDetection(t,ic);
        [t,ic,bs,be] = CalcBurstsOnTrimmed(DataSet{i}.t,DataSet{i}.ic,DataSet{i}.bs,DataSet{i}.be,DataSet{i}.bw);
        if i==9 % Remove artifact from culture 9
            [~,b]=max(traces,[],2);
            traces(:,b(1))=traces(:,b(1)-1);
            [bs,be,~]=CalcBurstsSamora(t,ic);
        end
        AnalyzeCalciumTraces(traces,time,bs,t,ic,be);
%         AnalyzeCalciumTraces(traces,time,bs,DataSet{i}.t,DataSet{i}.ic);
%       E:\CalciumImagingArticleDataSet\Burst Triggered Traces\
        savefig(['Culture_',num2str(i)]);
        close all;
%     catch err
%         clear_all_but('i');
%         load('DataSet_GFAP_GcAMP6_withSchematic_withMask_withLags.mat');
%         for ii=i:size(DataSet,2)
%             traces = DataSet{ii}.RawTraces;
%             time   = DataSet{ii}.RawTime;
%             [bs,be] = SreedharBurstDetection(DataSet{ii}.t,DataSet{ii}.ic);
%             close all;
%             AnalyzeCalciumTraces(traces,time,bs);
%             pause(100);
%             savefig(['Culture_',num2str(ii),'a']);
%             close all;
%         end
%     end
end

