function [face_s, vertex_s] = slice_mesh(face,vertex,edge,hec,heifc)
% hec, heifc  denotes half edge of loop

nv = size(vertex,1);
ne = size(edge,1);
nf = size(face,1);

[he,heif] = compute_halfedge(face);

wdge_list = [];
for i=1:nv
	v=vertex(i);
	%construct wedge around v
	[vr,vc] = find(he == v);
	[vrc,vcc] = find(hec == v);
	wdge = [];
	if isempty(vr)
		wdge = unique(vr);
	else
		
	end
	wdge_list = [wdge_list;wdge]
end

vertex_s = unique(wdge_list);
face_s = face;

%%copy the loop boundary with a new set of vertex
vertex_s = zeros(nvert+nbound,3);
vertex_s(1:nvert,:) = vertex(:,:);
vertex_s((nvert+1):(nvert+nbound),:) = vertex(boundary(:),:);
face_s = face;

[he,heif] = compute_halfedge(face);
[am,amd] = compute_adjacency_matrix(face);


for ivert = 1:nbound
    adj_face = unique(heif(he(:,1)==boundary(ivert) | he(:,2)==boundary(ivert)))

end