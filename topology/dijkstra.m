%% dijkstra 
% dijkstra shortest path algorithm, to replace Matlab's built-in function 
% graphshortestpath Based on the algorithm description in wikipedia page[1],
% using a priority queue. Use array to emulate priority queue. This 
% implementation is about two times slower than Matlab's built-in function 
% graphshortestpath. Will be invoked when graphshortestpath is not available.
% 
% # http://en.wikipedia.org/wiki/Dijkstra's_algorithm
%
%% Syntax
%   [distance,path,previous] = dijkstra(graph,source)
%   [distance,path,previous] = dijkstra(graph,source,target)
%
%% Description
%  graph : sparse matrix, nv x nv, adjacency matrix of graph (or triangle 
%          mesh), elements are weights of adjacent path
%  source: integer scaler, source node of path. 
%  target: double array, n x 1, optional, target node to calculate distance. 
%          if not provided, will calculate path to all node.
% 
%  distance: double array, n x 1, distance from source node to all target
%            node
%  path    : cell array, n x 1, each cell is the path from source to node,
%            which is a double array
%  previous: double array, n x 1, predecessor nodes of all path, 
%            predecessor of source node is 0
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/21
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [distance,path,previous] = dijkstra(graph,source,target)
nv = size(graph,1); 
distance = inf*ones(nv,1); 
distance(source) = 0;

previous = zeros(nv,1);

if ~exist('target','var')
    target = (1:nv)';
end
path = cell(length(target),1);

[cp,ri,val] = sparse_to_csc(graph);

% use array to emulate heap (priority queue)
n = 1;
heap = zeros(nv,2);
heap(n,1) = source;
heap(source,2) = n;

while n
    u = heap(1);
    n = n-1;
    heap = bubbledown(heap,distance,n);    
    
    for ui = cp(u):cp(u+1)-1
        v = ri(ui);
        alt = distance(u) + val(ui);
        if alt < distance(v)
            distance(v) = alt;
            previous(v) = u;            
            n = n+1;           
            heap = bubbleup(heap,distance,n,v);
        end
    end
end
distance = distance(target);
for i = 1:length(target)
    v = target(i);    
    pi = v;
    while previous(v)
        v = previous(v);
        pi = [v;pi];        
    end
    path{i} = pi;
end
if length(target) == 1
    path = path{1};
end

function heap = bubbledown(heap,priority,n)
top = heap(n+1);
heap(1) = top;
heap(top,2) = 1;
index = 1;
while index*2 < n
    i = index*2;
    
    lc = heap(i);
    rc = heap(i+1);
    sc = lc;
    if priority(rc) < priority(lc)
        i = i+1;
        sc = rc;
    end
    if priority(top) > priority(sc)        
        heap(index) = sc;
        heap(sc,2) = index;
        heap(i) = top;
        heap(top,2) = i;
        index = i;        
    else
        break
    end        
end

function heap = bubbleup(heap,distance,n,v)
heap(n) = v;
heap(v,2) = n;
index = n;
k = heap(n);
while index > 1
    p = floor(index/2);
    tp = heap(p);
    if distance(tp) < distance(k)
        break
    else
        heap(p) = k;
        heap(k,2) = p;
        heap(index) = tp;
        heap(tp,2) = index;
        index = p;
    end
end
