function [distance,previous] = dijkstra2(graph,source)
nv = size(graph,1); 
distance = inf*ones(nv,1); 
distance(source) = 0;
previous = zeros(nv,1);

heap = BinaryHeap(nv);
for i = 1:nv    
    heap = heap.add(i,distance(i));
end
while heap.sz
    [heap,u,p] = heap.remove();
    [~,J,V] = find(graph(u,:));
    for i = 1:length(J)
        v = J(i);
        alt = distance(u) + V(i);
        if alt < distance(v)
            distance(v) = alt;
            previous(v) = u;
            heap = heap.decrease_prioirty(v,alt);
        end
    end
end
