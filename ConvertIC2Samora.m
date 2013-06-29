function vec = ConvertIC2Samora(ic);
% Function to convert the t,ic format into Samora's format. Essentially
% replaces ic with vec (matrix of size (1,numel(t)) where for each spike
% time recorded in t, the appropriate channel ( ic(1,x) ) where this spike was recorded
% is placed in vec
% by: Noah Levine-Small, last modified: 23/10/12
for i=1:size(ic,2)
    vec(ic(3,i):ic(4,i))=ones(ic(4,i)-ic(3,i)+1,1).*ic(1,i);
end

end