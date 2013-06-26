function h=savgol_core(f,d_t,w,M,n) 
% SAVGOL_CORE     - core routine for the calculation of Savitzky-Golay filters
% h=savgol_core(f,d_t,w,M,n), general Savitzky-Golay filtering
% ***************************************************************
% *                                                             *
% * Core computation of  Savitzky-Golay filtering.              *
% *                                                             *
% * Usage:                                                      *
% *       f,   signal to be smoothed or differentiated          *
% *            (row vector or matrix of rows of data)           *
% *       d_t, the delta_t of the equally spaced                *
% *            sampling points                                  * 
% *	  w    (one sided) width of the filter. Currently only  *
% *            symmetrical filters are supported                *
% *       M,   order of the Savitzky-Golay polynomial           *
% *       n,   order of the derivative (0 for smoothing)        *
% *       h,   filtered signal                                  *
% *              	length(h) == cols(f)-2*w                *
% *                                                             *
% * Uses:                                                       *
% *      savgol(), wrs()                                        *
% *                                                             *
% * See Also:                                                   *
% *	     cnv()                                              *
% ***************************************************************

% ***************************************************************
% *                                                             *
% * History:                                                    *
% *         (6) back to 19.11.96 implementation because now     *
% *             wrs by itself supports a matrix of rows of      *
% *             data.                                           *
% *            MD, 16.2.1997, Jerusalem                         *
% *         (5) hack for matrix(f)==1                           *
% *             It was found that OD's generalization is        *
% *             broken, this is temporarily fixed now by a for  *
% *             loop. We need parallel multiplication in 3d     *
% *             structures (here: on wrs level).                *
% *            MD, 2.2.1997, Freiburg                           *
% *         (4) comments improved                               *
% *            MD, 15.1.1997, Freiburg                          *
% *         (3) now using wrs                                   *
% *             Maybe we broke OD's generalization. It still    *
% *             works for row and column vectors, the result    *
% *             however, is always a row vector.                * 
% *            MD, SG 19.11.96, Jerusalem                       *
% *         (2)  slight clean up and support for matrixes       *
% *            OD 21.9.1996, Jerusalem                          *
% *         (1) various input formats fct conv2col added        *
% *            SG 30.6.1996                                     *
% *         (0) first Version                                   *
% *            SG 15.5.1996                                     * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************

% ***************************************************************
% * Examples:                                                   *
% *                                                             *
% *  >> d = [4 4 5 7 8; 14 14 13 11 10]                         *
% *  d =                                                        *
% *      4     4     5     7     8                              *
% *     14    14    13    11    10                              *
% *                                                             *
% *  >> savgol_core(d,1,1,1,0)                                  *
% *  ans =                                                      *
% *        4.3333    5.3333    6.6667                           *
% *       13.6667   12.6667   11.3333                           *
% *                                                             *
% * the coefficients for the smoothing polynomial used here     *
% *(first order, 3 data points) are:                            *
% *                                                             *
% *  >> savgol(1,1,0)                                           *
% *  ans =                                                      *
% *        0.3333  0.3333  0.3333                               *
% *                                                             *
% *                                                             *
% ***************************************************************
%
%
%	

h=wrs(f,savgol(w,M,n) )./(d_t^n);



% ***************************************************************
% * Historical Section                                          *
% *                                                             *
% *                                                             *
% ***************************************************************

%
% 2.2.97 implementation to allow for matrices of data
%
%s=savgol(w,M,n);
%for i=1:rows(f)                   % hack, to solve history (3) bug.
% h(i,:)=wrs(f(i,:),s)./(d_t^n); 
%end 


%
% 19.11.96 implementation requireing vector(f)==1
%
%h=wrs(f,savgol(w,M,n) )./(d_t^n);
%

