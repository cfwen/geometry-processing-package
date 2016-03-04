%% compute_vertex_face_ring 
% Compute one-ring neighbor faces of given vertex or all vertex, with or 
% without ccw order. Default is no order, based on vertex_ring
%
%% Syntax
%   vfr = compute_vertex_face_ring(face)
%   vfr = compute_vertex_face_ring(face,vc)
%   vfr = compute_vertex_face_ring(face,vc,ordered)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
%  vc  : double array, n x 1 or 1 x n, vertex collection, can be empty, 
%        which equivalent to all vertex.
%  ordered: bool, scaler, indicate if ccw order needed.
% 
%  vfr: cell array, nv x 1, each cell is one ring neighbor face, which is
%      a double array
%
%% Example
%   % compute one ring of all vertex, without order
%   vfr = compute_vertex_face_ring(face)
% 
%   % compute one ring of vertex 1:100, without ccw order
%   vfr = compute_vertex_face_ring(face,1:100,false)
%
%   % compute one ring of vertex 1:100, with ccw order
%   vfr = compute_vertex_face_ring(face,1:100,true)
% 
%   % compute one ring of all vertex, with ccw order (may be slow)
%   vfr = compute_vertex_face_ring(face,[],true)
% 
%   % same with last one
%   vfr = compute_vertex_face_ring(face,1:nv,true)
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/28
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function vfr = compute_vertex_face_ring(face,vc,ordered)
nv = max(max(face));
if nargin == 1
    ordered = false;
	vc = (1:nv)';
elseif nargin == 2
    ordered = false;
end
if isempty(vc)
    vc = (1:nv)';
end
vr = compute_vertex_ring(face,[],vc,ordered);
[he,heif] = compute_halfedge(face);
eifs = sparse(he(:,1),he(:,2),heif);
vfr = arrayfun(@(i) full(eifs(vr{i}+nv*(vc(i)-1))),(1:length(vc))','UniformOutput',false);
vfr = cellfun(@(vi) vi(vi>0),vfr,'UniformOutput',false);
