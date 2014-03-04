function [dist, path, pred] = shortestpath(edge,source,dest)
nv = max(edge(:));
ne = size(edge,1);

G = sparse(edge(:,1),edge(:,2),edge(:,3),nv,nv,ne);
G = (G + G');

[dist, path, pred] = graphshortestpath(G,source,dest);