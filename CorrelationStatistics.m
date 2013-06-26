% Calculates the distribtutions of the correlations in superburst and non
% superbursting cultures and plots them to figures;
% Revision 1: 29/05/13
% Written by: Noah Levine-Small


%% Superbursting Statistics
numastroSB=0;
numpairSB=0;
numNeuroSB=0;
sbCCs=[];

for i=1:2
test = triu(DataSet{i}.a2n.cc);
test = test(:);
test(test==0)=[];
test(isnan(test))=[]; %if its not signficant, do you zero it out or just dont consider it)
sbCCs = [sbCCs;test];
numastroSB=numastroSB+size(DataSet{i}.a2n.cc,2);
numpairSB=numpairSB+numel(test);
numNeuroSB=numNeuroSB+size(DataSet{i}.a2n.cc,1);
end

%% Non-superbursting statistics
numastro =0;
numpair=0;
numNeuro = 0;
CCs=[];

for i=3:5
test = triu(DataSet{i}.a2n.cc); %this is a mistake since the matrix is not symmetric. 
test = test(:);
test(test==0)=[];
test(isnan(test))=[];
CCs = [CCs;test];
numastro=numastro+size(DataSet{i}.a2n.cc,2);
numpair=numpair+numel(test);
numNeuro=numNeuro+size(DataSet{i}.a2n.cc,1);
end

%% Calculate probability of a connection
probCon = numpair / numel(allcomb(1:numNeuro,1:numastro));
probConSB = numpairSB / numel(allcomb(1:numNeuroSB,1:numastroSB));
bar([probCon;probConSB])
set(gca,'XTickLabel',{'Non-Superbursting', 'Super-Bursting'});
xlim([0 3]);
ylabel('Chance of an Astrocyte-Neuron Correlation','FontSize',16);
set(gca,'FontSize',18,'PlotBoxAspectRatio',[6.75 19 1]);
xticklabel_rotate(XTick,55,{'Non-Superbursting', 'Super-Bursting'},'interpreter','none');
print([loc 'ccProb.png'],'-dpng','-r400');
close all;

%% Plot histogram of non-superbursting correlations
figure;
hist(CCs)
xlim([0 1]);
ylabel('Number of Correlations','FontSize',18);
xlabel('Normalized Correlation Value','FontSize',18);
set(gca,'FontSize',18);
print([loc 'ccDist.png'],'-dpng','-r400');

%% Plot histogram of superbursting correlations
figure;
hist(sbCCs)
xlim([0 1]);
ylabel('Number of Correlations','FontSize',18);
xlabel('Normalized Correlation Value','FontSize',18);
set(gca,'FontSize',18);
print([loc 'SBccDist.png'],'-dpng','-r400');
close all;

%% Plot bootstrapped mean of superbursting correlations
statSB = bootstrp(1000,@(x)[mean(x) std(x)],sbCCs);
hist(statSB (:,1),50);
yticks = get(gca,'YTick');
set(gca,'YTickLabel',round(yticks/yticks(end)*100)/100);
set(gca,'FontSize',18);
xlim([0 1]);
xlabel('Estimated Mean Value','FontSize',18);
ylabel('Probability Density','FontSize',18);
print([loc 'SBccMeans.png'],'-dpng','-r400');
close all;

%% Plot bootstrapped mean of non-superbursting correlations
stat = bootstrp(1000,@(x)[mean(x) std(x)],CCs);
hist(stat (:,1),50)
yticks = get(gca,'YTick');
set(gca,'YTickLabel',round(yticks/yticks(end)*100)/100);
set(gca,'FontSize',18);
xlim([0 1]);
xlabel('Estimated Mean Value','FontSize',18);
ylabel('Probability Density','FontSize',18);
print([loc 'ccMeans.png'],'-dpng','-r400');
close all;