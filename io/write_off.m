%% write off 
% Write mesh data to OFF format mesh file
%  
%% Syntax
%   write_off(filename,face,vertex,color)
%   write_off(filename,face,vertex)
%
%% Description
%  filename: string, file to read.
%  face    : double array, nf x 3 array specifying the connectivity of the mesh.
%  vertex  : double array, nv x 3 array specifying the position of the vertices.
%  color   : double array, nv x 3 or nf x 3 array specifying the color of the vertices or faces.
%
%%  Example
%   write_off('temp.off',face,vertex);
%   write_off('temp.off',face,vertex,clor);
%
%% Contribution
%  Author : Meng Bin
%  Created: 2014/03/05
%  Revised: 2014/03/07 by Meng Bin, Block write to enhance writing speed.
%  Revised: 2014/03/17 by Meng Bin, modify doc format
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function write_off(filename,face,vertex,color)

if nargin < 4
    color = [];
end

fid = fopen(filename,'wt');
if( fid==-1 )
    error('Can''t open the file.');    
end

nvert = size(vertex, 1);
nface = size(face, 1);
nvert_face = size(face, 2);

ncolor =0;
if ~isempty(color)
    ncolor = size(color, 1);
end

fprintf (fid, 'OFF\n');
fprintf (fid, '%d %d %d\n',nvert, nface, 0);

if nvert == ncolor 
	vertex = [vertex';color']';
end
if nface == ncolor && nvert ~= ncolor
	face =[zeros(1,nface)+nvert_face; face'-1;color']';
else
	face =[zeros(1,nface)+nvert_face;face'-1]';
end
dlmwrite(filename,vertex,'-append',...  
         'delimiter',' ',...
         'precision', 6,...
         'newline','pc');
		 
dlmwrite(filename,face,'-append',...  
         'delimiter',' ',...
         'newline','pc');
		 
fclose(fid);

end

