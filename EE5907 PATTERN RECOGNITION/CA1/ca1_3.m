%init
close all;clear;clc;

%load dataset
load('spamData.mat');%1 = spam, 0 = not spam

%log-transform
xtrain=log(Xtrain+0.1);
xtest=log(Xtest+0.1);

lambda=[1:10 15:5:100];%regulation parameter
xtrain=[ones(3065,1) xtrain];%replacing xi(D) with xi(D+1)
xtest=[ones(1536,1) xtest];
I = eye(57);
I = [zeros(57,1) I];%initialize I(D+1)*(D+1)
I = [zeros(1,58);I];
error_rate_train=zeros(1,length(lambda));%initialize the vector to record error rate
error_rate_test=zeros(1,length(lambda));
record_train=zeros(1,3065);
record_test=zeros(1,1536);

%Newton's method with l2 Regulation
for i=1:length(lambda)
    correct_train=0;
    correct_test=0;
    w=zeros(58,1);%initialize by w=0(57+1)
    w0=w(2:end);%w0 is w without first element
    mu_train=sigmf(xtrain*w,[1,0]);
    g=xtrain.'*(mu_train-ytrain);
    l=lambda(i);
    s=diag(mu_train.*(1-mu_train));
    H=xtrain.'*s*xtrain;
    NLL=-ytrain.'*log(mu_train)-(1-ytrain).'*log(1-mu_train);
    g(2:end)=g(2:end)+l*w0;%g_reg
    H=H+l*I;%H_reg
    NLL_reg=NLL+0.5*l*(w0.'*w0);
    w=w-pinv(H)*g;%update w
    e=1;
    while (e>0.000001)
        NLL_save=NLL_reg;%cave last NLL to compare
        w0=w(2:end);%w0 is w without first element
        mu_train=sigmf(xtrain*w,[1,0]);
        g=xtrain.'*(mu_train-ytrain);
        s=diag(mu_train.*(1-mu_train));
        H=xtrain.'*s*xtrain;
        NLL=-ytrain.'*log(mu_train)-(1-ytrain).'*log(1-mu_train);
        g(2:end)=g(2:end)+l*w0;%g_reg
        H=H+l*I;%H_reg
        NLL_reg=NLL+0.5*l*(w0.'*w0);
        w=w-pinv(H)*g;%update w
        e=abs(NLL_reg-NLL_save);%compare distance
    end
    record_train=(mu_train>0.5);%mu_train>0.5 so class=1
   
    for n=1:3065
        if record_train(n)==ytrain(n)
           correct_train=correct_train+1;
        end    
    end
    error_rate_train(i)=1-correct_train./3065;
    
    %test dataset
    mu_test=sigmf(xtest*w,[1,0]);
    record_test=(mu_test>0.5);
    for n=1:1536
        if record_test(n)==ytest(n)
           correct_test=correct_test+1;
        end  
        error_rate_test(i)=1-correct_test./1536;
    end
   
end

%plot figure
figure(1);
plot(lambda,error_rate_train,'--','LineWidth',1.5);
hold on;
plot(lambda,error_rate_test,':','LineWidth',1.5);
hold on;
legend('training error','test error');
title('training and test error rates versus lambda');
xlabel('lambda');
ylabel('error rate');