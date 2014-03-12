function [edge,eif] = compute_edge(face)
[am,amd] = compute_adjacency_matrix(face);
[I,J,~] = find(am);
ind = I<J;
edge = [I(ind),J(ind)];
[~,~,V] = find(amd-xor(amd,am));
[~,~,V2] = find((amd-xor(amd,am))');
eif = [V(ind),V2(ind)];
