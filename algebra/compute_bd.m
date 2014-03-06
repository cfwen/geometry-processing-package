function bd = compute_bd(face)
% currently, do not consider multiple boundary
[am,amd] = compute_adjacency_matrix(face);
md = am - (amd>0)*2;
[I,~,~] = find(md == -1);
[~,Ii] = sort(I);
bd = zeros(size(I));
k = 1;
for i = 1:size(I)
    bd(i) = I(k);
    k = Ii(k);
end
