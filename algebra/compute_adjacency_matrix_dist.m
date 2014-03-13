function [amd] = compute_adjacency_matrix_dist(face,vertex)
nf = size(face,1);
I = reshape(face',nf*3,1);
J = reshape(face(:,[2 3 1])',nf*3,1);
D = vertex(I,:) - vertex(J,:);
V = zeros(nf*3,1);
for i = 1:nf*3
    V(i) = norm(D(i,:));
end
amd = sparse([I;J],[J;I],[V;V]);
%amd = sparse(I,J,V);

% get dulplicate added pair
V(:) = 1; 
am = sparse([I;J],[J;I],[V;V]);
am(am==0) = 1;

amd = amd./am;