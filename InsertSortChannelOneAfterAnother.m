function [newT,newIndexchannel]=InsertSortChannelOneAfterAnother(t1,ic1,t2,ic2);
%function [newT,newIndexchannel]=InsertSortChannelOneAfterAnother(t1,indexchannel1,t2,indexchannel2);
%a fucntion that puts one sort channel right after another in time.

t2=t2-min(t2)+max(t1);
[newT,newIndexchannel]=InsertSortChannel(t1,ic1,t2,ic2);
