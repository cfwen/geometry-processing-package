%% compute_adjacency_matrix
% Compute adjacency matrix of triangle mesh, only connectivity needed.
% 
% Both undirected and directed adjacency matrix computed, stored with 
% sparse matrix. For undirected one (am), am(i,j) has value 2, indicating
% an adjacency between vertex i and vertex j. For directed one (amd),
% amd(i,j) stores a face index, indicating which face the halfedge (i,j) 
% lies in.
% 
% So am stores the information of edge, while amd stores the information
% of half edge.
% 
%% Syntax
%   [am,amd] = compute_adjacency_matrix(face);
% 
%% Description
%  face: double array, nf x 3, connectivity of mesh
% 
%  am : sparse matrix, nv x nv, undirected adjacency matrix
%  amd: sparse matrix, nv x nv, directed adjacency matrix
% 
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/14 by Wen, add doc
%  Revised: 2014/03/23 by Wen, remove example
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [am,amd] = compute_adjacency_matrix(face)
nf = size(face,1);
I = reshape(face',nf*3,1);
J = reshape(face(:,[2 3 1])',nf*3,1);
V = reshape(repmat(1:nf,[3,1]),nf*3,1);
amd = sparse(I,J,V);
% V(:) = 1; 
% am = sparse([I;J],[J;I],[V;V]);
am = spones(amd);
am = am+am';
