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
        [face,vertex] = read_ascii(fid)
elseif strcmp(lower(file_format), 'binary_little_endian')
elseif strcmp(lower(file_format), 'binary_big_endian')
else 
	error('The file is not a valid ply one. File format must be ascii or binary.');
end

fclose(fid);



function [face,vertex,color] = read_ascii(fid, nvert, nface, color_ind)
% read ASCII format ply file
str = strtrim(fgets(fid));
while (~feof(fid) && isempty(str)
    str = strtrim(fgets(fid));
end

cols = 3;
if color_ind == 1
    cols = 6;    
end

format = strcat('%f %f %f ', repmat('%f ', [1, cols-3]));
format = strcat(format, '\n');
%read vertex
[A,cnt] = fscanf(fid,format, cols*nvert);
if cnt~=cols*nvert
	warning('Problem in reading vertices.');
end
A = reshape(A, cols, cnt/cols);
vertex = A';

str = strtrim(fgets(fid));
while (~feof(fid) && isempty(str)
    str = strtrim(fgets(fid));
end

% read vertex color	
if cols == 6
	color = A(4:6,:)'*1.0/255;
	
% read face
[nvert_f] = detect_face_verts(fid);

cols = nvert_f+1;
if isempty(color)
	[cols] = detect_nextline_cols(fid);
end

format = strcat(repmat('%d ', [1, nvert_f+1]), repmat('%f ', [1, cols-nvert_f-1]));
format = strcat(format, '\n');

[A,cnt] = fscanf(fid,format, cols*nface);
if cnt~=cols*nface
	warning('Problem in reading faces.');
end
A = reshape(A, cols, cnt/cols);
face = A(2:nvert_f+1,:)'+1;

% read face color
if cols > nvert_f+1
	color = A(nvert_f+2:cols,:)';
end


function [face,vertex,color] = read_binary(fid)
% PLY and MATLAB data types (for fread)
PlyTypeNames = {'char','uchar','short','ushort','int','uint','float','double', ...
   'char8','uchar8','short16','ushort16','int32','uint32','float32','double64'};
MatlabTypeNames = {'schar','uchar','int16','uint16','int32','uint32','single','double'};
SizeOf = [1,1,2,2,4,4,4,8];	% size in bytes of each type



