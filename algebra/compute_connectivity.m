%% compute connectivity
% Transform connectivity face to other form to assistant easy access from
% face to vertex, or vise verse. 
% 
% * From face we can access vertex in each face. 
% * From vvif we can access face given two vertex of an edge. 
% * From nvif we can access the "next" vertex in a face and one vertex of
% the face, "next" in the sense of ccw order.
% * From pvif we can access the "previous" vertex in a face and one vertex of
% the face, "previous" in the sense of ccw order.
% 
% Basically, we implement halfedge structure in sparse matrix form. 
%
%% Syntax
%   [vvif,nvif,pvif] = compute_connectivity(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
% 
%  vvif: sparse matrix, nv x nv, element (i,j) indicates the face in which
%        edge (i,j) lies in
%  nvif: sparse matrix, nf x nv, element (i,j) indicates next vertex of
%        vertex j in face i
%  pvif: sparse matrix, nf x nv, element (i,j) indicates previous vertex of
%        vertex j in face i
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/06
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [vvif,nvif,pvif] = compute_connectivity(face)            
fi = face(:,1);
fj = face(:,2);
fk = face(:,3);
ff = (1:size(face,1))';
vvif = sparse([fi;fj;fk],[fj;fk;fi],[ff;ff;ff]);
nvif = sparse([ff;ff;ff],[fi;fj;fk],[fj;fk;fi]);
pvif = sparse([ff;ff;ff],[fj;fk;fi],[fi;fj;fk]);
