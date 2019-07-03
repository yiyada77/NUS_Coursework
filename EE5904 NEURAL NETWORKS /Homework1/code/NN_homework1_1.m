%ini
clc;clf;clear;

%logistic func
figure(1);
x=-10:0.01:10;
a=1+exp(-x);
y=1./a;
plot(x,y);
axis([-10,10,-0.5,1.5]);
xlabel('v');ylabel('¦Õ(v)');
title('1.logistic func');

%gaussian func
figure(2);
x=-10:0.01:10;
a=-0.5.*x.*x;
y=exp(a);
plot(x,y);
axis([-10,10,-0.5,1.5]);
xlabel('v');ylabel('¦Õ(v)');
title('2.gaussian func');

%softsign func
figure(3);
x=-10:0.01:10;
a=1+abs(x);
y=x./a;
plot(x,y);
axis([-10,10,-1.5,1.5]);
xlabel('v');ylabel('¦Õ(v)');
title('3.softsign func');