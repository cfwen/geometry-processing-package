%% vertex area 
% Compute area around vertex, two variants available: "one_ring" and "mixed",
% see paper [1] for more details.
% 
% # Meyer, Mark, et al. "Discrete differential-geometry operators for 
%   triangulated 2-manifolds." Visualization and mathematics III. Springer 
%   Berlin Heidelberg, 2003. 35-57.
%
%% Syntax
%   va = vertex_area(face,vertex)
%   va = vertex_area(face,vertex,type)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  type  : string, area type, either "one_ring", or "mixed"
% 
%  va: double array, nv x 1, area of all vertex.
% 
%% Example
%   va = vertex_area(face,vertex)
%   va = vertex_area(face,vertex,'one_ring') % same as last
%   va = vertex_area(face,vertex,'mixed')

%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/28 by Wen, add code and doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function va = vertex_area(face,vertex,type)
if ~exist('type','var')
    type = 'one_ring';
end
fa = face_area(face,vertex);
        
switch type
    case 'one_ring'
        [he,heif] = compute_halfedge(face);
        va = accumarray(he(:,1),fa(heif));
    case 'mixed'
        dvf12 = vertex(face(:,2),:)-vertex(face(:,1),:);
        dvf23 = vertex(face(:,3),:)-vertex(face(:,2),:);
        dvf31 = vertex(face(:,1),:)-vertex(face(:,3),:);
        c1 = vector_cot(dvf12,-dvf31);
        c2 = vector_cot(dvf23,-dvf12);
        c3 = vector_cot(dvf31,-dvf23);
        vaf1 = (dot(dvf12,dvf12,2).*c3+dot(dvf31,dvf31,2).*c2)/8;
        vaf2 = (dot(dvf23,dvf23,2).*c1+dot(dvf12,dvf12,2).*c3)/8;
        vaf3 = (dot(dvf31,dvf31,2).*c2+dot(dvf23,dvf23,2).*c1)/8;
        ind1 = c1<0;
        vaf1(ind1) = fa(ind1)/2;
        vaf2(ind1) = fa(ind1)/4;
        vaf3(ind1) = fa(ind1)/4;
        ind2 = c2<0;
        vaf1(ind2) = fa(ind2)/4;
        vaf2(ind2) = fa(ind2)/2;
        vaf3(ind2) = fa(ind2)/4;
        ind3 = c3<0;
        vaf1(ind3) = fa(ind3)/4;
        vaf2(ind3) = fa(ind3)/4;
        vaf3(ind3) = fa(ind3)/2;
        va = accumarray(face(:),[vaf1;vaf2;vaf3]);
    otherwise
        error('unknown area type.')
end

function vc = vector_cot(v1,v2)
% cot of angle between two vectors
cs = dot(v1,v2,2);
d1 = dot(v1,v1,2);
d2 = dot(v2,v2,2);
vc = cs./sqrt(d1.*d2-cs.*cs);
