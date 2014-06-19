%% spherical conformal map 
% Spherical Conformal Map of a closed genus-0 surface. Methodology details
% please refer to [1]. Some code is derived from Gary Choi.
% 
% # K.C. Lam, P.T. Choi and L.M. Lui, FLASH: Fast landmark aligned 
%   spherical harmonic parameterization for genus-0 closed brain surfaces, 
%   UCLA CAM Report, ftp://ftp.math.ucla.edu/pub/camreport/cam13-79.pdf?
%
%% Syntax
%   uvw = spherical_conformal_map(face,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
% 
%  uvw: double array, nv x 3, spherical uvw coordinates of vertex on 3D unit sphere
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/27
%  Revised: 2014/03/28 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function uvw = spherical_conformal_map(face,vertex)
dv1 = vertex(face(:,2),:) - vertex(face(:,3),:);
e1 = sqrt(dot(dv1,dv1,2));
dv2 = vertex(face(:,3),:) - vertex(face(:,1),:);
e2 = sqrt(dot(dv2,dv2,2));
dv3 = vertex(face(:,1),:) - vertex(face(:,2),:);
e3 = sqrt(dot(dv3,dv3,2));
e123 = e1+e2+e3;
regularity = abs(e1./e123-1/3)+abs(e2./e123-1/3)+abs(e3./e123-1/3);
% choose vertex bi as the big triangle
[~,bi] = min(regularity);
nv = size(vertex,1);
A = laplace_beltrami(face,vertex);
fi = face(bi,:);
[I,J,V] = find(A(fi,:));
A = A - sparse(fi(I),J,V,nv,nv) + sparse(fi,fi,[1,1,1],nv,nv);

% Set boundary condition for big triangle
x1 = 0; y1 = 0; 
x2 = 100; y2 = 0;
a = vertex(fi(2),:) - vertex(fi(1),:);
b = vertex(fi(3),:) - vertex(fi(1),:);
ratio = norm([x1-x2,y1-y2])/norm(a);
y3 = norm([x1-x2,y1-y2])*norm(cross(a,b))/norm(a)^2;
x3 = sqrt(norm(b)^2*ratio^2-y3^2);

% Solve matrix equation
% d = complex(zeros(nv,1));
% d(fi) = [x1+1i*y1;x2+1i*y2;x3+1i*y3];
% z = A\d;
d = zeros(nv,2);
d(fi,:) = [x1,y1;x2,y2;x3,y3];
uv = A\d;
z = uv(:,1) + 1i*uv(:,2);
z = z - mean(z);
dz2 = abs(z).^2;
vertex_new = [2*real(z)./(1+dz2), 2*imag(z)./(1+dz2), (-1+dz2)./(1+dz2)];

% Find optimal big triangle size
% Reason: the distribution will be the best 
% if the southmost triangle has similar size of the northmost one 
w = complex(vertex_new(:,1)./(1+vertex_new(:,3)), vertex_new(:,2)./(1+vertex_new(:,3)));
[~, index] = sort(abs(z(face(:,1)))+abs(z(face(:,2)))+abs(z(face(:,3))));
ni = index(2); % since index(1) must be bi, not really
ns = sum(abs(z(face(bi,[1 2 3]))-z(face(bi,[2 3 1]))))/3;
ss = sum(abs(w(face(ni,[1 2 3]))-w(face(ni,[2 3 1]))))/3;
z = z*(sqrt(ns*ss))/ns;
dz2 = abs(z).^2;
vertex_new = [2*real(z)./(1+dz2), 2*imag(z)./(1+dz2), (-1+dz2)./(1+dz2)];

% south pole stereographic projection
uv = [vertex_new(:,1)./(1+vertex_new(:,3)),vertex_new(:,2)./(1+vertex_new(:,3))];
mu = compute_bc(face,uv,vertex);
% find the south pole
[~,ind] = sort(vertex_new(:,3));
nv = size(vertex,1);
fixed = ind(1:min(nv,50));
% reconstruct map with given mu and some fixed point
[fuv,fmu] = linear_beltrami_solver(face,uv,mu,fixed,uv(fixed,:));
fz = complex(fuv(:,1),fuv(:,2));
dfz2 = abs(fz).^2;
uvw = [2*real(fz)./(1+dfz2), 2*imag(fz)./(1+dfz2), -(-1+dfz2)./(1+dfz2)];
