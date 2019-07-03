%ini
close all;clear;clc;

format short e
t  =  (1900:10:1990)';
b = [75.995;91.972;105.711;123.203;131.669;150.697;179.323;203.212;226.505;249.633];
A = [t.^0,t.^1, t.^2,t.^3];
x=(A'*A)\(A'*b);
disp('x using normal equation:'), disp(x')

[Q,R]=qr(A);
Qs=Q(:,1:4); Rs=R(1:4,:);
x=Rs\Qs'*b;
disp('x using QR decomposition:'), disp(x')

[U,S,V]=svd(A);
s=diag(S);
disp('singular values:'), disp(s')
bt=U'*b;
y=bt(1:4)./s;
x=V*y;
disp('x using SVD, all singular values:'), disp(x')
disp('||Ax-b||:'), disp(norm(A*x-b))

y(4)=0;
x=V*y;
disp('x using SVD, 3 singular values:'), disp(x')
disp('||Ax-b||:'), disp(norm(A*x-b))

