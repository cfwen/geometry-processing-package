function sloop = shortest_loop_homotopy(face,vertex,loop)

nv = size(vertex,1);
dist = zeros(nv,1);
loops = cell(nv,1);
[am,amd] = compute_adjacency_matrix(face);
[I,J,~] = find(amd);
weight = sqrt(dot(vertex(I,:)-vertex(J,:),vertex(I,:)-vertex(J,:),2));
for i = 1:nv
    [dist, path,~] = graphshortestpath(amd,i,loop, 'METHOD', 'Dijkstra','Weight',weight);
	[C,I] = min(dist);
	pi = path{I}';
	lw = [pi(1:end-1);loop;pi(end:-1:2)];
	%calcuate loop length
    
    dist(iv) = norm(vertex(lw)-vertex(circshift(lw, [0 1])));
	loops{iv} = lw;
end

%find the shortest loop
[~,I] = min(dist);
sloop = loops{I};
