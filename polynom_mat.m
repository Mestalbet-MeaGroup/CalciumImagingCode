function v=polynom_mat(w,m)
% POLYNOM         - creates a matrix necessary in the savgol routine
% v=polynom_mat(w,m), mtrx i^j, intgrs iE[w(1),w(2)], jE[0,M]
% ***************************************************************
% *                                                             *
% * Usage:                                                      *
% *        Creates a (m+1)x(-w(1)+w(2)+1) matrix                *
% *                                                             *
% *               vij=i^j, where                                *
% *                                                             *
% *               i=w(1),w(1)+1, ..,0, ..,w(2)-1,w(2)           *
% *          and  j=0,1,2,...,m  .                              *
% *        This matrix is used in the computation of the filter *
% *        coefficients of the Savitzky-Golay Filter.           *
% *                                                             *
% *          w, row or col vector of length 2. number of data   *
% *             points taken into account to the left( w(1))    *
% *             and to the right (w(2)). If w a scalar the same *  
% *             value is used on both sides. Note, usually      *
% *             w(1)<0 to take into account data to the left of *
% *             i==0.                                           *
% *          m,   order of the polynomial                       *
% *                                                             *
% *                                                             *
% * See Also:                                                   *
% *          savgol, fac                                        *
% *                                                             *
% * History:                                                    *
% *         (1) now using prod                                  *
% *            MD, SG 6.12.1996, Jerusalem                      *
% *         (0) first Version                                   *
% *            SG 12.5.1996                                     * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************
%
%
%		


if scalar(w)
 w=[-w,w];
end

v=repmat(w(1):1:w(2),m+1,1).^repmat((0:m)',1,-w(1)+w(2)+1);




% ***************************************************************
% * Historical Section                                          *
% *                                                             *
% *                                                             *
% ***************************************************************

%
% Sonja's original implementation:  tmp_mat = polynom_mat(w,M)
%
%tmp_vec		= (-w:1:w);
%tmp_mat		= ones(2*w+1,M+1);
%
%j=1;
%for i=0:M
% tmp_mat(:,j)	= tmp_vec(:).^i ;
% j=j+1;
%end


