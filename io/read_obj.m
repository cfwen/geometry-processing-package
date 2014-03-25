%% read_obj 
%   Read mesh data from OBJ format mesh file
%
%% Syntax
%   face,vertex] = read_obj(filename)
%
%% Description
%  filename : string, file to read.
%
%  face   : double array, nf x 3 array specifying the connectivity of the mesh.
%  vertex : double array, nv x 3 array specifying the position of the vertices.
%  color  : double array, nv x 3 or nf x 3 array specifying the color of the vertices or faces.
%
%% Example
%   [face,vertex] = read_obj('cube.obj');
%
%% Contribution
%  Author: Meng Bin
%  Created: 2014/03/05
%  Revised: 2014/03/07 by Meng Bin, Block read to enhance reading speed
%  Revised: 2014/03/13 by Wen, correct doc
%  Revised: 2014/03/17 by Meng Bin, modify doc format
%  Revised: 2014/03/25 by Meng Bin, block reading
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.lokminglui.com

function [face,vertex] = read_obj(filename)

fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
end

vertex = [];
face = [];

A = [];
tline = '';

preheader = '';
% start reading vertex
while (~feof(fid) )
	tline = skip_comment_blank_line(fid,1);
	C = regexp(tline,'\s+','split');
	cols = size(C,2);
	header = C(1);
	
	format='';
	if strcmp(header,'f')				%face
		%format = strcat('f', repmat(' %s', [1 cols-1]));
		%format = strcat(format, '\n');
        %[A_,cnt] = fscanf(fid,format,[cols-1 inf])
        rows=textscan(fid,'f %s',inf,'delimiter','\n');
        content = rows{1};
        for i=1:size(content,1)
            fline = [];
            C = regexp(content{i},'\s+','split');
			for j=1:size(C,2)				
                 fi1 = regexp(C{j}, '\d+', 'match');
                 v1 = str2num(fi1{1});
                 fline = [fline v1];
            end
			if ~isempty(face) && size(face,2)~=size(fline,2)
				error('Vertex size of face  %s  does not match previous faces',content{i});
			else
				face = [face; fline];
			end
            
        end
	elseif strcmp(header,'v')			%vertex
		format = strcat('v', repmat(' %f', [1 cols-1]));
		format = strcat(format, '\n');
		[A_,cnt] = fscanf(fid,format,[cols-1 inf]);
		vertex = [vertex;A_'];
	elseif strcmp(header,'vt')			%ignore other vertex info
        textscan(fid,'vt %s',inf,'delimiter','\n');
	elseif strcmp(header,'vn')			%ignore other vertex info
        textscan(fid,'vn %s',inf,'delimiter','\n');
    end	
end

face = face+1;

fclose(fid);


function [tline] = skip_comment_blank_line(fid,rewind)
% skip empty and comment lines
% get next content line
% if rewind==1, then rewind to the starting of the content line
tline = '';
if rewind==1    
    pos = ftell(fid);
end
while (~feof(fid) && (isempty(tline) || (lower(tline(1))~='v' && lower(tline(1))~='f')))
    if rewind==1
        pos = ftell(fid);
    end
    tline = strtrim(fgets(fid));
end
if rewind==1
    fseek(fid, pos,-1);
end