%% sparse to csr
% Convert sparse matrix to csc (Compressed Sparse Row) format.
% 
% Access sparse matrix row by row (or col by col) may be slow in Matlab, 
% use CSR format to accelerate it. CSC format is recommended, since Matlab
% stored data in column-first order.
%
%% Syntax
%   [rp,ci,val,ncols] = sparse_to_csr(A)
%
%% Description
%  A: sparse matrix, mrows x ncols
% 
%  rp : double array, (nrows+1) x 1, index of start of each row, cp(nrows+1) indicates ending
%  ci : double array, nnz x 1, column indices of each nonzero element
%  val: double array, nnz x 1, value of each nonzero element
%  ncols: double scalar, columns of sparse matrix A, no need to return nrows,
%         since nrows = length(rp)-1;
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/20
%  Revised: 2014/04/03 by Wen, simplify code and add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [rp,ci,val,ncols] = sparse_to_csr(A)
[nrows,ncols] = size(A); 
[ci,J,val] = find(A');
rp = accumarray(J+1,1);
rp = cumsum(rp)+1;
