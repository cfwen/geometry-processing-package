%% plot path 
% Plot path on a mesh. Path can be a double array, specifying the vertex 
% index of the path on the mesh. Path can also be a cell, each cell
% specify a path. If plot to figure with existing mesh, mesh will not be 
% plotted again.
%
%% Syntax
%   p = plot_path(face,vertex,path)
%   p = plot_path(face,vertex,path,style)
%   p = plot_path(face,vertex,path,style,marker)
%   p = plot_path(face,vertex,path,style,marker,marker_style)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  path  : double array, n1 x 1, vertex index of the path
%          cell array, n2 x 1, each cell is a path
%  style : string, path style
%  marker: double array, n3 x 1, marker index to plot
%  marker_style: string, marker style
% 
%  p: handle, a handle to the displayed figure
%
%% Example
%   p = plot_path(face,vertex,path)
%   p = plot_path(face,vertex,path,'r-') % same with last
%   p = plot_path(face,vertex,path,'b-',1:10,'ko') % also plot some markers with style
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/14
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function p = plot_path(face,vertex,path,style,marker,marker_style)
if isempty(getappdata(gca,'Mesh'))
    po = plot_mesh(face,vertex);
end
if ~exist('style','var') || isempty(style)
    style = 'r-';
end
dim = 3;
if size(vertex,2) == 2
    vertex(:,3) = 0;
    dim = 2;
end
if ~exist('marker','var')
    marker = [];
end
if ~exist('marker_style','var') || isempty(marker_style)
    marker_style = 'k*';
end
hold on
switch class(path)
    case 'cell'
        for i = 1:length(path)
            pi = path{i};
            po = plot3(vertex(pi,1),vertex(pi,2),vertex(pi,3),style,'LineWidth',2);
        end
    case 'double'
        po = plot3(vertex(path,1),vertex(path,2),vertex(path,3),style,'LineWidth',2);
end
if ~isempty(marker)
    plot3(vertex(marker,1),vertex(marker,2),vertex(marker,3),marker_style);
end
if dim == 2
    view(0,90);
end
if nargout > 1
    p = po;
end
