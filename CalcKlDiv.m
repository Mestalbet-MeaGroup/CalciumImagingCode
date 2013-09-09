function kld = CalcKlDiv(val1,val2);

val1(isnan(val1))=[];
val2(isnan(val2))=[];
val = [val1,val2];
AllUnq=unique(val);


prob1 = ParseHistToProbs(AllUnq,val1);
prob2 = ParseHistToProbs(AllUnq,val2);
kld = kldiv(AllUnq,prob1+eps,prob2+eps ,'sym');

end
