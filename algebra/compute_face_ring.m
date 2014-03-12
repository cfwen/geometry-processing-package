function fr = compute_face_ring(face)

fr = zeros(size(face));
nf = size(face,1);
[~,eif] = compute_edge(face);
ind = eif(:,1)>0 & eif(:,2)>0;
eif2 = eif(ind,:);
amf = sparse(eif2(:,1),eif2(:,2),ones(size(eif2,1),1),nf,nf);
fr(:,1);
