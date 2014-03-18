function uv = rect_harmonic_map(face,vertex,corner)
nv = size(vertex,1);
bd = compute_bd(face);
nbd = size(bd,1);

i = find(bd==corner(1),1,'first');
bd = bd([i:end,1:i]);
corner = corner([1:end,1]);

ck = zeros(size(corner));
k = 1;
for i = 1:length(bd)
    if(bd(i) == corner(k))
        ck(k) = i;
        k = k+1;
    end
end
uvbd = zeros(nbd,2);
uvbd(ck(1):ck(2),1) = linspace(0,1,ck(2)-ck(1)+1)';
uvbd(ck(1):ck(2),2) = 0;
uvbd(ck(2):ck(3),1) = 1;
uvbd(ck(2):ck(3),2) = linspace(0,1,ck(3)-ck(2)+1)';
uvbd(ck(3):ck(4),1) = linspace(1,0,ck(4)-ck(3)+1)';
uvbd(ck(3):ck(4),2) = 1;
uvbd(ck(4):ck(4),1) = 0;
uvbd(ck(4):ck(5),2) = linspace(1,0,ck(5)-ck(4)+1)';

uvbd(end,:) = [];    
bd(end) = [];
uv = zeros(nv,2);
uv(bd,:) = uvbd;
in = true(nv,1);
in(bd) = false;
A = laplace_beltrami(face,vertex);
Ain = A(in,in);
rhs = -A(in,bd)*uvbd;
uvin = Ain\rhs;
uv(in,:) = uvin;