%% laplace_beltrami 
% Laplace Beltrami operator on the mesh.
% 
% Cotangent formula is used, while there are some variants:
% 
% * 'Polthier', see paper [1]
% * 'Meyer', see paper [2]
% * 'Desbrun', see paper [3]
% 
% For comparison and convergence analysis, see paper [4]
% 
% # K. Polthier. Computational Aspects of Discrete Minimal Surfaces. In 
%   Proc. of the Clay Summer School on Global Theory of Minimal Surfaces, 
%   J. Hass, D. Hoffman, A. Jaffe, H. Rosenberg, R. Schoen, M. Wolf (Eds.), 
%   to appear, 2002.
% # M. Meyer, M. Desbrun, P. Schröder, and A. Barr. Discrete 
%   Differential-Geometry Operator for Triangulated 2-manifolds. In Proc. 
%   VisMath'02, Berlin, Germany, 2002.
% # M. Desbrun, M. Meyer, P. Schröder, and A. H. Barr. Implicit Fairing 
%   of Irregular Meshes using Diffusion and Curvature Flow. SIGGRAPH99, 
%   pages 317-324, 1999.
% # Xu, Guoliang. "Convergent discrete laplace-beltrami operators over 
%   triangular surfaces." Geometric Modeling and Processing, 2004. 
%   Proceedings. IEEE, 2004.
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
%   A = laplace_beltrami(face,vertex,'Polthier') % same as last 
%   A = laplace_beltrami(face,vertex,'Meyer')
%   A = laplace_beltrami(face,vertex,'Desbrun')
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/03 by Wen, add more cotangent formula variants, not
%           implemented
%  Revised: 2014/03/23 by Wen, add doc
%  Revised: 2014/03/28 by Wen, add code for 'Meyer' and 'Desbrun' methods
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

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

switch method
    case 'Polthier'
        A = sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[ew;ew]/2);
        sA = sum(A,2);
        A = A - diag(sA);
    case 'Meyer'
        va = vertex_area(face,vertex,'mixed');
        ew = (ew./va(edge(:,1))+ew./va(edge(:,2)))/2;
        A = sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[ew;ew]);
        sA = sum(A,2);
        A = A - diag(sA);
    case 'Desbrun'
        va = vertex_area(face,vertex,'one_ring');
        ew = (ew./va(edge(:,1))+ew./va(edge(:,2)))/2*3;
        A = sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[ew;ew]);
        sA = sum(A,2);
        A = A - diag(sA);
    otherwise
        error('Wrong method. Available methods are: Polthier,Meyer,Desbrun.')
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
