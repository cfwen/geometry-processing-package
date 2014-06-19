%% clean mesh 
% Clean mesh by removing unreferenced vertex, and renumber vertex index in
% face.
%
%% Syntax
%   [face_new,vertex_new,father] = clean_mesh(face,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh, there may have unreferenced
%          vertex
% 
%  face_new  : double array, nf x 3, connectivity of new mesh after clean
%  vertex_new: double array, nv' x 3, vertex of new mesh. vertex number may
%              less than original mesh
%  father    : double array, nv' x 1, father indicates the vertex on original
%              mesh that new vertex comes from.
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/17
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [face_new,vertex_new,father] = clean_mesh(face,vertex)
% remove unreferenced vertex
father = unique(face);
index = zeros(max(father),1);
index(father) = (1:size(father,1));
face_new = index(face);
vertex_new = vertex(father,:);
