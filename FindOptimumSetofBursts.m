function [bs1,be1,lag]=FindOptimumSetofBursts(bs,be,t,lag)
% Looks for the set of bursts with either the highest spike rate or the
% greatest distance
% bs=bs./12000;
% be=be./12000;
bs1=bs;
be1=be;
t=sort(t)./12000;
temp = find(diff(bs)<(2*lag));
temp1 = temp+1;
closeBursts = unique([temp,temp1]);
loc=zeros(1,max(closeBursts));
loc(closeBursts)=1;
[setStart,setStop]=initfin(loc);
SetWidth=(setStop-setStart)+1;


removeme=[]; 
for i=1:length(SetWidth)
    removeme= [removeme,(setStart(i)+1:setStop(i))]; 
end
bs1(removeme)=[];
be1(removeme)=[];

%% Deal with sets of 2
% FirstRun = find(SetWidth<3);
% if ~isempty(FirstRun)
%     removeme=[];
%     for i=FirstRun
%         counter = setStart(i);
%         while counter<=setStop(i)
%             numSpks(counter-setStart(i)+1) = sum((t>bs(counter))&(t<(be(counter))));
%             counter=counter+1;
%         end
%         [~,deleteme]=min(numSpks);
%         removeme = [removeme,deleteme+setStart(i)-1];
%     end 
%         bs1(removeme)=[];
%         be1(removeme)=[];
%         temp = find(diff(bs1)<(2*lag));
%         temp1 = temp+1;
%         closeBursts = unique([temp,temp1]);
%         loc=zeros(1,max(closeBursts));
%         loc(closeBursts)=1;
%         [setStart,setStop]=initfin(loc);
%         SetWidth=(setStop-setStart)+1;
% end
% 
% %% Number of possible combinations for long strings are astronomical 
%   while (sum(SetWidth>15)>0)&&(lag>0)
%         lag=lag-1;
%         temp = find(diff(bs1)<(2*lag));
%         temp1 = temp+1;
%         closeBursts = unique([temp,temp1]);
%         loc=zeros(1,max(closeBursts));
%         loc(closeBursts)=1;
%         [setStart,setStop]=initfin(loc);
%         SetWidth=(setStop-setStart)+1;
%   end
%     
% %% Deal with the remainer
% % tic
% deleteme=[];
% for i=1:length(SetWidth)
%     badcomb=[];
%     bestcomb=[];
%     spkScore=[];
%     dist=[];
%     if mod(SetWidth(i),2)~=0
%         combs = VChooseK(int8(1:SetWidth(i)),(SetWidth(i)-1)/2);
%     else
%         combs = VChooseK(int8(1:SetWidth(i)),(SetWidth(i))/2);
%     end
%     dist2=cell(size(combs,1),1);
%     vec=setStart(i):setStop(i);
%     parfor j=1:size(combs,1)
%         vec1 = vec(combs(j,:));
%         tempScore=0;
%         for k=1:numel(vec1)
%             tempScore = tempScore + sum((t>bs1(vec1(k)))&(t<(be1(vec1(k)))));
%         end
%         spkScore(j)=tempScore;
% %         dist(j,1:numel(vec1)-1) = diff(bs1(vec1));
%         dist2{j} = diff(bs1(vec1));
%         if sum(dist2{j}<(2*lag))
% %         if sum(dist(j,:)<(2*lag))
%             badcomb = [badcomb,j];
%         end
%     end
%     if ~isempty(badcomb)
%         spkScore(badcomb)=[];
%         combs(badcomb,:)=[];
%         [~,bestcomb]=max(spkScore);
%     else
%         [~,bestcomb]=max(spkScore);
%     end
%     if ~isempty(bestcomb)
%         remove = ~ismember(1:numel(vec),combs(bestcomb,:));
%         deleteme=[deleteme,vec(remove)];
%     end
% end
% bs1(deleteme)=[];
% be1(deleteme)=[];
% % toc
% end
% 
% 
% 
% 
