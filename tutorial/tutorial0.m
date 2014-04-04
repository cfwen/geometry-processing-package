%% tutorial 0: quick-start
% This tutorial will bring you go through the package, show you its design
% principle and capability.
% 
%% Preparation
% First we add the package folder to search path:
% 
%   addpath('geometric-processing-package')
% 
% startup will then add all subfolders in the package to the top of search 
% path and set output format
startup

%% Read/Write mesh
% Three mesh formats are supported: 
% <../io/OFF_File_Format.html OFF>, 
% <../io/OBJ_File_Format.html OBJ>, 
% <../io/PLY_File_Format.html PLY>. 
% We support a subset of these formats' specification. Check doc of that
% file.
[face,vertex] = read_off('data/face.off'); % read off format mesh
sf = size(face)   % face is a nf x 3 array
sv = size(vertex) % vertex is a nv x 3 array
write_obj('data/face.obj',face,vertex) % write mesh to obj format

%% Visualize mesh
% We supply two visualization functions: 
% 
%   plot_mesh(face,vertex)
%   plot_path(face,vertex,path)
% 
% Both function uses pre-defined style to plot. You can easily specify your
% own style. More details please read help doc.
fig = figure('Position',[555 152 455 574]);
plot_mesh(face,vertex) % plot mesh
axis off
view(-90,-84)
snapnow
bd = compute_bd(face); % bd is the boundary
plot_path(face,vertex,bd) % plot path (boundary) on mesh

%% Advanced plotting
% You can specify your own style.
fig = figure('Position',[555 152 455 574]); % set figure size and background color
plot_mesh(face,vertex,...
'EdgeColor',[20 20 20]/255,...
'FaceColor',[251 175 147]/255,...
'LineWidth',0.5,...
'CDataMapping','scaled');
axis equal
axis tight
view(-90,-84)
axis off
colormap hsv
lighting phong
light('Position',[-1 1 -1],'Style','infinite');
%% Export figure
% To export high quality images, we recommend an excellent library 
% <http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig
% export_fig>. Export above figure with export_fig 
% 
%   export_fig face -png -transparent -nocrop
% 
addpath('..\library\export_fig\') % add export_fig path
% In the following tutorial, we always use export_fig to export figures.
% For example, above figure is exported as follows:
export_fig html/tutorial/face.style -png -transparent -nocrop
%%
% 
% <<face.style.png>>
% 
close(fig)