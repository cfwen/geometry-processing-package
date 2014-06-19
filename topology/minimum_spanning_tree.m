%% minimum spanning tree 
% Construct minimum spanning tree on the mesh. Replace Matlab's
% graphminspantree function.
% 
% Basically this is a classical implementation of minimum spanning tree 
% algorithm, using adjacency matrix. Speed is about 2(large mesh)-4(smaller mesh)
% times slower comparing with Matlab's built-in graphminspantree, which is
% implemented via mex function graphalgs.
% 
%% Syntax
%   [tree,previous] = minimum_spanning_tree(graph)
%   [tree,previous] = minimum_spanning_tree(graph,source)
%
%% Description
%  graph : sparse matrix, nv x nv, adjacency matrix of graph (or triangle 
%          mesh), elements are weights of adjacent path
%  source: integer scaler, optional, source node of spanning tree. If not
%          provided, will search for smallest node in the graph.
% 
%  tree: sparse matrix, nv x nv, minimum spanning tree, if there are k
%        nodes in the graph, then there are k+1 nonzero elements in tree.
%  previous: double array, n x 1, predecessor nodes of the minimal spanning
%            tree, predecessor of source node is 0
% 
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/21
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [tree,previous] = minimum_spanning_tree(graph,source)
if ~exist('source','var')
    [I,J] = find(graph);
    source = J(1);
end
nv = size(graph,1);
previous = nan(nv,1);
node = source;
rem = (1:nv)';
% rem(source) = [];
ind = false(nv,1);
ind(I) = true;
ind(source) = false;
rem(~ind) = [];
previous(source) = 0;
nvc = sum(ind);
TI = zeros(nvc,1);
TJ = zeros(nvc,1);
TV = zeros(nvc,1);
k = 1;
% most time is spent on accessing submatrix, overall speed is about two
% times slower than Matlab's build-in function graphminspantree. For smaller
% graph, it's even slower, say, four times.
while ~isempty(rem)
    [I,J,V] = find(graph(node,rem)); % time consuming, need to improve
    [v,ind] = min(V);
    i = node(I(ind));
    j = rem(J(ind));
    TI(k) = i;
    TJ(k) = j;
    TV(k) = v;    
    k = k+1;
    previous(j) = i;
%     node(k) = j;
    node = [node;j];
    rem(J(ind)) = [];
end
tree = sparse(TI,TJ,TV,nv,nv);
tree = tril(tree+tree');
