%% read_obj 
% Read mesh data from OBJ file

%% Syntax
%   [vertex,face] = read_obj(filename)

%% Description
%   filename specify the file to read
%  'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%  'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
%   read_obj function only support triangle mesh.

%%   Example
%   [v,f] = read_obj('cube.obj');

%% Contribution
%  Author: Meng Bin
%  History:  2014/03/05 file created
%  Revised: 2014/03/07 by Meng Bin, Block read to enhance reading speed
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function [face,vertex] = read_obj( filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

vertex = [];
face = [];

read_n = [];        % these are the normals we have read, indexed by order
n = [];             % same normals rewritten to be in vertex order

u = [];

has_normals = 0;
has_texture = 0;

C = textscan(fid, '%s %s %s %s', 1);
while ~feof(fid)
    if strcmp(C{1}{1}, 'v')
        v1 = str2double(C{2}{1});  v2 = str2double(C{3}{1});  v3 = str2double(C{4}{1});
		vertex = cat(1, vertex, [v1,v2,v3]);

    elseif strcmp(C{1}{1}, 'vn')
        n1 = str2double(C{2}{1});  n2 = str2double(C{3}{1});  n3 = str2double(C{4}{1});
        read_n = cat(1, read_n, [n1,n2,n3]);
        has_normals = 1;

    elseif strcmp(C{1}{1}, 'vt')
        u1 = str2double(C{2}{1});  u2 = str2double(C{3}{1});
        u = cat(1, u, [u1,u2]);
        has_texture = 1;
        
    elseif strcmp(C{1}{1}, 'f')
        fi1 = regexp(C{2}{1}, '\d+', 'match');
        fi2 = regexp(C{3}{1}, '\d+', 'match');
        fi3 = regexp(C{4}{1}, '\d+', 'match');
        
        v1 = str2num(fi1{1});
        v2 = str2num(fi2{1});
        v3 = str2num(fi3{1});
        
        % rewrite normals in vertex-index order
        if has_normals
            nindex = 2 + has_texture;
            n1 = str2num(fi1{nindex});
            n2 = str2num(fi2{nindex});
            n3 = str2num(fi3{nindex});
            n(v1,:) = read_n(n1,:);
            n(v2,:) = read_n(n2,:);
            n(v3,:) = read_n(n3,:);
        end
        
       face = cat(1, face, [v1,v2,v3]);

    end
    C = textscan(fid, '%s %s %s %s', 1);
end

% matlab array index starts from 1
face = face + 1;

fclose(fid);

end

