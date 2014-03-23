%% laplace_beltrami 
%  Laplace Beltrami operator on the mesh.
%  Cotangent formula is used, while there are some variants. 
%
%% Syntax
%   A = laplace_beltrami(face,vertex)
%   A = laplace_beltrami(face,vertex,method)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  method: string, optional, method of cotangent formula, can be one of
%          three: 'Polthier', 'Meyer', 'Desbrun'. Default is 'Polthier'.
% 
%  A: sparse matrix, nv x nv, Laplace Beltrami operator
%
%% Example
%   A = laplace_beltrami(face,vertex)
%   A = laplace_beltrami(face,vertex,'Polthier')
%   A = laplace_beltrami(face,vertex,'Meyer')
%   A = laplace_beltrami(face,vertex,'Desbrun')
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/03 by Wen, add more cotangent formula variants, not
%           implemented
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function A = laplace_beltrami(face,vertex,method)
% default method is 'Polthier'
if nargin == 2
    method = 'Polthier';
end
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
switch method
    case 'Polthier';
        A = (A - sparse((1:nv)',(1:nv)',sA))/2;
    case 'Meyer'
        
    case 'Desbrun'
        
    otherwise
        error('Wrong method. Available methods are: Polthier,Meyer,Desbrun.')
end
if strcmp(method,'Polthier')
    
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
