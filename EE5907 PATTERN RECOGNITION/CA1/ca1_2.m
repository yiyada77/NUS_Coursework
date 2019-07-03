%init
close all;clear;clc;

%load dataset
load('spamData.mat');%1 = spam, 0 = not spam

%log-transform
xtrain=log(Xtrain+0.1);
xtest=log(Xtest+0.1);

ytrain_spam=sum(ytrain);%count number of 1 spam in dataset
lambda_1_spam=ytrain_spam/3065;% prior probobility for training
lambda_0_not_spam=1-lambda_1_spam;

%calculation mu&sigma both y=1&y=0
mu_mean_y1=mean(xtrain(ytrain==1,:),1);
mu_mean_y0=mean(xtrain(ytrain==0,:),1);
sigma_std_y1=std(xtrain(ytrain==1,:),1);
sigma_std_y0=std(xtrain(ytrain==0,:),1);

correct_train=0;
correct_test=0; 
%naive bayes
%train 
for m=1:3065%xtrain=m*n=3065*57
    total_log_y1=log(lambda_1_spam);
    total_log_y0=log(lambda_0_not_spam);  
    for n=1:57
        p_y1=normpdf(xtrain(m,n),mu_mean_y1(1,n),sigma_std_y1(1,n));%gussian probobility y=1
        p_y0=normpdf(xtrain(m,n),mu_mean_y0(1,n),sigma_std_y0(1,n));%gussian probobility y=0
        total_log_y1=total_log_y1+log(p_y1);
        total_log_y0=total_log_y0+log(p_y0);         
    end
    if(total_log_y1>total_log_y0)==ytrain(m)
       correct_train=correct_train+1;
    end
    %calculate error rate
    error_train=1-(correct_train./3065);
end
%test
for m=1:1536%xtest=m*n=1536*57
    total_log_y1=log(lambda_1_spam);
    total_log_y0=log(lambda_0_not_spam);  
    for n=1:57
        p_y1=normpdf(xtest(m,n),mu_mean_y1(1,n),sigma_std_y1(1,n));%gussian probobility y=1
        p_y0=normpdf(xtest(m,n),mu_mean_y0(1,n),sigma_std_y0(1,n));%gussian probobility y=0
        total_log_y1=total_log_y1+log(p_y1);
        total_log_y0=total_log_y0+log(p_y0);         
    end
    if(total_log_y1>total_log_y0)==ytest(m)
       correct_test=correct_test+1;
    end
    %calculate error rate
    error_test=1-(correct_test./1536);
end

