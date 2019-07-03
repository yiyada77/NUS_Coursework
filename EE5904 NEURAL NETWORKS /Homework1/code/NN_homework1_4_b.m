%init
clc;clf;clear;

%para
eta=0.1;
i=1;
t=0;
epoch=100;
w0=zeros(1,epoch);
w1=zeros(1,epoch);
e1=zeros(1,epoch);

%input
x=[1,0;1,0.8;1,1.6;1,3;1,4;1,5];
d=[0.5;1;4;5;6;8];
w=rand(1,2);
a=x'*x;
b=a^-1;
c=b*x'*d;


%learning procedure
while (t<epoch)
    w0(i)=w(1);
    w1(i)=w(2);
    
    y=w*x';
    e=d-y';
    e1(i)=(e'*e)/2;
    w=w+eta*e'*x; 
    
    t=t+1;
    i=i+1;
end

%Plot Trajectory of weights
figure(1);
x=1:100;
plot(x,w0,'color','r','LineWidth',1);
hold on;
plot(x,w1,'color','b','LineWidth',1);
hold on;
axis([0,100,-1,10^68]);
legend('w0','W1');
title('Trajectory of weights of LMS');
xlabel('x');
ylabel('y');

%Plot Trajectory of error
figure(2);
epoch=1:100;
plot(epoch,e1,'color','b','LineWidth',1);
hold on;
title('Error function versus epochs');
xlabel('epoch');
ylabel('Average error');

%fitting result LLS and LMS
k1=c(2);
j1=c(1);
figure(3);
x=-1:10;
y1=k1.*x+j1;
k2=w(2);
j2=w(1);
y2=k2.*x+j2;
plot(x,y1,'color','r','LineWidth',1);
hold on;
plot(x,y2,'color','k','LineWidth',1);
hold on;
scatter([0,0.8,1.6,3,4,5],[0.5,1,4,5,6,8],'r','o');
axis([-1,12,-1,12]);
title('Linear Regression of LLS and LMS');
xlabel('x');
ylabel('y');