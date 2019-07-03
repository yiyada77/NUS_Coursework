%init
close all;clear;clc;

%desired figure
x=-3:0.01:3;
y=1.2*sin(pi*x)-cos(2.4*pi*x);

%set training set domain[-1.6,1.6] uniform step 0.05
x_train=-1.6:0.01:1.6;
y_train=1.2*sin(pi*x_train)-cos(2.4*pi*x_train);

%n=1,2,3,4,5,6,7,8,9,10,20,50,100
n=8;
epochs=100;
total_num=size(x_train,2);
%µ÷ÓÃsequential trainº¯Êý 
[ net, accu_train, accu_val ]=train_seq( n, x_train, y_train, total_num, 0, epochs );

%set test set domain[-1.6,1.6] uniform step 0.01
x_test=-1.6:0.01:1.6;

%plot
figure(1);
plot(x,y);%Desired Output
hold on;
MLP_output=net(x_test);
plot(x_test,MLP_output,'o','color','m');%MLP Output
hold on;
pred_output=sim(net,x);
plot(x,pred_output,'+','color','g');%Pred Output
hold on;
legend('Desired Output','MLP Output','Pred Output');
title(['n = ',num2str(n)]);
