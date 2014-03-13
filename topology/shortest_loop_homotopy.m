function sloop = shortest_loop_homotopy(vertex,adm,loop)

nv = size(vertex,1);
nl = size(loop,1);

loop_dist = zeros(nv,1);
loop_cell = cell(nv,1);
%adm = compute_adjacency_matrix_dist(face,vertex);
for iv = 1:nv
    [dist, path,~] = graphshortestpath(adm,iv,loop, 'METHOD', 'Dijkstra');
	[C,I] = min(dist);
	l0 = cell2mat(path(I));
	l0_ = fliplr(l0);
	loop_w = [l0(1:end-1) loop l0_(1:end-1)];
	%calcuate loop length
    
    loop_dist(iv) = norm(vertex(loop_w)-vertex(circshift(loop_w, [0 1])));
	loop_cell(iv) = {loop_w};
end

%find the shortest loop
[~,I] = min(loop_dist);
sloop = cell2mat(loop_cell(I));

	