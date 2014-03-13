G = sparse(ee(:,1),ee(:,2),ones(size(ee,1),1),nv,nv);
Gs = full(sum(G,2))+full(sum(G,1))';
i = find(Gs==3);
bd = [];
G2 = G+G';
vertex_new = [vertex;vertex(Gs==2,:);vertex(Gs==3,:);vertex(Gs==3,:)];
%%
while true
    j = find(G(i,:)==2,1);
    if isempty(j) 
        j = find(G(:,i)==1,1);
        if isempty(j)
            break;
        end
    end
    bd = [bd;i,j];
    G(i,j) = G(i,j) - 1;
    G(j,i) = G(j,i) - 1;
    i = j;
end