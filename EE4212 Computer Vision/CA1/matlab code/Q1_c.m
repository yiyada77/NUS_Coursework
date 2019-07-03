%init
close all;clear;clc;

%load file
load('pts.txt');
load('pts_prime.txt');

%reshape A pts
A=zeros(600,12);
for i=0:199
    m=3*i+1;
    n=i+1;
    k=0;
    for j=0:2
        A(m+j,1+k:3+k)=pts(n,1:3);
        A(m+j,4+k)=1;
        k=k+4;
    end
end
%reshape b pts_prime
b=zeros(600,1);
for i=0:199
    m=3*i+1;
    for j=1:3
    b(m)=pts_prime(i+1,j);
    m=m+1;
    end
end
%SVD
[U,D,V]=svd(A);
D=diag(D);
bt=U'*b;
y=bt(1:12)./D;
x=V*y;

%reshape x to R and T
X=reshape(x,[4,3]);
R=X(1:3,1:3);
T=X(4,:);
det_R=det(R);

disp('Translation T is:'), disp(T')
disp('Rotation R is:'), disp(R)
disp('Determinant R is:'), disp(det_R)