function b=scalar(v)
% SCALAR       - TRUE if a variable is a scalar
% b=scalar(v), true if v is a 1 x 1 matrix
% ***************************************************************
% *                                                             *
% * History:                                                    *
% *         (0) first Version                                   *
% *            MD, 31.1.1997, Freiburg                          * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************
%
%
%
b= cols(v)==1 & rows(v)==1;