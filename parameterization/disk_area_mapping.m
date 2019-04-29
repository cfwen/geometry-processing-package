%% disk area-preserving mapping, by changing the laplacian wij propotional to area difference
 % A Novel Stretch Energy Minimization Algorithm for Equiareal Parameterizations  Mei-Heng Yueh  Wen-Wei Lin  Chin-Tien Wu  Shing-Tung Yau 

%% Syntax  uv_new = disk_area_mapping(face,vertex,uv, LandMkId,LandMkPos)
 %
%% Description:
% Compute equal-areal mapping with landmark assignment. IF you don't want any landmark, leave LandMkId,LandMkPos blank.
% 
%% Example

%% Contribution
%  Author : Yanshuai Tu
%  Created: 2018/05/07
%  Revised: 
% 
%  2018 Geometry Systems Laboratory 
%  CIDSE, ASU, http://gsl.lab.asu.edu

function uv_new = disk_area_mapping(face,vertex,uv, LandMkId,LandMkPos)

if(nargin ==3)
    
    LandMkId=[];
    LandMkPos=[];
end


bd = compute_bd(face);

% set landmark and desired location



% B: Boundary inds
% I: Interier
%  N:  size(f,1)
N = 1:size(uv,1);
b1 = 1:size(bd,1);
b2 = size(bd,1)+1:size(bd,1)+size(LandMkId,1);
B = [bd; LandMkId];
I = setdiff(N, B);


uv_new  = uv;
L = Laplace(face, vertex, uv);
fin = -L(I,I)\(L(I,B)*uv_new(B,:));
uv_new(I,:) = fin;

L = Laplace(face, vertex, uv_new);
for k=1:200
    
    f1 = uv_new;
    
    fbd  = - L(B,B)\L(B,I)*uv_new(I,:);
    
    bdf= fbd(b1,:);
    bdf = bdf -mean(bdf,1);
    
    dl = sqrt(dot(bdf,bdf,2));
    uv_new(bd,:) =  bdf./[dl dl];
    
    
    % force landmark to be there
    uv_new(B(b2),:) = LandMkPos;
    
    % update interier
    
    fin = -L(I,I)\L(I,B)*uv_new(B,:);
    uv_new(I,:) = fin;
    
    
    L = Laplace(face, vertex, uv_new);
    
    
    
    
    maxdf = max(dot(uv_new -f1, uv_new -f1, 2));
    fprintf('maxdf = %f\n',maxdf);
    
    if(maxdf < 1e-6)
        break       
    end
end


end

%% Laplace
function A = Laplace(face, vertex, f)

[edge,eif] = compute_edge(face);
ne = size(edge,1);
ew = zeros(ne,1);
ind = eif(:,1)>0;
ev1 = sum(face(eif(ind,1),:),2) - sum(edge(ind,:),2);


fi = f(edge(ind,1),:);
fj = f(edge(ind,2),:);
fk = f(ev1,:);

vi = vertex(edge(ind,1),:);
vj = vertex(edge(ind,2),:);
vk = vertex(ev1,:);

ew(ind) = ew(ind) + dot(fi - fk, fj -fk,2)./(2* triangle_area(vi,vj,vk));


ind = eif(:,2)>0;
ev2 = sum(face(eif(ind,2),:),2) - sum(edge(ind,:),2);


fi = f(edge(ind,1),:);
fj = f(edge(ind,2),:);
fk = f(ev2,:);

vi = vertex(edge(ind,1),:);
vj = vertex(edge(ind,2),:);
vk = vertex(ev2,:);


ew(ind) = ew(ind) + dot(fi - fk, fj -fk,2)./(2* triangle_area(vi,vj,vk));


A = sparse([edge(:,1);edge(:,2)],[edge(:,2);edge(:,1)],[ew;ew]/2);
sA = sum(A,2);
A = A - diag(sA);

end



%% return the triangle areas
function ta = triangle_area(vi,vj,vk)

vij = vj-vi;
vjk = vk-vj;
vki = vi-vk;
a = sqrt(dot(vij,vij,2));
b = sqrt(dot(vjk,vjk,2));
c = sqrt(dot(vki,vki,2));
s = (a+b+c)/2.0;
ta = sqrt(s.*(s-a).*(s-b).*(s-c));
end





 
