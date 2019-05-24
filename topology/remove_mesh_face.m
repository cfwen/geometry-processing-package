%% remove mesh face
% Remove face from mesh
%
%% Syntax
%   [face_new,vertex_new,father] = remove_mesh_face(face,vertex,index)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh, there may have unreferenced
%          vertex
%  index : double array, n x 1, index of face to be removed
% 
%  face_new  : double array, nf x 3, connectivity of new mesh after clean
%  vertex_new: double array, nv' x 3, vertex of new mesh. vertex number may
%              less than original mesh
%  father    : double array, nv' x 1, father indicates the vertex on original
%              mesh that new vertex comes from.
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2019/05/24
% 
%  Copyright 2019

function [face_new,vertex_new,father] = remove_mesh_face(face,vertex,index)
ind = false(size(face,1),1);
ind(index) = true;
[face_new,vertex_new,father] = clean_mesh(face(~ind,:),vertex);
