function ee = cut_graph(face,vertex)

[amf,dual_vertex] = compute_dual_graph(face,vertex);
[I,J,~] = find(amf);
el = sqrt(dot(dual_vertex(I,:)-dual_vertex(J,:),dual_vertex(I,:)-dual_vertex(J,:),2));
[tree, pred] = graphminspantree(amf,'METHOD','Kruskal','Weights',el);
tree = tree+tree';
[I,J,~] = find(tree);
[edge,eif] = compute_edge(face);
[~,ia] = setdiff(eif,[I,J],'rows');
de = edge(ia,:);
nv = size(vertex,1);
G = sparse(de(:,1),de(:,2),ones(size(de,1),1),nv,nv);

% prune the cut graph
while true
    Gs = full(sum(G,2))+full(sum(G,1))';    
    ind =  Gs == 1;
    if sum(ind) ==0
        break;
    end
    G(ind,:) = 0;
    G(:,ind) = 0;
end

[I,J,~] = find(G);
ee = [I,J];