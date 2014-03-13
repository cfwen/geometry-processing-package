function [hb] = greedy_homotopy_basis(face,vertex,edge,bi)
% greedy_homotopy_basis(face,vertex,i) compute a homotopy
% basis of a high genus surface S = (face,vertex), at a basis point bi;
nv = size(vertex,1);
ne = size(edge,1);
nf = size(face,1);
dt = TriRep(face,vertex(:,1),vertex(:,2),vertex(:,3));

el = zeros(ne,1);
for i = 1:ne
    be = edge(i,1:2);
    el(i) = norm(vertex(be(1),:) - vertex(be(2),:));
end
% G is adjacency matrix constructed from the triangle mesh, with weight the
% edge length.
G = sparse(edge(:,1),edge(:,2),el,nv,nv,ne);
G = (G + G'); % G is undirected

% the shortest path in graph G, with source node bi, T = G_pred is a the tree
[G_dist, G_path, G_pred] = graphshortestpath(G, bi, 'METHOD', 'Dijkstra');

% for i = 1:nv
%     if i ~= bi
%         t = edgeAttachments(dt,G_pred(i),i);
%         s = t{:};
%         G(s(1),s(2)) = 0;
%         G(s(2),s(1)) = 0;
%     end
% end

% G_dual is the dual graph of G
[G_dual,~] = compute_dual_graph(face,vertex);
% G_dual_vertex = G_dual_vertex';
% [G_dual] = compute_dual_graph(face);


%% (G\T)* 
% dual graph G* that do not consist edge correspond to edge in T = G_pred
for i = 1:nv
    if i ~= bi
        t = edgeAttachments(dt,G_pred(i),i);
        s = t{:};
        G_dual(s(1),s(2)) = 0;
        G_dual(s(2),s(1)) = 0;
    end
end

%% T_dual is the maximum spanning tree of (G\T)*, where the weight of any
% edge e* is length(shortest_loop(e))
[I,J,value] = find(G_dual);
for i = 1:length(I)
    ei = face_intersect(face(I(i),:),face(J(i),:));
    value(i) = -dist_in_sp(G_dist,ei,vertex);
%     value(i) = -norm(G_dual_vertex(I(i),:) - G_dual_vertex(J(i),:));
end
G_dual_w = sparse(I,J,value,size(G_dual,1),size(G_dual,1));
[T_dual, T_pred] = graphminspantree(G_dual_w,'METHOD','Kruskal');


%% G2 is the graph, with edges neither in T nor are crossed by edges in T*
G2 = G;
for i = 1:length(G_pred)
    if i ~= bi
        p = G_pred(i);
        G2(p,i) = 0;
        G2(i,p) = 0;
    end
end
[I,J,value] = find(T_dual);
for i = 1:size(I,1)
    ei = face_intersect(face(I(i),:),face(J(i),:));
    G2(ei(1),ei(2)) = 0;
    G2(ei(2),ei(1)) = 0;
end

%% the greedy homotopy basis consists of all loops (e), where e is an edge 
%  of G2.
G2 = tril(G2);
[I,J,value] = find(G2);
hb = cell(size(I));
for i = 1:length(I)
    hb{i} = [G_path{I(i)},fliplr(G_path{J(i)})];
end

function e = face_intersect(f1,f2)
b = f1==f2(1);
e1 = f1(b);
b = f1==f2(2);
e2 = f1(b);
b = f1==f2(3);
e3 = f1(b);
e = [e1,e2,e3];