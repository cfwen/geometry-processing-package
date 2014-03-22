function hb = compute_greedy_homotopy_basis(face,vertex,bi)
% greedy_homotopy_basis(face,vertex,i) compute a homotopy
% basis of a high genus surface S = (face,vertex), at a basis point bi;
nf = size(face,1);
nv = size(vertex,1);
[edge,eif] = compute_edge(face);
[am,amd] = compute_adjacency_matrix(face);

% G is adjacency matrix constructed from the triangle mesh, with weight the
% edge length.
[I,J] = find(am);
el = sqrt(dot(vertex(I,:)-vertex(J,:),vertex(I,:)-vertex(J,:),2));
G = sparse(I,J,el,nv,nv);
G = (G + G'); % G is undirected

% the shortest path in graph G, with source node bi, T = G_pred is a the tree
if exist('graphshortestpath')
    [dist,path,pred] = graphshortestpath(G,bi,'METHOD','Dijkstra');
else
    [dist,path,pred] = dijkstra(G,bi);
end
% we always use column array
dist = dist(:);
pred = pred(:);
% amf is the dual graph of G
amf = compute_dual_graph(face);

%% (G\T)* 
% dual graph G* that do not consist edge correspond to edge in T = pred
I = (1:nv)';
I(bi) = [];
J = pred(I);
% (I2,J2) and (J2,I2) are faces corresponding to edge (I,pred(I))
I2 = full(amd(I+(J-1)*nv));
J2 = full(amd(J+(I-1)*nv));
ind = (I2==0 | J2==0);
I2(ind) = [];
J2(ind) = [];
amf(I2+(J2-1)*nf) = 0;
amf(J2+(I2-1)*nf) = 0;

%% tree is the maximum spanning tree of (G\T)*, where the weight of any
% edge e* is length(shortest_loop(e))
[I,J] = find(amf);
ind = (eif(:,1)==-1 | eif(:,2)==-1);
eif(ind,:) = [];
edge(ind,:) = [];
F2E = sparse([eif(:,1);eif(:,2)],[eif(:,2);eif(:,1)],[edge(:,1),edge(:,2)],nf,nf);
ei = [F2E(I+(J-1)*nf),F2E(J+(I-1)*nf)];
dvi = vertex(ei(:,1),:)-vertex(ei(:,2),:);
V = -(dist(ei(:,1))+dist(ei(:,2))+sqrt(dot(dvi,dvi,2)));
amf_w = sparse(I,J,V,nf,nf);
if exist('graphminspantree')
    tree = graphminspantree(amf_w,'METHOD','Kruskal');
else
    tree = minimum_spanning_tree(amf_w);
end

%% G2 is the graph, with edges neither in T nor are crossed by edges in T*
G2 = G;
I = (1:nv)';
I(bi) = [];
J = pred(I);
% (I,J) are edges in T
G2(I+(J-1)*nv) = 0;
G2(J+(I-1)*nv) = 0;

[I,J] = find(tree);
% ei are edges in T*
ei = [F2E(I+(J-1)*nf),F2E(J+(I-1)*nf)];
index = [ei(:,1)+(ei(:,2)-1)*nv;ei(:,2)+(ei(:,1)-1)*nv];
G2(index) = 0;

%% the greedy homotopy basis consists of all loops (e), where e is an edge 
%  of G2.
G2 = tril(G2);
[I,J] = find(G2);
hb = cell(size(I));
for i = 1:length(I)
    pi = path{I(i)};
    pj = path{J(i)};
    hb{i} = [pi(:);flipud(pj(:))];
end
