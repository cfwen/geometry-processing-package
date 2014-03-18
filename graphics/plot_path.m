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