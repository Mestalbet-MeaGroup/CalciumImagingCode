function imagesc_RGB(image_mat,cm, varargin)
%
% input:
% image_mat : vector with unique integer values within a certain range
% cm        : colormatrix (must have as many entries as image_mat)

noentry = 1;
PVPMOD(varargin);

image_mat = uint16(image_mat);
a = size(image_mat);
b = nan(a(1),a(2),3);
clear d;
for ii=1:a(1), 
    for jj=1:a(2), 
        if image_mat(ii,jj)==0
            b(ii,jj,:)=noentry;
        else
            d = cm(image_mat(ii,jj),:); 
            b(ii,jj,1)=d(1);
            b(ii,jj,2)=d(2); 
            b(ii,jj,3)=d(3); 
        end
    end, 
end
% cb = rgb2hsv(b);
image(b); 