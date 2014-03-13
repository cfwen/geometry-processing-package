function ee = cut_graph(face,vertex)

[amf,dual_vertex] = compute_dual_graph(face,vertex);
[edge,eif] = compute_edge(face);
[I,J,~] = find(amf);

% edge length of original mesh as weight
el = zeros(size(I));
for i=1:length(I)
    ei = face_intersect(face(I(i),:),face(J(i),:));
    el(i) = norm(vertex(ei(1),:)-vertex(ei(2),:));
end
tree = graphminspantree(amf,'METHOD','Prim','Weights',max(el)-el);

% edge length of dual mesh as weight
% dual_el = sqrt(dot(dual_vertex(I,:)-dual_vertex(J,:),dual_vertex(I,:)-dual_vertex(J,:),2));
% tree = graphminspantree(amf,'METHOD','Prim','Weights',dual_el);

tree = tree+tree';
[I,J,~] = find(tree);
[~,ia] = setdiff(eif,[I,J],'rows');
de = edge(ia,:);
nv = size(vertex,1);
G = sparse(de(:,1),de(:,2),ones(size(de,1),1),nv,nv);

% prune the graph cut
while true
    Gs = full(sum(G,2))+full(sum(G,1))';
    ind = (Gs == 1);
    if sum(ind) ==0
        break;
    end
    G(ind,:) = 0;
    G(:,ind) = 0;
end

[I,J,~] = find(G);
ee = [I,J];

function e = face_intersect(f1,f2)
b = f1==f2(1);
e1 = f1(b);
b = f1==f2(2);
e2 = f1(b);
b = f1==f2(3);
e3 = f1(b);
e = [e1,e2,e3];