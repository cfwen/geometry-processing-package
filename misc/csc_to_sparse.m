%% csc to sparse 
% Convert CSC (Compressed Sparse Column) format to sparse matrix.
% 
% This is inverse function of sparse_to_csc. Note that if nrows is not
% given and last rows of matrix are all zeros, then sparse matrix may not
% have same size with CSC format matrix, since we take the max row index
% used in ri as the rows of matrix.
%
%% Syntax
%   A = csc_to_sparse(cp,ri,val)
%   A = csc_to_sparse(cp,ri,val,nrows)
%
%% Description
% 
%  cp : double array, (ncols+1) x 1, index of start of each column, cp(ncols+1) indicates ending
%  ri : double array, nnz x 1, row indices of each nonzero element
%  val: double array, nnz x 1, value of each nonzero element
%  nrows: double scalar, optional, rows of sparse matrix A, no need to input ncols,
%         since ncols = length(cp)-1. If not given, nrows will be computed
%         as the max index in ri.
% 
%  A: sparse matrix, m x n
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/04/03
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function A = csc_to_sparse(cp,ri,val,nrows)
ncols = length(cp)-1;
J = zeros(length(ri),1);
for i = 1:ncols
    J(cp(i):cp(i+1)-1) = i;
end
if ~exist('nrows','var')
   nrows = max(ri);
end
A = sparse(ri,J,val,nrows,ncols);
