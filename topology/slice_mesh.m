function newTR = sliceMesh(TR,boundary)

%{
**************************************************************
function newTR = sliceMesh(TR,boundary)

To slice the closed mesh along a loop 

input: 
TR: triangulation of the surface
boundary: loop in form of cell

output:
newTR: triangulation of the sliced surface
*************************************************************
%}

%%initializtion
V = TR.Points;
F = TR.ConnectivityList;
vNum = size(V,1);

bounList = cell2mat(boundary);
bounLen = size(bounList,1);

%%copy the loop boundary with a new set of vertex
newV = zeros(vNum+bounLen,3);
newV(1:vNum,:) = V(:,:);
newV((vNum+1):(vNum+bounLen),:) = V(bounList(:),:);
newF = F;

for vertex = 1:bounLen
    %%for each vertex, find the edge along it
    centreVertex = bounList(vertex);
    lastVertex = bounList(mod(vertex-1+bounLen-1,bounLen)+1);
    nextVertex = bounList(mod(vertex-1+bounLen+1,bounLen)+1);

    %%divide its neighbouring vertex into two sides
    [~,side2] = divideVertex(TR,centreVertex,lastVertex,nextVertex);
    side2List = cell2mat(side2);
    side2Len = size(side2List,1);
    
    %%update all the faces of a side with the new vertex index
    for neigh = 1:side2Len
        neighFace = edgeAttachments(TR,centreVertex,side2List(neigh));
        nfList = cell2mat(neighFace);
        for face = 1:size(nfList,2)
            [~,col] = find(F(nfList(face),:) == centreVertex,1,'first');
            newF(nfList(face),col) = vNum+vertex;
        end
    end
    if side2Len == 0
        neighFace = edgeAttachments(TR,lastVertex,centreVertex);
        nfList = cell2mat(neighFace);
        for face = 1:size(nfList,2)
            [~,colL] = find(F(nfList(face),:) == lastVertex,1,'first');
            [~,colC] = find(F(nfList(face),:) == centreVertex,1,'first');
            if (colC == 1 && colL == 2) || (colC == 2 && colL == 3) || (colC == 3 && colL == 1)
                newF(nfList(face),colC) = vNum+vertex;
            end
        end
    end
end

newTR = triangulation(newF,newV);