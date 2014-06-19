%% compute edge 
% Find edge of mesh, undirected. eif indicates the faces in which the edge
% lies in. For boundary edge, there is only one face attached, in such
% case, the other one is indicated with -1.
% 
% Use this function to replace edgeAttachments method of
% trianglulation/TriRep class.
%
%% Syntax
%   [edge,eif] = compute_edge(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
% 
%  edge: double array, ne x 2, undirected edge
%  eif : double array, ne x 2, each row indicates two faces in which the
%        edge lies in, -1 indicates a boundary edge
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/
%  Revised: 2014/03/18 by Wen, add doc
%  Revised: 2014/03/23 by Wen, revise doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [edge,eif] = compute_edge(face)
[am,amd] = compute_adjacency_matrix(face);
[I,J,~] = find(am);
ind = I<J;
edge = [I(ind),J(ind)];
[~,~,V] = find(amd-xor(amd,am));
[~,~,V2] = find((amd-xor(amd,am))');
eif = [V(ind),V2(ind)];
