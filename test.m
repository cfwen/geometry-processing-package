ee = cut_graph(face,vertex);
nv = size(vertex,1);
G = sparse(ee(:,1),ee(:,2),ones(size(ee,1),1),nv,nv);
Gs = full(sum(G,2))+full(sum(G,1))';
branch = find(Gs>2);
nb = size(branch,1);
G2 = G+G';
% vertex_new = [vertex;vertex(Gs==2,:);vertex(Gs==3,:);vertex(Gs==3,:)];
%%
se = cell(nb,1);
i = branch(1);
si = i;
k = 1;
while true
    j = find(G2(i,:),1);
    if isempty(j)
        break;
    end
    si = [si;j];
    G2(i,j) = 0;
    G2(j,i) = 0;
    if Gs(j) > 2
        se{k} = si;
        si = j;
        k = k+1;
    end
    i = j;
end