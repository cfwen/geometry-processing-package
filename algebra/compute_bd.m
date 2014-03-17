%% compute_bd 
%  find boundary of mesh
%
%% Syntax
%   bd = compute_bd(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
%
%  bd: double array, n x 1, consective boundary vertex list in ccw order
% 
%% Example
%   bd = compute_bd(face);
%
%% Contribution
% 
%  Author : Wen Chengfeng
%  Created: 2014/03/06
%  Revised: 2014/03/14 by Wen, add document
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

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
