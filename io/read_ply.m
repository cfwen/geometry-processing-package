%% read_ply 
% Read mesh data from ply file

%% Syntax
%   [face,vertex,color] = read_ply(filename);
%% Description
%   filename specify the file to read.
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.

%% Example
%   [face,vertex,color] = read_ply('2_2.ply');

%% Contribution
%  Author: Meng Bin
%  History:  2014/03/05 file created
%  Revised: 2014/03/07 by Meng Bin, Block read to enhance reading speed
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com


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
function [face,vertex,color] = read_ascii(fid, nvert, nface)
% read ASCII format ply file
color = [];

%read vertex info
tot_cnt = 0;
cols = 0;
A = [];

tline = '';
while (~feof(fid) && (isempty(tline) || tline(1) == '#'))
	pos = ftell(fid);
	tline = strtrim(fgets(fid));
end
C = regexp(tline,'\s+','split');
% read columns of vertex line
cols = size(C,2);
%rewind to starting of the line 
fseek(fid, pos,-1);
%vertex and color line format string
format = strcat(repmat('%f ', [1, cols]), '\n');
    
%start reading	
while (~feof(fid) & tot_cnt < cols*nvert)
    [A_,cnt] = fscanf(fid,format, cols*nvert-tot_cnt);
    tot_cnt = tot_cnt + cnt;
    A = [A;A_];
    skip_comment_blank_line(fid,1);
end

if tot_cnt~=cols*nvert
    warning('Problem in reading vertices. number of vertices doesnt match header.');
end
A = reshape(A, cols, tot_cnt/cols);
vertex = A(1:3,:)';

% extract vertex color	
if cols == 6
	color = A(4:6,:)';
elseif cols > 6
	color = A(4:7,:)';
end

%read face info
tot_cnt = 0;
A = [];
tline = '';
while (~feof(fid) && (isempty(tline) || tline(1) == '#'))
	pos = ftell(fid);
	tline = strtrim(fgets(fid));
end
C = regexp(tline,'\s+','split');
% read columns of face line
nvert_f = str2num(C{1});
cols = nvert_f+1;
if isempty(color)
	cols = size(C,2);
end
%rewind to starting of the line 
fseek(fid, pos,-1);
%face and color line format string
format = strcat(repmat('%d ', [1, nvert_f+1]), repmat('%f ', [1, cols-nvert_f-1]));
format = strcat(format, '\n');
	

while (~feof(fid) & tot_cnt < cols*nface)
    [A_,cnt] = fscanf(fid,format, cols*nface-tot_cnt);
    tot_cnt = tot_cnt + cnt;
    A = [A;A_];
	skip_comment_blank_line(fid,1);
end
   
if tot_cnt~=cols*nface
    warning('Problem in reading faces. Number of faces doesnt match header.');
end
A = reshape(A, cols, tot_cnt/cols);
face = A(2:nvert_f+1,:)'+1;

% extract face color
if cols > nvert_f+1
	color = A(nvert_f+2:cols,:)';
end
color = color*1.0/255;

function [tline] = skip_comment_blank_line(fid,rewind)
% skip empty and comment lines
% get next content line
% if rewind==1, then rewind to the starting of the content line
tline = '';
if rewind==1    
    pos = ftell(fid);
end
while (~feof(fid) && (isempty(tline)))
    if rewind==1
        pos = ftell(fid);
    end
    tline = strtrim(fgets(fid));
end
if rewind==1
        fseek(fid, pos,-1);
end





