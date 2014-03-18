%% compute_edge 
%  description of the function
% 
%  [detailed explanation]
%
%% Syntax
%   [edge,eif] = compute_edge(face);
%
%% Description
%  
%
%% Example
%   [edge,eif] = compute_edge(face);
%
%% Contribution
%  Author : Wen Chengfeng
%  Created: 2014/03/
%  Revised: 2014/03/18 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function [edge,eif] = compute_edge(face)
[am,amd] = compute_adjacency_matrix(face);
[I,J,~] = find(am);
ind = I<J;
edge = [I(ind),J(ind)];
[~,~,V] = find(amd-xor(amd,am));
[~,~,V2] = find((amd-xor(amd,am))');
eif = [V(ind),V2(ind)];
