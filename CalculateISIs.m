function isi = CalculateISIs(t,ic)
isi=[];
for i=1:size(ic,2)
    diffs = diff(sort(t(ic(3,i):ic(4,i))));
    isi = [isi,diffs];
end

end