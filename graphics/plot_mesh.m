%% plot_mesh 
% Plot mesh in an easy way, in pre-defined style or user-supplied style
% Basically this is a wrap for trimesh, with additional style and data
% binding (can be used in data cursor pickup). Mesh data (face,vertex) are
% binding with the figure through "setappdata", in a struct form:
% Mesh = struct('Face',face,'Vertex',vertex);
%
%% Syntax
%   p = plot_mesh(face,vertex)
%   p = plot_mesh(face,vertex,"PropertyName",PropertyValue,...)
%
%% Description
%  face  : double array, nf x 3, connectivity of mesh
%  vertex: double array, nv x 3, vertex of mesh
%  varargin: additional property names and values pair, accept any
%            property-value pair which trimesh accepts.
% 
%  p: handle, a handle to the displayed figure
%
%% Example
%   p = plot_mesh(face,vertex) % use pre-defined style
%   p = plot_mesh(face,vertex,'EdgeColor',[36 169 225]/255) % specify edge color
%   p = plot_mesh(face,vertex,'FaceAlpha',0.5) % set face alpha to 0.5
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/
%  Revised: 2014/03/24 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function p = plot_mesh(face,vertex,color,varargin)
if nargin < 2
    disp('warning: no enough inputs');
    return;
end
dim = 3;
if size(vertex,2) == 1
    vertex = [real(vertex),imag(vertex),vertex*0];
    dim = 2;
end
if size(vertex,2) == 2
    vertex(:,3) = 0;
    dim = 2;
end
if nargin == 2
    po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),...
        'EdgeColor',[36 169 225]/255,...
        'LineWidth',0.5,...    
        'CDataMapping','scaled');
elseif nargin == 3
    po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),color,...        
        'LineWidth',0.5,...    
        'CDataMapping','scaled');
elseif nargin > 3
    if isempty(color) || isa(color,'string')
        po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),varargin{:});
    else
        po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),color,varargin{:});
    end
end
g = gca;
g.Clipping = 'off';
axis equal;
if dim == 2
    view(0,90);
end
if nargout > 0
    p = po;
end
mesh = struct('Face',face,'Vertex',vertex);
setappdata(gca,'Mesh',mesh);
% graph = gcf;
dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@datatip_callback,'Enable','off')

function output_txt = datatip_callback(obj,event)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos  = get(event,'Position');
ax   = get(get(event,'Target'),'Parent');
mesh = getappdata(ax,'Mesh');

d = dist(mesh.Vertex,pos);
[~,index] = min(d);
output_txt = {['index: ',num2str(index)],...
    ['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)],...
    ['Z: ',num2str(pos(3),4)]};

function d = dist(P,q)
Pq = [P(:,1)-q(1),P(:,2)-q(2),P(:,3)-q(3)];
d = sqrt(dot(Pq,Pq,2));
