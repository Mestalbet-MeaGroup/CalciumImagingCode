function time = CalcTimeFromTriggers(fileName)
%Calculates the time stamp for calcium traces according to triggers from
%MCD file
[~,~,triggers]=GetTriggers(fileName);
triggers=triggers*10000;
tr=int64(triggers);
test1=diff(tr);
test1= (test1<300);
[a,b]=initfin(test1');
b=b+1;
% a=a(1:end-1);
% b=b(1:end-1);
% 
% hold on;
% plot(tr(a),ones(size(a)),'*g');
% plot(tr(b),ones(size(b)),'*r');
% plot(tr,ones(size(tr)),'.k');

time = double(tr(a))./10000;
end