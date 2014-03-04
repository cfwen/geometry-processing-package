function fa = face_area(face,vertex)

narginchk(2,2);
fi = face(:,1);
fj = face(:,2);
fk = face(:,3);
vij = vertex(fj,:)-vertex(fi,:);
vjk = vertex(fk,:)-vertex(fj,:);
vki = vertex(fi,:)-vertex(fk,:);
a = sqrt(dot(vij,vij,2));
b = sqrt(dot(vjk,vjk,2));
c = sqrt(dot(vki,vki,2));
s = (a+b+c)/2.0;
fa = sqrt(s.*(s-a).*(s-b).*(s-c));