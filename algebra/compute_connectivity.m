function [vvif,nvif,pvif] = compute_connectivity(face)
            
fi = face(:,1);
fj = face(:,2);
fk = face(:,3);
ff = (1:size(face,1))';
vvif = sparse([fi;fj;fk],[fj;fk;fi],[ff;ff;ff]);
nvif = sparse([ff;ff;ff],[fi;fj;fk],[fj;fk;fi]);
pvif = sparse([ff;ff;ff],[fj;fk;fi],[fi;fj;fk]);
