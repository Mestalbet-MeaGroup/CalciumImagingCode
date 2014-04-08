function [newT,newIndexchannel]=InsertSortChannel(t,indexchannel,t2,indexchannel2);
%function [newT,newIndexchannel]=InsertSortChannel(t,indexchannel,t2,indexchannel2);
%a function that adds a sort channel to another

%Feb 24, 2004 - nadav -improve InsertSortChannel, work with indexchannel of
%different sizes.

newT=t;
newIndexchannel=indexchannel;
for i=1:size(indexchannel2,2),
    NeuronIndex=find(indexchannel(1,:)==indexchannel2(1,i) & indexchannel(2,:)==indexchannel2(2,i));
    if isempty(NeuronIndex),    %new neuron
        [newT,newIndexchannel]=InsertNeuron(newT,newIndexchannel,t2(indexchannel2(3,i):indexchannel2(4,i)),indexchannel2(1:2,i));
    elseif size(NeuronIndex)==1,    %matching neuron in indexchannel
        [newT,newIndexchannel]=InsertNeuron(newT,newIndexchannel,t2(indexchannel2(3,i):indexchannel2(4,i)),[280;1]);
        [newT,newIndexchannel]=ReduceNeuronsWithoutPrompt(newT,newIndexchannel,indexchannel2(1:2,i),[280;1]);
    else
        error('source indexchannel has two same names !!');
    end
end
