%% sparse to csc 
% Convert sparse matrix to CSC (Compressed Sparse Column) format.
% 
% Access sparse matrix row by row may be slow in matlab, use CSC format to
% accelerate it, check dijkstra for typical usage.
%
%% Syntax
%   [cp,ri,val,nrows] = sparse_to_csc(A)
%
%% Description
%  A: sparse matrix, nrows x ncols
% 
%  cp : double array, (ncols+1) x 1, index of start of each column, cp(ncols+1) indicates ending
%  ri : double array, nnz x 1, row indices of each nonzero element
%  val: double array, nnz x 1, value of each nonzero element
%  nrows: double scalar, rows of sparse matrix A, no need to return ncols,
%         since ncols = length(cp)-1;
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/20
%  Revised: 2014/04/03 by Wen, simplify code and add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [cp,ri,val,nrows] = sparse_to_csc(A)
[nrows,ncols] = size(A); 
[ri,J,val] = find(A);
cp = accumarray(J+1,1);
cp = cumsum(cp)+1;
