function [tWell,icWell] = OrganizeTICintoWells(t,ic);
% Function Recieves t,ic from a 9-well 256 MEA. Sorts this into the
% individual wells. 
[chm,~] = channelmap9well();
for i=1:size(chm,3)
    channels=chm(:,:,i);
    channels = channels(:);
    channels(isnan(channels))=[];
    ch = intersect(ic(1,:),channels);
    ic1 =[];
    for j=1:size(ch)
        ic1=[ic1,ic(:,(ic(1,:)==ch(j)))];
    end
    %     [~,b]=sort(ic1(3,:));
    %     ic1= ic1(:,b);
    temp=[];
    newT=[];
    for k=1:size(ic1,2);
        temp = t(ic1(3,k):ic1(4,k));
        newT = [newT,temp];
    end
    ic2=[];
    ic2(3,1) = find(newT==t(ic1(3,1)),1,'First');
    indx = find(newT==t(ic1(4,1)));
    ic2(4,1) = indx(find(indx>ic2(3,1),1,'First'));
    for k=2:size(ic1,2)
        id = find(newT==t(ic1(3,k)));
        ic2(3,k) = id(find(id>ic2(4,k-1),1,'First'));
        indx = find(newT==t(ic1(4,k)));
        ic2(4,k) = indx(find(indx>ic2(3,k),1,'First'));
    end
    ic2(1,:)=ic1(1,:);
    ic2(2,:)=ic1(2,:);
    tWell{i}=newT;
    icWell{i}=ic2;
end

% for i=1:size(icWell,2)
%     [~,SumFirings]=FindNeuronFrequency(t,icWell{i},25,1);
%     figure; plot(SumFirings);
% end
end