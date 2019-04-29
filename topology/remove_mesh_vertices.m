%% remove_mesh_vertices
% remove vertices with given ids to remove

%% Syntax
% [Fout, Vout, new2OldMap] = remove_mesh_vertices(F, V, id2delete)

%% Description
 %remove the vertex and face by id2del, also get each vertex fatehr
%% Contribution
%  Author : Yanshuai Tu
%  Created: 2019/2/6
%  Revised: Not yet
%
%  Copyright @ Geometry Systems Laboratory
%  School of Computing, Informatics, and Decision Systems Engineering, ASU
%  http://gsl.lab.asu.edu/

function [Fout, Vout, new2OldMap] = remove_mesh_vertices(F, V, id2delete)

% create array of indices to keep
Nv = size(V, 1);

newV = (1:Nv)';
newV(id2delete) = [];
newNv = size(newV,1);
% create new vertex array
Vout = V(newV, :);

% compute map from old indices to new indices
old2NewMap = zeros(Nv, 1); 
new2OldMap = zeros(newNv, 1); 
for i = 1:size(newV, 1)
   old2NewMap(newV(i)) = i;  
   new2OldMap(i) =  newV(i);
end



% change labels of vertices referenced by faces
if isnumeric(F)
    Fout = old2NewMap(F);
    % keep only faces with valid vertices
    Fout = Fout(sum(Fout == 0, 2) == 0, :);  
end

