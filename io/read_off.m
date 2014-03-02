%% read_off 
% Read mesh data from OFF file

%% Syntax
%   [face,vertex,color] = read_off(filename);
%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
%

%%   Example
%   [face,vertex,color] = read_off('2_2.off');

function [face,vertex,color] = read_off(filename)

% check that filename exists
meshpath = which(filename);
if ~exist('meshpath')
    error(['File ',filename,' does not exist in matlab path\n']);
end

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

str = fgets(fid);   % -1 if eof
if ~strcmp(str(1:3), 'OFF')
    error('The file is not a valid OFF one.');    
end

str = fgets(fid);
[a,str] = strtok(str); nvert = str2num(a);
[a,str] = strtok(str); nface = str2num(a);

color = [];

%read vertex
[cols] = detect_nextline_cols(fid)
if cols < 3
    error('The file is not a valid OFF one.');    
end

format = strcat('%f %f %f ', repmat('%f ', [1, cols-3]));
format = strcat(format, '\n');

[A,cnt] = fscanf(fid,format, cols*nvert);
if cnt~=cols*nvert
	warning('Problem in reading vertices.');
end
A = reshape(A, cols, cnt/cols);
vertex = A';

% read vertex color	
if cols == 6
	color = A(4:6,:)';
elseif cols > 6
	color = A(4:7,:)';
end


% read face
[nvert_f] = detect_face_verts(fid);

cols = nvert_f+1;
if isempty(color)
	[cols] = detect_nextline_cols(fid)
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


fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cols] = detect_nextline_cols(fid)
% detect columns of next line
POSITION=ftell(fid);
tline = fgets(fid);
while ~feof(fid) & isempty(strtrim(tline))
    tline = fgets(fid);
end    
C = regexp(strtrim(tline),'\s+','split');
% read columns of face line
cols = size(C,2);
%frewind(fid);
fseek(fid,POSITION,-1);

function [nvert_f] = detect_face_verts(fid)
% detect verts of face line
POSITION=ftell(fid);
tline = fgets(fid);
while ~feof(fid) & isempty(strtrim(tline))
    tline = fgets(fid);
end    
[a,str] = strtok(tline);
nvert_f = str2num(a);
fseek(fid,POSITION,-1);
