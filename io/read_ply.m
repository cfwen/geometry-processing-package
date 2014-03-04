%% read_ply 
% Read mesh data from ply file

%% Syntax
%   [face,vertex,color] = read_ply(filename);
%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.

%%   Example
%   [face,vertex,color] = read_ply('2_2.ply');

%   Copyright 2014 Computational Geometry Group,  Mathematics Dept., CUHK
%   http://www.lokminglui.com/

function [face,vertex,color] = read_ply(filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

% read header
str = '';
while (~feof(fid) && isempty(str))
    str = strtrim(fgets(fid));
end
if ~strcmp(lower(str(1:3)), 'ply')
    error('The file is not a valid ply one.');    
end

file_format = '';
nvert = 0;
nface = 0;
stage = '';
while (~feof(fid))
    str = strtrim(fgets(fid));
	if strcmp(lower(str), 'end_header')
		break;
	end
	tokens = regexp(str,'\s+','split');
	if (size(tokens,2) <= 2) 
		continue;
	end	
	if strcmp(lower(tokens(1)), 'comment')
	elseif strcmp(lower(tokens(1)), 'format')
		file_format = lower(tokens(2));	
	elseif strcmp(lower(tokens(1)), 'element')
		if strcmp(lower(tokens(2)),'vertex')
			nvert = str2num(tokens{3});
			stage = 'vertex';
		elseif strcmp(lower(tokens(2)),'face')
			nface = str2num(tokens{3});
			stage = 'face';
		end
	elseif strcmp(lower(tokens(1)), 'property')
	end
end

if strcmp(lower(file_format), 'ascii')
        [face,vertex,color] = read_ascii(fid, nvert, nface);
%elseif strcmp(lower(file_format), 'binary_little_endian')
%elseif strcmp(lower(file_format), 'binary_big_endian')
else 
	error('The file is not a valid ply one. We only support ascii now.');
end

fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cols] = detect_nextline_cols(fid)
% detect columns of next line
POSITION=ftell(fid);
tline = strtrim(fgets(fid));
while ~feof(fid) & isempty(tline)
    tline = strtrim(fgets(fid));
end    
C = regexp(tline,'\s+','split');
% read columns of face line
cols = size(C,2);
%frewind(fid);
fseek(fid,POSITION,-1);

function [face,vertex,color] = read_ascii(fid, nvert, nface)
% read ASCII format ply file
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
			error('The file is not a valid ply file. vertex columns %d < 3', cols);    
		end
	end
	format = strcat('%f %f %f ', repmat('%d ', [1, cols-3]));
	line = sscanf(str, format);
	vertex(ivert,:)= line(1:3,:)';
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
	format = strcat(repmat('%d ', [1, nvert_f+1]), repmat('%d ', [1, cols-nvert_f-1]));
	line = sscanf(str, format);
	face(iface,:) = line(2:nvert_f+1,:)';
	% read face color
	if (cols > nvert_f+1)
		color(iface,:) = line(nvert_f+2:cols,:)';
	end
end
%matlab index start from 1
face=face+1;
color = color*1.0/255;





