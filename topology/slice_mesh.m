function [face_new,vertex_new,father] = slice_mesh(face,vertex,ee)
nv = size(vertex,1);
[~,amd] = compute_adjacency_matrix(face);
G = sparse(ee(:,1),ee(:,2),ones(size(ee,1),1),nv,nv);
G = G+G';

ev = unique(ee(:));
vre = compute_vertex_ring(face,ev,true);
face_new = face;
vertex2 = zeros(size(ee,1)*2,3);
father2 = zeros(size(ee,1)*2,1);
k = 1;
for i = 1:size(ev,1)
    evr = vre{i};
    for i0 = 1:length(evr)
        if G(evr(i0),ev(i))
            break;
        end
    end
    if evr(1) == evr(end) % interior point
        evr = evr([i0:end-1,1:i0]);
    else % boundary point
        evr = evr([i0:end,1:i0-1]);
    end
    for j = 2:length(evr)
        if amd(evr(j),ev(i))
            fij = face_new(fi,:)==ev(i);
            face_new(fi,fij) = nv+k;
        end
        if G(ev(i),evr(j))
            vertex2(k,:) = vertex(ev(i),:);
            father2(k) = ev(i);
            k = k+1;
        end
    end
end
vertex_new = [vertex;vertex2];
[face_new,vertex_new,father] = clean_mesh(face_new,vertex_new);
