%% rec_harmonic_map 
% Harmonic map of a 3D simply-connected surface to 2D unit square
%
%% Syntax
%   uv = rect_harmonic_map(face,vertex,corner)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  corner: double array, 4 x 1, four corners (index) on the mesh to be mapped to
%          corners of unit square
% 
%  uv: double array, nv x 2, uv coordinates of vertex on 2D unit square domain
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/18
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function uv = rect_harmonic_map(face,vertex,corner)
nv = size(vertex,1);
bd = compute_bd(face);
nbd = size(bd,1);

i = find(bd==corner(1),1,'first');
bd = bd([i:end,1:i]);
corner = corner([1:end,1],:);

ck = zeros(size(corner,1),1);
k = 1;
for i = 1:length(bd)
    if(bd(i) == corner(k))
        ck(k) = i;
        k = k+1;
    end
end

uvbd = zeros(nbd,2);
if size(corner,2) == 2 || size(corner,2) == 3    
    if size(corner,2) == 3
        zc = corner(:,2)+1i*corner(:,3);
    else
        zc = corner;
    end
    zbd = zeros(nbd,1);
    
    zbd(ck(1):ck(2)) = linspace(zc(1),zc(2),ck(2)-ck(1)+1);
    zbd(ck(2):ck(3)) = linspace(zc(2),zc(3),ck(3)-ck(2)+1);
    zbd(ck(3):ck(4)) = linspace(zc(3),zc(4),ck(4)-ck(3)+1);
    zbd(ck(4):ck(5)) = linspace(zc(4),zc(5),ck(5)-ck(4)+1);
    uvbd = [real(zbd),imag(zbd)];
else
    uvbd(ck(1):ck(2),1) = linspace(0,1,ck(2)-ck(1)+1)';
    uvbd(ck(1):ck(2),2) = 0;
    uvbd(ck(2):ck(3),1) = 1;
    uvbd(ck(2):ck(3),2) = linspace(0,1,ck(3)-ck(2)+1)';
    uvbd(ck(3):ck(4),1) = linspace(1,0,ck(4)-ck(3)+1)';
    uvbd(ck(3):ck(4),2) = 1;
    uvbd(ck(4):ck(5),1) = 0;
    uvbd(ck(4):ck(5),2) = linspace(1,0,ck(5)-ck(4)+1)';    
end
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
