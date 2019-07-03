%init
close all;clear;clc;

%load dataset
load('spamData.mat');%1 = spam, 0 = not spam

%binarization
bina_train=Xtrain>0;Xtrain(bina_train)=1;Xtrain(~bina_train)=0;
bina_test=Xtest>0;Xtest(bina_test)=1;Xtest(~bina_test)=0;

ytrain_spam=sum(ytrain);%count number of 1 spam in dataset
lambda_1_spam=ytrain_spam/3065;% prior probobility for training
lambda_0_not_spam=1-lambda_1_spam;

%split Xtrain into two parts one is ytrain=1 and another is ytrain=0
ind_1=find(ytrain~=0);% 1 -1191 find spam
ind_0=find(ytrain==0);% 0 -1874 find not spam
train_spam=zeros(length(ind_1),57);%initialize the vector to save two parts dataset
train_not_spam=zeros(length(ind_0),57);
for i_spam=1:length(ind_1)
    train_spam(i_spam,:)=Xtrain(ind_1(i_spam),:);%all the spam data saved in train_spam
end
for i_not_spam=1:length(ind_0)
    train_not_spam(i_not_spam,:)=Xtrain(ind_0(i_not_spam),:);%all the not spam data saved in train_not_spam
end

%calculate number of P(a=1|y=1)&P(a=1|y=0)&P(a=0|y=1)&P(a=0|y=0)
number_spam_x1=zeros(1,57);    
for j1=1:57
    tmp_count_fea=sum(train_spam(:,j1));
    number_spam_x1(j1)=tmp_count_fea;%the number of feature=1 & y=1
end
number_not_spam_x1=zeros(1,57);
for j2=1:57
    tmp_count_fea=sum(train_not_spam(:,j2));
    number_not_spam_x1(j2)=tmp_count_fea;%the number of feature=1 & y=0
end
number_spam_x0=i_spam*ones(1,57)-number_spam_x1;%the number of feature=0 & y=1
number_not_spam_x0=i_not_spam*ones(1,57)-number_not_spam_x1;%the number of feature=0 & y=0

alpha=0:0.5:100;
N=length(alpha);
error_rate_train=zeros(1,N);%initialize the vector to record error rate
error_rate_test=zeros(1,N);

%naive bayes
for i=1:N %Beta(alpha,alpha)
    error_train=0;
    error_test=0;   
    a=alpha(i); 

    %training dataset
    for m=1:3065 %Xtrain=m*n=3065*57
        total_log_y1=log(lambda_1_spam);
        total_log_y0=log(lambda_0_not_spam);      
        for n=1:57
            if Xtrain(m,n)==1
                %Laplacian correction Beta£¨a,a)
                p_log_y1=log(number_spam_x1(n)+a)-log(ytrain_spam+2*a);%y=1&x=1
                p_log_y0=log(number_not_spam_x1(n)+a)-log(3065-ytrain_spam+2*a);%y=0&x=1
            else
                p_log_y1=log(number_spam_x0(n)+a)-log(ytrain_spam+2*a);%y=1&x=0
                p_log_y0=log(number_not_spam_x0(n)+a)-log(3065-ytrain_spam+2*a);%y=0&x=0
            end
            total_log_y1=total_log_y1+p_log_y1;
            total_log_y0=total_log_y0+p_log_y0;
        end
        %calculate error rate
        if (total_log_y1>total_log_y0)==ytrain(m)
            error_train=error_train+0;
        else
            error_train=error_train+1;
        end
    end
    error_rate_train(i)=error_train./3065;
    
    %test dataset
    for m=1:1536 %Xtest=m*n=1536*57
        total_log_y1=log(lambda_1_spam);
        total_log_y0=log(lambda_0_not_spam);
        for n=1:57
            if Xtest(m,n)==1
                %Laplacian correction Beta£¨a,a)
                p_log_y1=log(number_spam_x1(n)+a)-log(ytrain_spam+2*a);%y=1&x=1
                p_log_y0=log(number_not_spam_x1(n)+a)-log(3065-ytrain_spam+2*a);%y=0&x=1
            else
                p_log_y1=log(number_spam_x0(n)+a)-log(ytrain_spam+2*a);%y=1&x=0
                p_log_y0=log(number_not_spam_x0(n)+a)-log(3065-ytrain_spam+2*a);%y=0&x=0
            end
            total_log_y1=total_log_y1+p_log_y1;
            total_log_y0=total_log_y0+p_log_y0;
        end
        %calculate error rate
        if (total_log_y1>total_log_y0)==ytest(m)
            error_test=error_test+0;
        else
            error_test=error_test+1;
        end
    end
    error_rate_test(i)=error_test./1536;
end

%plot figure
figure(1);
plot(alpha,error_rate_train,'--','LineWidth',1.5);
hold on;
plot(alpha,error_rate_test,':','LineWidth',1.5);
hold on;
legend('training error','test error');
title('training and test error rates versus alpha');
xlabel('alpha');
ylabel('error rate');