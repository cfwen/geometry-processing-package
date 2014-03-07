function [he,heif] = compute_halfedge(face)
nf = size(face,1);
he = [reshape(face',nf*3,1),reshape(face(:,[2 3 1])',nf*3,1)];
heif = reshape(repmat(1:nf,[3,1]),nf*3,1);
