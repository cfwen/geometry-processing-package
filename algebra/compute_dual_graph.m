%% compute dual graph 
% Dual graph of a triangle mesh, regarded as graph. 
% Each face in original mesh corresponds to a vertex in dual graph, vertex
% position be the centroid of the original face.
%
%% Syntax
%   [amf] = compute_dual_graph(face);
%   [amf,dual_vertex] = compute_dual_graph(face,vertex);
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
% 
%  amf: sparse matrix, nf x nf, connectivity of dual graph
%  dual_vertex: nf x 3, dual vertex in dual graph, if vertex is not
%               supplied, will return []
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/14
%  Revised: 2014/03/18 by Wen, add doc
%  Revised: 2014/03/23 by Wen, revise doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [amf,dual_vertex] = compute_dual_graph(face,vertex)
[edge,eif] = compute_edge(face);
nf = size(face,1);
% dual_vertex is the center of each triangle
if nargin == 2
    dual_vertex = (vertex(face(:,1),:)+vertex(face(:,2),:)+vertex(face(:,3),:))/3;
else
    dual_vertex = [];
end

ind = eif(:,1)>0 & eif(:,2)>0;
eif2 = eif(ind,:);
amf = sparse(eif2(:,1),eif2(:,2),ones(size(eif2,1),1),nf,nf);
amf = amf+amf';
