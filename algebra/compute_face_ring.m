%% compute face ring 
% Face ring of each face. For interior face, there are three faces
% attached: each halfedge (reversed direction) attaches a neighbor face.
% 
% For boundary face (with edge on the boundary), there is no face
% attached with the boundary edge, in such case, -1 is used.
% 
%% Syntax
%   fr = compute_face_ring(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
% 
%  fr: double array, nf x 3, face ring, each row is three faces attached
%      with three edges of the face, -1 indicates boundary edge
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/18
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function fr = compute_face_ring(face)
[~,amd] = compute_adjacency_matrix(face);
nv = size(amd,1);
index = face(:,[3 1 2])+(face(:,[2,3 1])-1)*nv;
fr = full(amd(index));
fr(fr==0) = -1;
