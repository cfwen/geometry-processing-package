%% face area 
% Compute area of all face
%
%% Syntax
%   fa = face_area(face,vertex)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
% 
%  fa: double array, nf x 1, area of all faces.
% 
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function fa = face_area(face,vertex)
fi = face(:,1);
fj = face(:,2);
fk = face(:,3);
vij = vertex(fj,:)-vertex(fi,:);
vjk = vertex(fk,:)-vertex(fj,:);
vki = vertex(fi,:)-vertex(fk,:);
a = sqrt(dot(vij,vij,2));
b = sqrt(dot(vjk,vjk,2));
c = sqrt(dot(vki,vki,2));
s = (a+b+c)/2.0;
fa = sqrt(s.*(s-a).*(s-b).*(s-c));
