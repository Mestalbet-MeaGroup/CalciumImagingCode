function f=savgol(w,M,ld)
% SAVGOL          - returns Savitzky-Golay filter coefficients
% f=savgol(w,M,ld), returns Savitzky-Golay filter
% ***************************************************************
% *                                                             *
% * Savitzky-Golay filter [1] to be convolved with data arrays  *
% * for smoothing (ld=0) or the computation of derivatives      *
% * (ld>0).                                                     *
% *                                                             *
% * Usage:                                                      *
% *       w,  filter width. Currently only symmetrical filters  *
% *           are supported: w elements to the left and w to    *
% *           the right, resulting in a total width of 2*w+1.   *
% *       M,  order of the polynomial                           *
% *       ld, ldth derivative:                                  *
% *                             0 smoothing filter              *
% *                             1: first derivative filter      *
% *                             2: second derivative filter     *
% *		                ....                            *
% *                                                             *
% *	  f,  filter length(f)==2*w+1                           *
% *                                                             *
% *                                                             *
% * Uses:                                                       *
% *          polyom_mat(), fac()                                *
% * See Also:                                                   *
% *          savgol_core()                                      *
% *                                                             *
% * Literature:                                                 *
% *            [1] Numerical Recipies, p.650ff                  *
% *                                                             *
% * History:                                                    *
% *         (3) variable tmp removed by using part              *
% *            MD, 16.1.1997, Freiburg                          *
% *         (2) comments improved                               *
% *            MD, 16.1.1997, Freiburg                          *
% *         (1) transpose of mat exchanged, polynom_mat         *
% *             now returns filters in rows.                    *
% *            MD 20.12.96, Freiburg,                           *
% *         (0) first Version                                   *
% *            SG 15.5.96, Jerusalem                            *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************
%
%
%

mat = polynom_mat(w,M);
f   = part((inv(mat*mat'))*mat,ld+1,':')*fac(ld);


% ***************************************************************
% * Historical Section                                          *
% *                                                             *
% *                                                             *
% ***************************************************************


%
% version without part
%
% mat = polynom_mat(w,M);
% tmp = (inv(mat*mat'))*mat;
% f   = tmp(ld+1,:)*fac(ld);