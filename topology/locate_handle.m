%% locate_handle 
% To find a handle of the surface

%% Syntax
%   [aChain,bChain] = locate_handle(face, vertex)

%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
% edgeInd: signed edge index

%%   Example
%   [aChain,bChain] = locate_handle(face, vertex);

%% Contribution
%  Author: Meng Bin
%  History:  2014/03/05 file created
%  Revised: 2014/03/07 by Meng Bin, Block write to enhance writing speed
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com


function [a,b] = locate_handle(face,vertex)

	a=[];
	b=[];
	
ee = cut_graph(face,vertex);

[M,~] = compute_adjacency_matrix(face);
%find inner edges
G = M.*(M==2)/2;
TF = graphisspantree(G);
if TF 
	return;
end

%get distance
GD = G*0;
[I,J,~] = find(G==1);
for k=1:size(I)
	GD(I(k),J(k)) = norm(vertex(I(k),:)-vertex(J(k),:));
end

a = shortest_loop_homotopy(vertex,G,[1,2,5]);
if ~isempty(a)
 face_ = slice_mesh(vertex,face,a);		%todo
 [M_,~] = compute_adjacency_matrix(face_);
 a_plus;
 a_minus;
 if ~isempty(a_plus) && ~isempty(a_minus)
	[~,path,~] = graphshortestpath(M_, a_plus(1),a_minus(1), 'METHOD', 'Dijkstra');
	b=[];
 end

end

