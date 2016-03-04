%% compute_vertex_ring 
% Compute one-ring neighbor of given vertex or all vertex, with or 
% without ccw order. Default is no order.
% 
% In some algorithms, ordered one-ring neighbor is necessary. However,
% compute ordered one-ring is significantly slower than unordered one, so
% compute with order only absolutely necessary.
%
%% Syntax
%   vr = compute_vertex_ring(face)
%   vr = compute_vertex_ring(face,vc)
%   vr = compute_vertex_ring(face,vc,ordered)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
%  vc  : double array, n x 1 or 1 x n, vertex collection, can be empty, 
%        which equivalent to all vertex.
%  ordered: bool, scaler, indicate if ccw order needed.
% 
%  vr: cell array, nv x 1, each cell is one ring neighbor vertex, which is
%      a double array
%
%% Example
%   % compute one ring of all vertex, without order
%   vr = compute_vertex_ring(face)
% 
%   % compute one ring of vertex 1:100, without ccw order
%   vr = compute_vertex_ring(face,1:100,false)
% 
%   % compute one ring of vertex 1:100, with ccw order
%   vr = compute_vertex_ring(face,1:100,true)
% 
%   % compute one ring of all vertex, with ccw order (may be slow)
%   vr = compute_vertex_ring(face,[],ordered)
% 
%   % same with last one
%   vr = compute_vertex_ring(face,1:nv,ordered)
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/06
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function vr = compute_vertex_ring(face,vertex,vc,ordered)
% number of vertex, assume face are numbered from 1, and in consecutive
% order
nv = max(max(face));
if nargin == 1
    ordered = false;
	vc = (1:nv)';
elseif nargin == 2
    ordered = false;
end
if isempty(vc)
    vc = (1:nv)';
end
vr = cell(size(vc));
bd = compute_bd(face);
isbd = false(nv,1);
isbd(bd) = true;
if ~ordered
    [am,~] = compute_adjacency_matrix(face);
    [I,J,~] = find(am(:,vc));
    vr = cell(size(vc,1),1);
    for i = 1:length(J)
        vr{J(i)}(end+1) = I(i);
    end
end
if ordered
    DT = triangulation(face,vertex);
    va = vertexAttachments(DT,vc);
    for i = 1:size(vc,1)                
        vai = va{i};        
        fai = face(vai,:);
        ind = mod(find(fai'==vc(i)),3)-1;
        ind1 = ind(1)+2;
        ind(ind<=0) = ind(ind<=0)+3;
        vri = zeros(1,length(ind));
        for j = 1:length(ind)
            vri(j) = fai(j,ind(j));
        end
        %if (length(unique(fai))-1)*2 == length(fai(:))-length(ind)
        if ~isbd(vc(i))
            vri(end+1) = vri(1);
        else
            vri = [fai(1,ind1),vri];
        end
        vr{i} = vri;
    end
end
if ordered && false
    [vvif,nvif,pvif] = compute_connectivity(face);
    for i = 1:size(vc,1)
        fs = vvif(vc(i),:);
        v1 = full(find(fs,1,'first'));
        if isbd(vc(i))
            while vvif(v1,vc(i))
                f2 = full(vvif(v1,vc(i)));
                v1 = full(pvif(f2,v1));
            end
        end
        vi = v1;
        v0 = v1;
        while vvif(vc(i),v1)
            f1 = full(vvif(vc(i),v1));
            v1 = full(nvif(f1,v1));
            vi = [vi,v1];
            if v0 == v1
                break;
            end
        end
        vr{i} = vi;
    end
end