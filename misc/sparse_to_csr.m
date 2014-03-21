function [rp,ci,val,n] = sparse_to_csr(A)
[m,n] = size(A); 
nz = nnz(A); 

[I,J,V] = find(A);
ci = zeros(nz,1);
val = zeros(nz,1);
rp = zeros(n+1,1);

for i = 1:nz
    rp(I(i)+1) = rp(I(i)+1)+1;
end
rp = cumsum(rp);

for i=1:nz
    val(rp(I(i))+1) = V(i);
    ci(rp(I(i))+1) = J(i);
    rp(I(i)) = rp(I(i))+1;
end
for i = m:-1:1
    rp(i+1) = rp(i);
end
rp(1) = 0;
rp = rp+1;
