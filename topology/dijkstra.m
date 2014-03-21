function [distance,path,previous] = dijkstra(graph,source,target)
nv = size(graph,1); 
distance = inf*ones(nv,1); 
distance(source) = 0;

previous = zeros(nv,1);

if ~exist('target','var')
    target = (1:nv)';
end
path = cell(length(target),1);

[cp,ri,val] = sparse_to_csc(graph);

% use array to emulate heap (priority queue)
n = 1;
heap = zeros(nv,2);
heap(n,1) = source;
heap(source,2) = n;

while n
    u = heap(1);
    n = n-1;
    heap = bubbledown(heap,distance,n);    
    
    for ui = cp(u):cp(u+1)-1
        v = ri(ui);
        alt = distance(u) + val(ui);
        if alt < distance(v)
            distance(v) = alt;
            previous(v) = u;            
            n = n+1;           
            heap = bubbleup(heap,distance,n,v);
        end
    end
end
distance = distance(target);
for i = 1:length(target)
    v = target(i);    
    pi = v;
    while previous(v)
        v = previous(v);
        pi = [v,pi];        
    end
    path{i} = pi;
end
function heap = bubbledown(heap,priority,n)
top = heap(n+1);
heap(1) = top;
heap(top,2) = 1;
index = 1;
while index*2 < n
    i = index*2;
    
    lc = heap(i);
    rc = heap(i+1);
    sc = lc;
    if priority(rc) < priority(lc)
        i = i+1;
        sc = rc;
    end
    if priority(top) > priority(sc)        
        heap(index) = sc;
        heap(sc,2) = index;
        heap(i) = top;
        heap(top,2) = i;
        index = i;        
    else
        break
    end        
end

function heap = bubbleup(heap,distance,n,v)
heap(n) = v;
heap(v,2) = n;
index = n;
k = heap(n);
while index > 1
    p = floor(index/2);
    tp = heap(p);
    if distance(tp) < distance(k)
        break
    else
        heap(p) = k;
        heap(k,2) = p;
        heap(index) = tp;
        heap(tp,2) = index;
        index = p;
    end
end
