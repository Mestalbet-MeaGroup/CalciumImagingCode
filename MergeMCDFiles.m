function [t1,ic1]=MergeMCDFiles(tCell,icCell)
% Function returns merged t,indexchannels.
% Input:
% tCell = cell array of t vectors (in samples, 12khZ)
% icCell = cell array of ic matrix
% Output:
% Unified t,ic

num2combine = size(icCell,2);
vector = [];
for i=1:num2combine
    vector=[vector,icCell{i}(1,:)];
end
Uvector=unique(vector);
Freq=hist(vector,Uvector);
vector = Uvector(Freq==num2combine);

for i=1:num2combine
    removeme = icCell{i}(1,~ismember(icCell{i}(1,:),vector));
    t1=tCell{i};
    ic1=icCell{i};
    for ii=1:numel(removeme)
        [t1,ic1]=removeNeuronsWithoutPrompt(t1,ic1,[removeme(ii);1]);
    end
    tSub{i}=t1;
    icSub{i}=ic1;
end

[t1,ic1]=InsertSortChannelOneAfterAnother(tSub{1},icSub{1},tSub{2},icSub{2});

if num2combine>3
    for i=3:num2combine
        [t1,ic1]=InsertSortChannelOneAfterAnother(t1,ic1,tSub{i},icSub{i});
    end
end
end

%
%
% t{1}=t1;
% t{2}=t2;
% t{3}=t3;
% t{4}=t4;
% for i=1:4
%     bs(i)=max(t{i});
% end
