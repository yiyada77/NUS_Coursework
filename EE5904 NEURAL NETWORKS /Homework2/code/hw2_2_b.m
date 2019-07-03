%init
close all;clear;clc;

%desired figure
x=-3:0.01:3;
y=1.2*sin(pi*x)-cos(2.4*pi*x);

%set training set domain[-1.6,1.6] uniform step 0.05
x_train=-1.6:0.05:1.6;
y_train=1.2*sin(pi*x_train)-cos(2.4*pi*x_train);

%n=1,2,3,4,5,6,7,8,9,10,20,50,100
n=8;
%% specify the structure and learning algorithm for MLP 
net = feedforwardnet(n,'trainbr'); 
net.layers{1}.transferFcn = 'tansig';%tansig is the preferred in hidden neurons
net.layers{2}.transferFcn = 'purelin';%purelin for regression 
net = configure(net,x_train,y_train); 
net.trainparam.lr=0.01;%learning rate
net.trainparam.epochs=10000; 
net.trainparam.goal=1e-8; 
net.divideParam.trainRatio=1.0; 
net.divideParam.valRatio=0.0; 
net.divideParam.testRatio=0.0; 
%% Train the MLP
[net,tr]=train(net,x_train,y_train);%train the MLP

%set test set domain[-1.6,1.6] uniform step 0.01
x_test=-1.6:0.01:1.6;

%plot
figure(1);
plot(x,y);%desired output
hold on;
net_output=sim(net,x_test);
plot(x_test,net_output,'o','color','m');%MLP Output
hold on;
pred_output=sim(net,x);
plot(x,pred_output,'+','color','g');%Pred Output
hold on;
legend('Desired Output','MLP Output','Pred Output');
title(['n = ',num2str(n)]);
