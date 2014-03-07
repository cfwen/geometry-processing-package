function vr = compute_vertex_ring(face,vc,ordered)
narginchk(1,3);
% number of vertex, assume face are numbered from 1, and in consective
% order
nv = max(max(face));
if nargin == 1
    ordered = false;
	vc = (1:nv)';
elseif nargin == 2
    ordered = false;
end
if isempty(vc) || ~ordered
    vc = (1:nv)';
end
vr = cell(size(vc));
bd = compute_bd(face);
isbd = false(nv,1);
isbd(bd) = true;
if ~ordered
    [am,~] = compute_adjacency_matrix(face);
    [I,J,~] = find(am);
    vr = cell(nv,1);
    for i = 1:length(I)
        vr{I(i)}(end+1) = J(i);
    end
end

if ordered
    [vvif,nvif,pvif] = compute_connectivity(face);
    for i = 1:size(vc,1)
        fs = vvif(vc(i),:);
        v1 = full(find(fs,1,'first'));
        if isbd(vc(i))
            while vvif(v1,vc(i))
                f2 = full(vvif(v1,vc(i)));
                v1 = full(pvif(f2,v1));
            end
        end
        vi = v1;
        v0 = v1;
        while vvif(vc(i),v1)
            f1 = full(vvif(vc(i),v1));
            v1 = full(nvif(f1,v1));
            vi = [vi,v1];
            if v0 == v1
                break;
            end
        end
        vr{i} = vi;
    end
end
if size(vc,1) == 1
    vr = vr{1};
end
