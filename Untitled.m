n = size(L,1);
v = rand(n,1);
v = v/norm(v);
for i = 1:20
    Bv = B*v;
    Lv = L*v;
    l = dot(v,Lv)/dot(v,Bv)
    x = (l*L-B)\v;
    v = x/norm(x);
    norm(l*L*v-B*v)
end