%% disk_harmonic_map 
% Disk harmonic map of a 3D simply-connected surface.
%
%% Syntax
%   uv = disk_harmonic_map(face,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
% 
%  uv: double array, nv x 2, uv coordinates of vertex on 2D circle domain
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/18
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function uv = disk_harmonic_map(face,vertex)
nv = size(vertex,1);
bd = compute_bd(face);
nbd = size(bd,1);
t = (0:2*pi/nbd:2*pi)';
t(end) = [];
uvbd = [cos(t),sin(t)];
uv = zeros(nv,2);
uv(bd,:) = uvbd;
in = true(nv,1);
in(bd) = false;
A = laplace_beltrami(face,vertex);
Ain = A(in,in);
rhs = -A(in,bd)*uvbd;
uvin = Ain\rhs;
uv(in,:) = uvin;
