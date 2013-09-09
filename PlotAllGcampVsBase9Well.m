
for i=1:size(DataSet,1)
    PlotFR9Well(DataSet{i}.tBase,DataSet{i}.icBase,DataSet{i}.tGcamp,DataSet{i}.icGcamp);
    maximize(gcf);
    pos=findstr(DataSet{i}.Record,'\');
    pos=pos(end);
    export_fig([DataSet{i}.Record(pos+1:end) '_FR']);
    close all;
end