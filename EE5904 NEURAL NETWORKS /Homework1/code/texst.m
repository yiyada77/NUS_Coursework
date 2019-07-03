%COMPLEMENT
subplot(2,2,3);
x=[0.5,0.5,0.5];
y=[1,10,-10];
plot(x,y);
hold on;
a1=[1];
b1=[0];
a11=[0];
b11=[0];
scatter(a1,b1,'b','x');
hold on;
scatter(a11,b11,'r','o');
axis([-0.5,1.5,-0.5,1]);
xlabel('x');
title('COMPLEMENT');
