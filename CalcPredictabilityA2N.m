%Script which calculates the success by which the firing rate of the
%network predicts the astrocyte trace and plots a histogram of these scores
%for every astrocyte trace and all neurons in all recordings. Also plots a
%sample of the prediction, the actual trace and the GFR.
% Revision 1: 29/05/13
% Written by: Noah Levine-Small

for ii= 1:size(DataSet,1)
    fr = DataSet{ii}.GFR;
    traces = DataSet{ii}.Manual.FiltTraces;
    numtraces=size(traces,2);
    %     if ii<3
    %         fr=fr(250:3000);
    %         traces = traces(250:3000,:);
    %     end
    for i=1:numtraces
        score(i,ii) = LinearPredictionA2N(fr,traces(:,i));
        
        if i==22&&ii==1 % Plotting astrocyte 22 of 3334_14. 
            frF=fft(fr);
            AF=fft(traces(:,i));
            rA2fr = AF./frF;
            prediction =  conv(fr,ifft(rA2fr));
            prediction = prediction(1:length(traces(:,i)));
            hold on; plot(fr,'r'); plotyy(1:length(traces),traces(:,i),1:length(prediction),prediction); %plot(prediction,'k');hold off;
        end
    end
end

hist(score(score(:)>0),20)
xlim([0 1]);
ylabel('Number of Scores','FontSize',18);
xlabel('Predictability Score','FontSize',18);
set(gca,'FontSize',18)
print([loc 'PredictScores.png'],'-dpng','-r400');
close all;