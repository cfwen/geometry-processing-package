function hb = compute_homology_basis(face,vertex)
ee = cut_graph(face,vertex);
nv = size(vertex,1);
G = sparse(ee(:,1),ee(:,2),ones(size(ee,1),1),nv,nv);
G = G+G';

if exist('graphminspantree')
    [tree,pred] = graphminspantree(G,'METHOD','Kruskal');
else
    [tree,pred] = minimum_spanning_tree(G);
end
v = find(pred==0);
[I,J,~] = find(tree+tree');
eh = setdiff(ee,[I,J],'rows');
hb = cell(size(eh,1),1);
for i = 1:size(eh,1)
    p1 = trace_path(pred,eh(i,1),v);
    p2 = trace_path(pred,eh(i,2),v);
    loop = [flipud(p1);eh(i,1);eh(i,2);p2];
    hb{i} = prune_path(loop);
end

function path = trace_path(pred,v,root)
path = [];
while true
    path = [path;pred(v)];
    v = pred(v);
    if v == root
        break;
    end
end

function path_new = prune_path(path)
ind = path ~= flipud(path);
i = find(ind,1)-1;
path_new = path(i:end-i+1);
