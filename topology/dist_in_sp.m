function se = dist_in_sp(G_dist,e,vertex)
% compute distance of a loop sigma(e) which consists of two shortest paths
% from a base point x to the endpoints of e plus the edge e itself.

se = G_dist(e(1)) + G_dist(e(2)) + norm(vertex(e(1),:) - vertex(e(2),:));