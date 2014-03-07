function A = generalized_laplacian(face,uv,mu)
% 
af = (1-2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
bf = -2*imag(mu)./(1.0-abs(mu).^2);
gf = (1+2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
fa = face_area(face,uv);

f0 = face(:,1);
f1 = face(:,2);
f2 = face(:,3);
uxv0 = uv(f1,2) - uv(f2,2);
uyv0 = uv(f2,1) - uv(f1,1);
uxv1 = uv(f2,2) - uv(f0,2);
uyv1 = uv(f0,1) - uv(f2,1); 
uxv2 = uv(f0,2) - uv(f1,2);
uyv2 = uv(f1,1) - uv(f0,1);

v00 = (af.*uxv0.*uxv0 + 2*bf.*uxv0.*uyv0 + gf.*uyv0.*uyv0)./fa;
v11 = (af.*uxv1.*uxv1 + 2*bf.*uxv1.*uyv1 + gf.*uyv1.*uyv1)./fa;
v22 = (af.*uxv2.*uxv2 + 2*bf.*uxv2.*uyv2 + gf.*uyv2.*uyv2)./fa;

v01 = (af.*uxv1.*uxv0 + bf.*uxv1.*uyv0 + bf.*uxv0.*uyv1 + gf.*uyv1.*uyv0)./fa;
v12 = (af.*uxv2.*uxv1 + bf.*uxv2.*uyv1 + bf.*uxv1.*uyv2 + gf.*uyv2.*uyv1)./fa;
v20 = (af.*uxv0.*uxv2 + bf.*uxv0.*uyv2 + bf.*uxv2.*uyv0 + gf.*uyv0.*uyv2)./fa;

I = [f0;f1;f2;f0;f1;f1;f2;f2;f0];
J = [f0;f1;f2;f1;f0;f2;f1;f0;f2];
V = [v00;v11;v22;v01;v01;v12;v12;v20;v20];
A = sparse(I,J,-V);
