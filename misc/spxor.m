function C = spxor(A,B)
    [m,n] = size(A);
    [I1,J1,V1] = find(A);
    IJ1 = [I1,J1];
    [I2,J2,V2] = find(B);
    IJ2 = [I2,J2];
    [IJ12,k1] = setdiff(IJ1,IJ2,'rows');
    [IJ21,k2] = setdiff(IJ2,IJ1,'rows');
    IJ = [IJ12;IJ21];
    V = [V1(k1);V2(k2)];
    C = sparse(IJ(:,1),IJ(:,2),V,m,n);
end