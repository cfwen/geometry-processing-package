%% write_off 
% Read mesh data from OFF file

%% Syntax
%    write_off(filename,face,vertex,color)

%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
%
% 'color' is a 'face_number x 3' array specifying the color of the faces.

%%   Example
%   [face,vertex,color] = write_off('2_2.off');

function write_off(filename,face,vertex,color)

if nargin < 4
    color = [];
end

fid = fopen(filename,'wt');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

nvert = size(vertex, 1);
nvert_face = size(vertex, 2);
nface = size(face, 1);

ncolor =0;
if ~isempty(color)
    ncolor = size(color, 1);
end


fprintf (fid, 'OFF\n');
fprintf (fid, '%d %d %d\n',nvert, nface, 0);

for i = 1:nvert
    fprintf (fid, '%.4f %.4f %.4f ',vertex(i,1), vertex(i,2), vertex(i,3));
    if nvert == ncolor 
        for j = 1:size(color, 2)
            fprintf (fid, '%.4f ',color(i,j));
        end
    end
    fprintf (fid, '\n');
end

for i = 1:nface
    fprintf (fid, '%d ',nvert_face);
    for j = 1:nvert_face
        fprintf (fid, '%d ',face(i,j));
    end
    if nvert == ncolor & nface ~= ncolor
        for j = 1:size(color, 2)
            fprintf (fid, '%.4f ',color(i,j));
        end
    end
	fprintf (fid, '\n');
end


fclose(fid);

end

