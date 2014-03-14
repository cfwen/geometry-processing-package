function p = plot_mesh(face,vertex,varargin)

if nargin < 2
    disp('warning: no enough inputs');
    return;
end
dim = 3;
if size(vertex,2) == 2
    vertex(:,3) = 0;
    dim = 2;
end
if nargin == 2
    po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),...
    'EdgeAlpha',0.3,...
    'EdgeColor',[36 169 225]/255,...
    'LineWidth',0.5,...
    'LineSmooth','off',...
    'CDataMapping','scaled');
elseif nargin > 2
    po = trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),varargin{:});
end
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