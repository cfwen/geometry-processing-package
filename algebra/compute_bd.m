%% compute bd 
% Find boundary of mesh, returned bd will be in ccw consecutive order. For
% multiple boundary mesh, return a cell, each cell is a closed boundary.
% For single boundary mesh, return an array.
%
%% Syntax
%   bd = compute_bd(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
%
%  bd: double array, n x 1, consecutive boundary vertex list in ccw order
%      cell, n x 1, each cell is one closed boundary
% 
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/06
%  Revised: 2014/03/14 by Wen, add document
%  Revised: 2014/03/23 by Wen, revise doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function bd = compute_bd(face)
% amd stores halfedge information, interior edge appear twice in amd,
% while boundary edge appear once in amd. We use this to trace boundary. 
% 
% currently, there is problem for multiple boundary mesh. Some boundary may
% be missing.
[am,amd] = compute_adjacency_matrix(face);
md = am - (amd>0)*2;
[I,~,~] = find(md == -1);
[~,Ii] = sort(I);
bd = zeros(size(I));
k = 1;
for i = 1:size(I)
    bd(i) = I(k);
    k = Ii(k);
end
