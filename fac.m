function num = fac(i)
% FAC       - calculate factorial of an integer
% num=fac(i), i! (factorial of integer i)
% ***************************************************************
% *                                                             *
% * In the implementation of fac(i) we exploit two basic        *
% * properties of the : (colon) operator and the prod function: *
% *                                                             *
% *          1.    1:0 == [],  "j:k is empty if j>k"            *
% *                            documented in help colon         *
% *                                                             *
% *          2.    prod([])==1,  not documented                 *
% *                                                             *
% *                                                             *
% * Uses:                                                       *
% *      prod                                                   *
% *                                                             *
% * See Also:                                                   *
% *          polynom_mat                                        *
% *                                                             *
% * History:                                                    *
% *         (1) now using prod                                  *
% *            MD, SG 6.12.1996, Jerusalem                      *
% *         (0) first Version                                   *
% *            SG 15.5.1996                                     * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************
%
%
%		

num=prod(1:i);



% ***************************************************************
% * Historical Section                                          *
% *                                                             *
% *                                                             *
% ***************************************************************


%
% Sonja's original implementation
%
%if i == 0 
% num = 1;
%else
% num	= 1;
% while i>=1
%  num=num*(i);
%  i=i-1;
% end
%end
