function [face_new,vertex_new,father] = clean_mesh(face,vertex)

% remove unreferenced vertex
father = unique(face);
index = zeros(max(father),1);
index(father) = (1:size(father,1));
face_new = index(face);
vertex_new = vertex(father,:);