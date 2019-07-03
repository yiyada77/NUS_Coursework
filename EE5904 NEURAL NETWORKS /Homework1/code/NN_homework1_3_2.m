%init
clc;clf;clear;

%para
eta=1;
t=0;
i=1;
max_loop=20;
w0=zeros(1,max_loop);
w1=zeros(1,max_loop);
w2=zeros(1,max_loop);

%XOR
x=[0,0,1,1;0,1,0,1];
d=[0,1,1,0];
w=rand(1,3);
x=[ones(1,4);x];

%learning procedure
while (t<max_loop)
    w0(i)=w(1);
    w1(i)=w(2);
    w2(i)=w(3);
    i=i+1;
    
    v=w*x;
    y=hardlim(v);
    e=d-y;
    w=w+eta*e*x'; 
    t=t+1;
end

%Plot Trajectory of weights
figure(1);
x=1:max_loop;
plot(x,w0,'o-','color','g','LineWidth',1.5);
hold on;
plot(x,w1,'d-','color','b','LineWidth',1.5);
hold on;
plot(x,w2,'p-','color','m','LineWidth',1.5);
hold on;
legend('w0','W1','W2');
axis([0,max_loop,-3,3]);
title('Trajectory of weights for XOR');
xlabel('t');
ylabel('w');

%Plot Result
figure(2);
scatter([1,0],[1,0],'r','d');
hold on;
grid on;
scatter([0,1],[1,0],'b','y');
axis([-1,2,-1,2]);
x=-5:0.01:5;
y=x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y,'LineWidth',3);
title('Decision Boundary of XOR');


