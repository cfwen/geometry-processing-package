function [cp,ri,val,m] = sparse_to_csc(A)
[m,n] = size(A); 
nz = nnz(A); 

[I,J,V] = find(A);
ri = zeros(nz,1);
val = zeros(nz,1);
cp = zeros(n+1,1);

for i = 1:nz
    cp(J(i)+1) = cp(J(i)+1)+1;
end
cp = cumsum(cp);

for i=1:nz
    val(cp(J(i))+1) = V(i);
    ri(cp(J(i))+1) = I(i);
    cp(J(i)) = cp(J(i))+1;
end
for i = m:-1:1
    cp(i+1) = cp(i);
end
cp(1) = 0;
cp = cp+1;
