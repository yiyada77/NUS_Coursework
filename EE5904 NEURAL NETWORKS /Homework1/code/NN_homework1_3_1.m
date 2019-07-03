%init
clc;clf;clear;

%AND
subplot(2,2,1);
x=-5:0.01:5;
y=1.7-x;
a1=[0,0,1];
b1=[0,1,0];
a11=[1];
b11=[1];
scatter(a1,b1,'r','d');
hold on;
scatter(a11,b11,'b','x');
plot(x,y);
axis square;
grid on;
axis([0,2,0,2]);
xlabel('x_1');
ylabel('x_2');
title('AND');
box on

%OR 
subplot(2,2,2);
x=-5:0.01:5;
y=0.3-x;
a1=[1,0,1];
b1=[1,1,0];
a11=[0];
b11=[0];
scatter(a1,b1,'b','x');
hold on;
scatter(a11,b11,'r','d');
plot(x,y);
axis square;
grid on;
axis([0,2,0,2]);
xlabel('x_1');
ylabel('x_2');
title('OR');
box on


%COMPLEMENT
subplot(2,2,3);
x=[0.5,0.5,0.5];
y=[1,10,-10];
plot(x,y);
axis square;
grid on;
hold on;
a1=[1];
b1=[0];
a11=[0];
b11=[0];
scatter(a1,b1,'b','x');
hold on;
scatter(a11,b11,'r','d');
axis([0,2,0,2]);
xlabel('x');
title('COMPLEMENT');

%NAND
subplot(2,2,4);
x=-5:0.01:5;
y=1.7-x;
a1=[0,0,1];
b1=[0,1,0];
a11=[1];
b11=[1];
scatter(a1,b1,'b','x');
hold on;
scatter(a11,b11,'r','d');
plot(x,y);
axis square;
grid on;
axis([0,2,0,2]);
xlabel('x_1');
ylabel('x_2');
title('NAND');
box on