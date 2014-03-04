function [am,amd] = compute_adjacency_matrix(face)
nf = size(face,1);
I = reshape(face',nf*3,1);
J = reshape(face(:,[2 3 1])',nf*3,1);
V = reshape(repmat(1:nf,[3,1]),nf*3,1);
amd = sparse(I,J,V);
V(:) = 1; 
am = sparse([I;J],[J;I],[V;V]);
end