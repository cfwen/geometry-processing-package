%% cut graph 
% Compute a cut graph of mesh, such that surface becomes simply-connected
% if slice mesh along the cut-graph. There are two versions: if both face 
% and vertex provided, invoke version 1; if only face provided, invoke 
% version 2. Version 1 is exact implementation of algorithm 3 in book [1].
% Version 2 is translated from David Gu's C++ code of cut graph, which is
% much faster than version 1.
% 
% Though version 1 takes vertex into consideration, both algorithms do not
% generated optimal cut graph (shortest one). In fact this problem seems
% to be open until now.
%
%% Syntax
%   ee = cut_graph(face)
%   ee = cut_graph(face,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
% 
%  ee: double array, n x 2, edges in the cut graph, each row is an edge on 
%      mesh, may not be in consecutive order. ee's mainly purpose is been 
%      passed to slice_mesh, which will slice the mesh open along edges in
%      ee, to form a simply-connected surface
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/13
%  Revised: 2014/03/13 by Wen, implement another cut graph algorithm
%  Revised: 2014/03/17 by Wen, merge two cut graph algorithm
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function ee = cut_graph(face,vertex)
if nargin == 2
    [amf,dual_vertex] = compute_dual_graph(face,vertex);
    [edge,eif] = compute_edge(face);
    [I,J,~] = find(amf);

    % edge length of original mesh as weight
    el = zeros(size(I));
    
    for i=1:length(I)
        ei = face_intersect(face(I(i),:),face(J(i),:));
        el(i) = norm(vertex(ei(1),:)-vertex(ei(2),:));
    end
    graph = sparse(I,J,-el);
    if exist('graphminspantree')
        tree = graphminspantree(graph,'Method','Kruskal');
    else
        tree = minimum_spanning_tree(graph);
    end
    
    % edge length of dual mesh as weight
    % dual_el = sqrt(dot(dual_vertex(I,:)-dual_vertex(J,:),dual_vertex(I,:)-dual_vertex(J,:),2));
    % tree = graphminspantree(amf,'METHOD','Prim','Weights',dual_el);

    tree = tree+tree';
    [I,J,~] = find(tree);
    [~,ia] = setdiff(eif,[I,J],'rows');
    de = edge(ia,:);
    nv = size(vertex,1);
    G = sparse(de(:,1),de(:,2),ones(size(de,1),1),nv,nv);

elseif nargin == 1
    [am,amd] = compute_adjacency_matrix(face);
    nf = size(face,1);
    % use array to emulate queue
    queue = zeros(nf,1);
    queue(1) = 1;
    qs = 1; % point to queue start
    qe = 2; % point to queue end

    ft = false(nf,1);
    ft(1) = true;
    face4 = face(:,[1 2 3 1]);

    % translated from David Gu's cut graph algorithm
    % this algorithm will not take geometry into consideration, thus result is
    % not as visually good as cut_graph, but faster.
    while qe > qs
        fi = queue(qs);
        qs = qs+1;
        for i = 1:3
            he = face4(fi,[i i+1]);
            sf = amd(he(2),he(1));
            if sf       
                if ~ft(sf)
                    queue(qe) = sf;
                    qe = qe+1;
                    ft(sf) = true;
                    am(he(1),he(2)) = -1;
    %                 am(he(2),he(1)) = 0;
                end
            end
        end
    end
    am((am<0)') = 0;
    G = triu(am>0);
end
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
