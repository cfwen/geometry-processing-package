%% slice_mesh 
% Slice mesh open along a collection of edges ee, which usually comes from 
% cut_graph(directly), or compute_greedy_homotopy_basis and
% compute_homology_basis (need to form edges from closed loops in basis).
% ee can form a single closed loops or multiple closed loops. 
% 
%% Syntax
%   [face_new,vertex_new,father] = slice_mesh(face,vertex,ee)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  ee    : double array, n x 2, a collection of edges, each row is an edge on 
%          mesh, may not be in consecutive order. 
% 
%  face_new  : double array, nf x 3, connectivity of new mesh after slice
%  vertex_new: double array, nv' x 3, vertex of new mesh, vertex number is
%              more than original mesh, since slice mesh will separate each
%              vertex on ee to two vertices or more.
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

function [face_new,vertex_new,father] = slice_mesh(face,vertex,ee)
nv = size(vertex,1);
[~,amd] = compute_adjacency_matrix(face);
G = sparse(ee(:,1),ee(:,2),ones(size(ee,1),1),nv,nv);
G = G+G';

ev = unique(ee(:));
vre = compute_vertex_ring(face,vertex,ev,true);
face_new = face;
vertex2 = zeros(size(ee,1)*2,3);
father2 = zeros(size(ee,1)*2,1);
k = 1;
for i = 1:size(ev,1)
    evr = vre{i};
    for i0 = 1:length(evr)
        if G(evr(i0),ev(i))
            break;
        end
    end
    if evr(1) == evr(end) % interior point
        evr = evr([i0:end-1,1:i0]);
    else % boundary point
        evr = evr([i0:end,1:i0-1]);
    end
    for j = 2:length(evr)
        fi = amd(evr(j),ev(i));
        if fi
            fij = face_new(fi,:)==ev(i);
            face_new(fi,fij) = nv+k;
        end
        if G(ev(i),evr(j))
            vertex2(k,:) = vertex(ev(i),:);
            father2(k) = ev(i);
            k = k+1;
        end
    end
end
vertex_new = [vertex;vertex2];
father = (1:nv)';
father = [father;father2];

fu = unique(face_new);
index = zeros(max(fu),1);
index(fu) = (1:size(fu,1));
face_new = index(face_new);
vertex_new = vertex_new(fu,:);
father = father(fu);