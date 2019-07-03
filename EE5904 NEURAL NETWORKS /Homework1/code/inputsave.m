%and
x=[0,0,1,1;0,1,0,1];
d=[0,0,0,1];
w=rand(1,3);
x=[ones(1,4);x];
%Plot Result
figure(2);
scatter([0,0,1],[0,1,0],'r','d');
hold on;
grid on;
scatter(1,1,'b','y');
axis([-1,2,-1,2]);
x=-5:0.01:5;
y=x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y,'LineWidth',3);
title('Decision Boundary of AND');

%or
x=[0,0,1,1;0,1,0,1];
d=[0,1,1,1];
w=rand(1,3);
x=[ones(1,4);x];
%Plot Result
figure(2);
scatter(0,0,'r','d');
hold on;
grid on;
scatter([0,1,1],[1,0,1],'b','y');
axis([-1,2,-1,2]);
x=-5:0.01:5;
y=x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y,'LineWidth',3);
title('Decision Boundary of OR');

%COMPLEMENT
x=[0,1];
d=[1,0];
w=rand(1,2);
x=[ones(1,2);x];
%Plot Result
figure(2);
scatter(1,0,'r','d');
hold on;
grid on;
scatter(0,0,'b','y');
axis([-1,2,-1,2]);
x=-w(1)/w(2);
line([x x],[-1 2],'LineWidth',3);
title('Decision Boundary of COMPLEMENT');

%nand
x=[0,0,1,1;0,1,0,1];
d=[1,1,1,0];
w=rand(1,3);
x=[ones(1,4);x];
%Plot Result
figure(2);
scatter(1,1,'r','d');
hold on;
grid on;
scatter([0,0,1],[0,1,0],'b','y');
axis([-1,2,-1,2]);
x=-5:0.01:5;
y=x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y,'LineWidth',3);
title('Decision Boundary of NAND');
