%init
close all;clear;clc;

%para
i=1;%iteration number

xr=zeros(1,1000);%init recording vector
yr=zeros(1,1000);
fr=zeros(1,1000);
ir=zeros(1,1000);

x=-1+2*rand;%random x,y
y=-1+2*rand;
dx=400*x^3-400*x*y+2*x-2;%derivation
dy=200*y-200*x^2;
dxx=1200.*x.^2-400.*y+2;
dyy=200;
dxy=-400.*x;
f=(1-x).^2+100.*(y-x.^2).^2;
H=[dxx,dxy;dxy,dyy];

while f>0.000001
    xr(i)=x;%recording trajectory
    yr(i)=y;
    fr(i)=f;
    ir(i)=i;
    
    dx=400*x^3-400*x*y+2*x-2;%derivation
    dy=200*y-200*x^2;
    dxx=1200.*x.^2-400.*y+2;
    dyy=200;
    dxy=-400.*x;
    H=[dxx,dxy;dxy,dyy];
    h=inv(H);
    
    x=x-h(1,1).*dx-h(1,2).*dy;%update
    y=y-h(2,1).*dx-h(2,2).*dy;
    f=(1-x).^2+100.*(y-x.^2).^2;
    i=i+1;
end

%plot out (x,y) trajectory 
figure(1);
plot(xr,yr,'o-','LineWidth',1.5);
hold on;
title('The trajectory of (x,y)');
xlabel('x');
ylabel('y');
%plot out function f value
figure(2);
plot(ir,fr,'o-','LineWidth',1.5);
hold on;
title('The function f(x,y) value versus iteration');
xlabel('iteration');
ylabel('f(x,y)');

x
y
f
i


