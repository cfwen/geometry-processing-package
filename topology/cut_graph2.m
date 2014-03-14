function ee = cut_graph2(face)

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
