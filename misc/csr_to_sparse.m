%% csr to sparse 
% Convert CSR (Compressed Sparse Row) format to sparse matrix.
% 
% This is inverse function of sparse_to_csr. Note that if ncols is not
% given and last cols of matrix are all zeros, then sparse matrix may not
% have same size with CSR format matrix, since we take the max col index
% used in ci as the cols of matrix.
%
%% Syntax
%   A = csr_to_sparse(rp,ci,val)
%   A = csr_to_sparse(rp,ci,val,ncols)
%
%% Description
% 
%  rp : double array, (nrows+1) x 1, index of start of each row, rp(nrows+1) indicates ending
%  ci : double array, nnz x 1, column indices of each nonzero element
%  val: double array, nnz x 1, value of each nonzero element
%  ncols: double scalar, optional, cols of sparse matrix A, no need to input nrows,
%         since nrows = length(rp)-1. If not given, ncols will be computed
%         as the max index in ci.
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

function A = csr_to_sparse(rp,ci,val,ncols)
nrows = length(rp)-1;
I = zeros(length(ci),1);
for i = 1:nrows
    I(rp(i):rp(i+1)-1) = i;
end
if ~exist('ncols','var')
   ncols = max(ci);
end
A = sparse(I,ci,val,nrows,ncols);
