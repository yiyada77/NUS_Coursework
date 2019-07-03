%init
clc;clf;clear;

%plot axis
figure(1);
x=-10:0.01:10;
a=x./(1-x);
y=log(a);
plot(x,y);
axis([-10,10,-10,10]);
xlabel('v');ylabel('¦Õ(v)');
title('1.logistic func');