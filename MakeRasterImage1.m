function m=MakeRasterImage1(t,indexchannel,Tscale,Tcenter,WindowRes,SpikeWidth); 
%function m=MakeRasterImage1(t,indexchannel,Tscale,Tcenter,WindowRes,SpikeWidth); 
%a function that builds image matrix m(NxMx3) from data.

%t -time vector of recordings.
%indexchannel - index it t of neurons
%Tscale - scale of time for plotting:
%Tscale=1            1/12000 sec
%Tscale=12000    1 sec
%Tscale=12000*60 1 min.  etc.
%Tcenter - center image in units of 1/12000 sec
%WindowRes - how many bins in window of size Tscale
%SpikeWidth is width of spike in units of WindowReS
%m has zero where there is a spike, and 1 otherwise

Tstart=Tcenter-0.5*Tscale;
Tend=Tcenter+0.5*Tscale;
Nneurons=size(indexchannel,2); %number of neurons
m=zeros(Nneurons,WindowRes);
%index=find(indexchannel(5,:)==1);
index=1:size(indexchannel,2);
for i=1:Nneurons,
    tNeuron=t(indexchannel(3,index(i)):indexchannel(4,index(i)));  %find t on neuron i
    tNeuron=tNeuron(find(tNeuron>Tstart & tNeuron<Tend));   %reduce t to required window
    m(i,:)=hist(tNeuron,linspace(Tstart,Tend,WindowRes));   %build image histogram
end
%thiken spike lines:
for j=1:SpikeWidth,
    m(:,j:end)=m(:,j:end)+m(:,1:end-j+1);
end
m(find(m>1))=1;
m=1-m;  %reverce image for black/white;
%color range out of t:
% if Tstart<Tmin,
%     m(:,find(linspace(Tstart,Tend,WindowRes)<Tmin))=0.7;
% elseif Tend>Tmax,
%     m(:,find(linspace(Tstart,Tend,WindowRes)>Tmax))=0.7;
% end    

%make RGB:
m(:,:,1)=m;
m(:,:,2)=m(:,:,1);
m(:,:,3)=m(:,:,1);

% figure;
% image(m);
% set(gca,'XTick',[1 WindowRes/2 WindowRes]);
% s{1}=num2str(Tcenter-0.5*Tscale);
% s{2}=num2str(Tcenter);
% s{3}=num2str(Tcenter+0.5*Tscale);
% set(gca,'XTickLabel',s);
% 
% set(gca,'YTick',1:Nneurons);
% for i=1:Nneurons,
%     s{i}=[num2str(indexchannel(1,index(i))),' ',num2str(indexchannel(2,index(i)))];
% end
% set(gca,'YTickLabel',s,'FontSize',6);
% 
% text(0,-50,[num2str(floor((Tcenter-0.5*Tscale)/12000/60/60)) ,':', num2str(floor(mod(Tcenter-0.5*Tscale,12000*60*60)/12000/60)),':',num2str(floor(mod(Tcenter-0.5*Tscale,12000*60)/12000)),':',num2str(mod(Tcenter-0.5*Tscale,12000))],'FontSize',25);
