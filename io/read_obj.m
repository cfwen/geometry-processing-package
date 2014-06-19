%% read obj 
% Read mesh data from wavefront OBJ format file, only triangle mesh supported. 
% 
% Data supported are:
% 
% * geometric vertices (v)
% * texture vertices (vt)
% * vertex normals (vn)
% * face (f) (triangle only)
%
% All other data will be discarded.

%% Syntax
%   [face,vertex] = read_obj(filename)
%   [face,vertex,extra] = read_obj(filename)
%
%% Description
%  filename: string, file to read.
%
%  face  : double array, nf x 3, connectivity of the mesh.
%  vertex: double array, nv x 3, position of the vertices.
%  extra : struct, anything other than face and vertex are included.
%
%% Example
%   [face,vertex] = read_obj('cube.obj');
%   [face,vertex,extra] = read_obj('face.obj');
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/26
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [face,vertex,extra] = read_obj(filename)
% read whole file into a string
text = fileread(filename);
% split text into lines
[~,lines] = regexp(text,'\n','match','split');
% remove empty and comment lines
ind = cellfun(@(s) isempty(s) || strcmp(s(1),char(13)) || strcmp(s(1),'#'),lines);
lines(ind) = [];

% find all face lines that start with 'f'
ind = cellfun(@(s) strcmp(s(1),'f'),lines);
face_lines = lines(ind);
lines(ind) = [];
% determine format of face line
[type,format,sz] = get_format(face_lines{1});
% join face lines to a string
face_string = strjoin(face_lines,'\n');
% scan face from string
face = sscanf(face_string,format);
face = reshape(face,sz,length(face)/sz)';

% find all vertex lines that start with 'v'
ind = cellfun(@(s) strcmp(s(1:2),'v '),lines);
vertex_lines = lines(ind);
lines(ind) = [];
% determint format of vertex line
[type,format,sz] = get_format(vertex_lines{1});
% join vertex lines to a string
vertex_string = strjoin(vertex_lines,'\n');
% scan vertex from string
vertex = sscanf(vertex_string,format);
vertex = reshape(vertex,sz,length(vertex)/sz)';

% put all other stuff into a structure extra
extra = [];
if size(vertex,2) > 3
    % if vertex line have more than 3 number, then it's color
    vertex_color = vertex(:,4:end);
    vertex = vertex(:,1:3);
    extra.vertex_color = vertex_color;
end

% check if texture and normal are contained
texture = [];
normal = [];
ind = cellfun(@(s) strcmp(s(1:2),'vt'),lines);
texture_lines = lines(ind);
lines(ind) = [];
if sum(ind)
    texture_string = strjoin(texture_lines,'\n');
    [type,format,sz] = get_format(texture_lines{1});
    texture = sscanf(texture_string,format);
    texture = reshape(texture,sz,length(texture)/sz)';
    extra.texture = texture;
end
ind = cellfun(@(s) strcmp(s(1:2),'vn'),lines);
normal_lines = lines(ind);
if sum(ind)
    normal_string = strjoin(normal_lines,'\n');
    [type,format,sz] = get_format(normal_lines{1});
    normal = sscanf(normal_string,format);
    normal = reshape(normal,sz,length(normal)/sz)';
    extra.normal = normal;
end

% if texture or normal contained, retrive face_texture and face_normal from
% face array
if ~isempty(texture) && ~isempty(normal)
    face_texture = face(:,[2 5 8]);
    face_normal = face(:,[3 6 9]);
    face = face(:,[1 4 7]);
    extra.face_texture = face_texture;
    extra.face_normal = face_normal;
elseif ~isempty(texture) && isempty(normal)
    face_texture = face(:,[2 4 6]);
    face = face(:,[1 3 5]);
    extra.face_texture = face_texture;
elseif isempty(texture) && ~isempty(normal)
    face_normal = face(:,[2 4 6]);
    face = face(:,[1 3 5]);
    extra.face_normal = face_normal;
end

function [type,format,sz] = get_format(str)
% determine the format of input str
sn = '[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)'; % match number
ss = '[a-zA-Z]+'; % match string
format = regexprep(str,sn,'%f');
if format(end) ~= char(13)
    format = [format,'\n'];
end
[type,~] = regexp(str,ss,'match');
type = type{1};
[~,splitstr] = regexp(str,sn,'match');
sz = length(splitstr);
