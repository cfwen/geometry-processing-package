%% compute halfedge 
% Halfedge is simply directed edge, each face has three halfedges.
% This function will return all nf x 3 halfedges, as well as a nf x 3
% vector indicate which face the halfedge belongs to.
%
%% Syntax
%   [he,heif] = compute_halfedge(face)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
% 
%  he  : double array, (nf x 3) x 2, each row is a halfedge
%  heif: double array, (nf x 3) x 1, face id in which the halfedge lies in
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/06
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [he,heif] = compute_halfedge(face)
nf = size(face,1);
he = [reshape(face',nf*3,1),reshape(face(:,[2 3 1])',nf*3,1)];
heif = reshape(repmat(1:nf,[3,1]),nf*3,1);
