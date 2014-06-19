%% compute bc
% Compute Beltrami coefficients mu of mapping from uv to vertex, where vertex 
% can be 2D or 3D.
% 
% mu from 2D to 2D is defined by the Beltrami equation:
% 
% \[ \frac{\partial{f}}{\partial{\bar{z}}} = \mu \frac{\partial{f}}{\partial{z}} \]
% 
% mu from 2D to 3D is defined by: 
% 
% \[ \mu = \frac{E-G +2iF}{E+G +2\sqrt{EG-F^2}} \]
% 
% where \( ds^2=Edx^2+2Fdxdy+Gdy^2 \) is metric.
%
%% Syntax
%   mu = compute_bc(face,uv,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  uv    : double array, nv x 2, uv coordinate of mesh
%  vertex: double array, nv x 2 or nv x 3, target surface coordinates
%
%  mu: complex array, nf x 1, beltrami coefficient on all faces
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/27
%  Revised: 2014/03/28 by Wen, add doc
%
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function mu = compute_bc(face,uv,vertex)
nf = size(face,1);
fa = face_area(face,uv);
Duv = (uv(face(:,[3 1 2]),:) - uv(face(:,[2 3 1]),:));
Duv(:,1) = Duv(:,1)./[fa;fa;fa]/2;
Duv(:,2) = Duv(:,2)./[fa;fa;fa]/2;

switch size(vertex,2)
    case 2
        z = complex(vertex(:,1), vertex(:,2));
        Dcz = sum(reshape((Duv(:,2)-1i*Duv(:,1)).*z(face,:),nf,3),2);
        Dzz = sum(reshape((Duv(:,2)+1i*Duv(:,1)).*z(face,:),nf,3),2);
        mu = Dcz./Dzz;
    case 3
        du = zeros(nf,3);
        du(:,1) = sum(reshape(Duv(:,2).*vertex(face,1),nf,3),2);
        du(:,2) = sum(reshape(Duv(:,2).*vertex(face,2),nf,3),2);
        du(:,3) = sum(reshape(Duv(:,2).*vertex(face,3),nf,3),2);
        dv = zeros(nf,3);
        dv(:,1) = sum(reshape(Duv(:,1).*vertex(face,1),nf,3),2);
        dv(:,2) = sum(reshape(Duv(:,1).*vertex(face,2),nf,3),2);
        dv(:,3) = sum(reshape(Duv(:,1).*vertex(face,3),nf,3),2);
        
        E = dot(du,du,2);
        G = dot(dv,dv,2);
        F = -dot(du,dv,2);
        mu = (E-G+2i*F)./(E+G+2*sqrt(E.*G-F.^2));
    otherwise
        error('Dimension of target mesh must be 3 or 2.')
end
