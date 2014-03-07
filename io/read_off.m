%% read_off 
% Read mesh data from OFF file

%% Syntax
%   [face,vertex,color] = read_off(filename);
%% Description
%   filename specify the file to read.
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
%   'color' is a 'vert_number x 3 or face_number x 3' array specifying the color of the vertices or faces.

%%   Example
%   [face,vertex,color] = read_off('2_2.off');

%% Copyright 2014 Computational Geometry Group,  Mathematics Dept., CUHK
%  Website:  http://www.lokminglui.com/
%  Author: Meng Bin
%  History:  2014/03/05 file created

function [face,vertex,color] = read_off(filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
end

% read header
[tline] = skip_comment_blank_line(fid,0);
if ~strcmpi(tline(1:3), 'OFF')
    error('The file is not a valid OFF one.');    
end

%read number of verteics and faces
[tline] = skip_comment_blank_line(fid,0);
[a,tline] = strtok(tline); nvert = str2num(a);
[a,tline] = strtok(tline); nface = str2num(a);

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
while (~feof(fid) && tot_cnt < cols*nvert)
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
color = A(4:end,:)';

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

%start reading		
while (~feof(fid) && tot_cnt < cols*nface)
    [A_,cnt] = fscanf(fid,format, cols*nface-tot_cnt);
    tot_cnt = tot_cnt + cnt;
    A = [A;A_];
	skip_comment_blank_line(fid,1);
end
   
if tot_cnt~=cols*nface
    warning('Problem in reading faces. Number of faces doesn''t match header.');
end
A = reshape(A, cols, tot_cnt/cols);
face = A(2:nvert_f+1,:)'+1;

% extract face color
if cols > nvert_f+1
	color = A(nvert_f+2:cols,:)';
end

fclose(fid);


function [tline] = skip_comment_blank_line(fid,rewind)
% skip empty and comment lines
% get next content line
% if rewind==1, then rewind to the starting of the content line
tline = '';
if rewind==1    
    pos = ftell(fid);
end
while (~feof(fid) && (isempty(tline) || tline(1) == '#'))
    if rewind==1
        pos = ftell(fid);
    end
    tline = strtrim(fgets(fid));
end
if rewind==1
    fseek(fid, pos,-1);
end

