%% read_off 
% Read mesh data from OFF file

%% Syntax
%   [face,vertex,color] = read_off(filename);
%% Description
%   'vertex' is a 'vert_number x 3' array specifying the position of the vertices.
%   'face' is a 'face_number x 3' array specifying the connectivity of the mesh.
%
%   Copyright (c) 2003 Gabriel Peyr?

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



[A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
if cnt~=3*nvert
    warning('Problem in reading vertices.');
end
A = reshape(A, 3, cnt/3);
vertex = A';

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


% read Face 1  1088 480 1022
if cols ==4
    [A,cnt] = fscanf(fid,'%d %d %d %d \n', 4*nface);
    if cnt~=4*nface
        warning('Problem in reading faces.');
    end
    A = reshape(A, 4, cnt/4);
else
    [A,cnt] = fscanf(fid,'%d %d %d %d %d\n', 5*nface);
    if cnt~=5*nface
        warning('Problem in reading faces.');
    end
    A = reshape(A, 5, cnt/5);
end
face = A(2:4,:)'+1;

color = [];

if cols > 4
    color = A(5,:)';

fclose(fid);

end

