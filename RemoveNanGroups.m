function [mat,index] = RemoveNanGroups(A)
A(logical(eye(size(A))))=nan;
index=~all(isnan(A),2);
mat = A(index,index);
mat(logical(eye(size(mat))))=1;
end