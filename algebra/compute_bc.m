function mu = compute_bc(face,uv,vertex)

nf = size(face,1);
fa = face_area(face,uv);
Duv = (uv(face(:,[3 1 2]),:) - uv(face(:,[2 3 1]),:));
Duv(:,1) = Duv(:,1)./[fa;fa;fa]/2;
Duv(:,2) = Duv(:,2)./[fa;fa;fa]/2;

switch size(vertex,2)
    case 2
        z = complex(vertex(:,1), vertex(:,2));
        Dcz = sum(reshape((Duv(:,2)-1i*Duv(:,1)).*z(face,:),nf,3),2);
        Dzz = sum(reshape((Duv(:,2)+1i*Duv(:,1)).*z(face,:),nf,3),2);
        mu = Dcz./Dzz;
    case 3
        du = zeros(nf,3);
        du(:,1) = sum(reshape(Duv(:,2).*vertex(face,1),nf,3),2);
        du(:,2) = sum(reshape(Duv(:,2).*vertex(face,2),nf,3),2);
        du(:,3) = sum(reshape(Duv(:,2).*vertex(face,3),nf,3),2);
        dv = zeros(nf,3);
        dv(:,1) = sum(reshape(Duv(:,1).*vertex(face,1),nf,3),2);
        dv(:,2) = sum(reshape(Duv(:,1).*vertex(face,2),nf,3),2);
        dv(:,3) = sum(reshape(Duv(:,1).*vertex(face,3),nf,3),2);

        E = dot(du,du,2);
        G = dot(dv,dv,2);
        F = -dot(du,dv,2);
        mu = (E - G + 2 * 1i * F) ./ (E + G + 2*sqrt(E.*G - F.^2));
    otherwise
        error('Dimension of target mesh must be 3 or 2.')
end
return

% nf = size(face,1);
% e1 = uv(face(:,3),:) - uv(face(:,2),:);
% e2 = uv(face(:,1),:) - uv(face(:,3),:);
% e3 = uv(face(:,2),:) - uv(face(:,1),:);
% 
% fa = face_area(face,uv);        
% Mx =  [e1(:,2);e2(:,2);e3(:,2)]./[fa;fa;fa]/2;
% My = -[e1(:,1);e2(:,1);e3(:,1)]./[fa;fa;fa]/2;
% 
% I = (1:nf)';
% Dx = sparse([I;I;I],face(:),Mx);
% Dy = sparse([I;I;I],face(:),My);
% switch size(vertex,2)
%     case 2
%         z = complex(vertex(:,1), vertex(:,2));
%         Dz = (Dx - 1i*Dy)/2;
%         Dc = (Dx + 1i*Dy)/2;
%         mu = (Dc*z)./(Dz*z);
%     case 3
%         dxdu = Dx*vertex(:,1);
%         dxdv = Dy*vertex(:,1);
%         
%         dydu = Dx*vertex(:,2);
%         dydv = Dy*vertex(:,2);
%         
%         dzdu = Dx*vertex(:,3);
%         dzdv = Dy*vertex(:,3);
%         
%         E = dxdu.^2 + dydu.^2 + dzdu.^2;
%         G = dxdv.^2 + dydv.^2 + dzdv.^2;
%         F = dxdu.*dxdv + dydu.*dydv + dzdu.*dzdv;
% 
%         mu = (E - G + 2 * 1i * F) ./ (E + G + 2*sqrt(E.*G - F.^2));        
%     otherwise
%         error('Dimension must be 3 or 2.')
% end
