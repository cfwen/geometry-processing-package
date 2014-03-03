function A = laplace_beltrami(face,vertex)
[edge,eif] = compute_edge(face);
ne = size(edge,1);
ew = zeros(ne,1);
ind = eif(:,1)>0;
ev1 = sum(face(eif(ind,1),:),2) - sum(edge(ind,:),2);
ct1 = cot2(vertex(ev1,:),vertex(edge(ind,1),:),vertex(edge(ind,2),:));
ew(ind) = ew(ind) + ct1;
ind = eif(:,2)>0;
ev2 = sum(face(eif(ind,2),:),2) - sum(edge(ind,:),2);
ct2 = cot2(vertex(ev2,:),vertex(edge(ind,1),:),vertex(edge(ind,2),:));
ew(ind) = ew(ind) + ct2;
A = sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[ew;ew]);
sA = full(sum(A,2));
nv = size(vertex,1);
A = (A - sparse((1:nv)',(1:nv)',sA))/2;
end

function ct = cot2(pi,pj,pk)
a = sqrt(dot(pj-pk,pj-pk,2));
b = sqrt(dot(pk-pi,pk-pi,2));
c = sqrt(dot(pi-pj,pi-pj,2));
cs = (b.*b+c.*c-a.*a)./(2.*b.*c);
ss2 = 1-cs.*cs;
ss2(ss2<0) = 0;
ss2(ss2>1) = 1;
ss = sqrt(ss2);
ct = cs./ss;
end
