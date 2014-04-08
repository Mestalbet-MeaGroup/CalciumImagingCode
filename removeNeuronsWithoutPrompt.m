function [newT,newIndexchannel]=RemoveNeuronsWithoutPrompt(t,indexchannel,varargin);
%function [newT,newIndexchannel]=RemoveNeuronsWithoutPrompt(t,indexchannel,varargin);
% a function that removes neurons  from indexchannel.
%example:  [newT,newIndexchannel]=RemoveNeurons(t,indexchannel,[2;1],[2;3],[2;4]) -
%deletes neurons [2;3] and [2;4] and [2;1] in indexchannel.

for i=1:length(varargin)
    x(:,i)=varargin{i};
end


if isempty(varargin),
    error('not enough inputs');
end
%if ~isempty(find(x(1,:)>size(indexchannel,2))),
%    error('channel does not exist');
%end
if size(x,2)>length(indexchannel),
    error('too many inputs');
end

emptychannel=0;
for i=1:size(x,2),
    if isempty(find(indexchannel(1,:)==x(1,i) & indexchannel(2,:)==x(2,i)));
        fprintf(['[' num2str(x(1,i)) ';' num2str(x(2,i)) '], ']);
        emptychannel=1;
    end
end
if emptychannel==1,
    fprintf(' does not exist!');
    error('there are channels that do not exist!');
end


for i=1:size(x,2),
%    fprintf('removing neuron [%d;%d]\n',x(1,i),x(2,i));
    index=find(indexchannel(1,:)==x(1,i) & indexchannel(2,:)==x(2,i));
    %cut out a peace of t:
    cutT=t(indexchannel(3,index):indexchannel(4,index));
    if indexchannel(3,index)~=1,
        tBefore=t(1:indexchannel(3,index)-1);
    else
        tBefore=[];
    end
    if indexchannel(4,index)~=length(t),
        tAfter=t(indexchannel(4,index)+1:end);
    else
        tAfter=[];
    end
    t=[tBefore,tAfter];
    %update indexes:
    indexchannel(3,find(indexchannel(3,:)>indexchannel(3,index)))=indexchannel(3,find(indexchannel(3,:)>indexchannel(3,index)))-length(cutT);
    indexchannel(4,find(indexchannel(4,:)>indexchannel(4,index)))=indexchannel(4,find(indexchannel(4,:)>indexchannel(4,index)))-length(cutT);
end
%remove channels:
for i=1:size(x,2),
    indexes(i)=find(indexchannel(1,:)==x(1,i) & indexchannel(2,:)==x(2,i));
end
indexchannel(:,indexes)=[];

newT=t;
newIndexchannel=indexchannel;


