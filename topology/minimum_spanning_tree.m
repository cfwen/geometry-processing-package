function [tree,previous] = minimum_spanning_tree(graph,source)
if ~exist('source','var')
    source = 1;
end
nv = size(graph,1);
previous = zeros(nv,1);
node = source;
rem = (1:nv)';
rem(source) = [];
TI = zeros(nv-1,1);
TJ = zeros(nv-1,1);
TV = zeros(nv-1,1);
k = 1;
% most time is spent on accessing submatrix, overall speed is about two
% times slower than Matlab's build-in function graphminspantree. For smaller
% graph, it's even slower, say, four times.
while ~isempty(rem)
    [I,J,V] = find(graph(node,rem)); % time consuming, need to improve
    [v,ind] = min(V);
    i = node(I(ind));
    j = rem(J(ind));
    TI(k) = i;
    TJ(k) = j;
    TV(k) = v;    
    k = k+1;
    previous(j) = i;
%     node(k) = j;
    node = [node;j];
    rem(J(ind)) = [];
end
tree = sparse(TI,TJ,TV,nv,nv);
tree = tril(tree+tree');
