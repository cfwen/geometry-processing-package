%% read_off 
% Read mesh data from OFF file

%% Syntax
%   [face,vertex,color] = read_off(filename);
%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.

%%   Example
%   [face,vertex,color] = read_off('2_2.off');

%   Copyright 2014 Computational Geometry Group,  Mathematics Dept., CUHK
%   http://www.lokminglui.com/

function [face,vertex,color] = read_off(filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

% read header
str = strtrim(fgets(fid));
while (~feof(fid) & str(1) == '#')
    str = strtrim(fgets(fid));
end
if ~strcmp(str(1:3), 'OFF')
    error('The file is not a valid OFF one.');    
end

%read number of verteics and faces
str = strtrim(fgets(fid));
while (~feof(fid) & str(1) == '#')
    str = strtrim(fgets(fid));
end
[a,str] = strtok(str); nvert = str2num(a);
[a,str] = strtok(str); nface = str2num(a);

color = [];

%read vertex
vertex = zeros(nvert,3); ivert = 0;
color = [];
cols = 0;
while (~feof(fid) & ivert < nvert)
    str = strtrim(fgets(fid));
	if (str(1)=='#') 
		continue;
	end
	ivert = ivert + 1;
	
	% read columns from first vertex line
	if(cols == 0)
		C = regexp(str,'\s+','split');
		cols = size(C,2);
		if cols < 3
			error('The file is not a valid OFF one. vertex columns %d < 3', cols);    
		end
	end
	format = strcat('%f %f %f ', repmat('%f ', [1, cols-3]));
	line = sscanf(str, format);
	vertex(ivert)= line(1:3,:)';
	if (cols > 3)
		color = [color; line(4:cols,:)'];
	end
end


% read face
face = []; iface = 0;
cols = 0; nvert_f = 0;
while (~feof(fid) && iface < nface)
    str = strtrim(fgets(fid));
	if (str(1)=='#') 
		continue;
	end
	iface = iface + 1;
	
	% read columns and number of vertex per face from first face line
	if(cols == 0)
		C = regexp(str,'\s+','split');
		cols = size(C,2);
		[a,str_] = strtok(str);
		nvert_f = str2num(a);
        face = zeros(nface,nvert_f);
	end
	format = strcat(repmat('%d ', [1, nvert_f+1]), repmat('%f ', [1, cols-nvert_f-1]));
	line = sscanf(str, format);
	face(iface,:) = line(2:nvert_f+1,:)';
	% read face color
	if (cols > nvert_f+1)
		color(iface,:) = line(nvert_f+2:cols,:)';
	end
end
%matlab index start from 1
face=face+1;

fclose(fid);


