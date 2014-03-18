function fr = compute_face_ring(face)

[~,amd] = compute_adjacency_matrix(face);
nv = size(amd,1);
index = face(:,[3 1 2])+(face(:,[2,3 1])-1)*nv;
fr = full(amd(index));
fr(fr==0) = -1;
