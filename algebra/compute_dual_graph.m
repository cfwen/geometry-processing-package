%% compute_dual_graph 
%  compute dual graph
% 
%  The dual graph of a graph 
%
%% Syntax
%   [amf] = compute_dual_graph(face);
%   [amf,dual_vertex] = compute_dual_graph(face,vertex);
%
%% Description
%  
%
%% Example
%   [amf] = compute_dual_graph(face);
%   [amf,dual_vertex] = compute_dual_graph(face,vertex);
%
%% Contribution
%  Author : Wen Chengfeng
%  Created: yyyy/mm/dd
%  Revised: 2014/03/18 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function [amf,dual_vertex] = compute_dual_graph(face,vertex)

narginchk(1,2);
[~,eif] = compute_edge(face);
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
