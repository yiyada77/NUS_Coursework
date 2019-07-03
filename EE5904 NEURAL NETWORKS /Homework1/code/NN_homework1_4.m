x=[1,0;1,0.8;1,1.6;1,3;1,4;1,5];
d=[0.5;1;4;5;6;8];

a=x'*x;
b=a^-1;
c=b*x'*d;
k=c(2);
j=c(1);
%Plot Trajectory of weights
figure(1);
x=-10:10;
y=k.*x+j;
plot(x,y,'color','g','LineWidth',1.5);
hold on;
scatter([0,0.8,1.6,3,4,5],[0.5,1,4,5,6,8],'r','o');
axis([-1,12,-1,12]);
title('Linear Regression of LLS');
xlabel('x');
ylabel('y');