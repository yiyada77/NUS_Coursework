%init
close all;clear;clc;

%load dataset
load('spamData.mat');%1 = spam, 0 = not spam

%log-transform
xtrain=log(Xtrain+0.1);
xtest=log(Xtest+0.1);

K=[1:10 15:5:100];%Neighbors K
distance=zeros(1536,3065);%record each feature distance
class=zeros(1,1536);%record each test dataset class
error_rate_train=zeros(1,length(K));%initialize the vector to record error rate per K
error_rate_test=zeros(1,length(K));

%KNN
%training dataset
%measure distance by Euclidean dist(a,b)=(sum(ai-bi)^2)^0.5
for m=1:3065
    total_dis=zeros(1,3065);
    for i=1:3065
        dist_x=zeros(1,57);
        for n=1:57
            dist_x(n)=(xtrain(m,n)-xtrain(i,n)).^2;
        end
        total_dis(i)=sum(dist_x);
    end
    distance(m,:)=total_dis.^0.5;
end
for j=1:length(K)
    k=K(j);
    max_count=0;
    for i=1:3065
        combine_distance=[distance(i,:);ytrain'];%distance(i,:)1*3065/ytrain 3065*1
        order_distance=sortrows(combine_distance');%3065*2
        sum_distance=sum(order_distance(1:k,2));
        if(sum_distance>k/2)==ytrain(i,1)
            max_count=max_count+1;
        end
    end
    error_rate_train(j)=1-max_count/3065;
end
%testing dataset
%measure distance by Euclidean dist(a,b)=(sum(ai-bi)^2)^0.5
for m=1:1536
    total_dis=zeros(1,3065);
    for i=1:3065
        dist_x=zeros(1,57);
        for n=1:57     
            dist_x(n)=(xtest(m,n)-xtrain(i,n)).^2;
        end
        total_dis(i)=sum(dist_x);
    end
    distance(m,:)=total_dis.^0.5;
end
for j=1:length(K)
    k=K(j);
    max_count=0;
    for i=1:1536       
        combine_distance=[distance(i,:);ytrain'];%distance(i,:)1*3065/ytrain=3065*1
        order_distance=sortrows(combine_distance');%3065*2
        sum_distance=sum(order_distance(1:k,2));
        if(sum_distance>k/2)==ytest(i,1)
            max_count=max_count+1;
        end
    end
    error_rate_test(j)=1-max_count/1536;
end

%plot figure
figure(1);
plot(K,error_rate_train,'--','LineWidth',1.5);
hold on;
plot(K,error_rate_test,':','LineWidth',1.5);
hold on;
legend('training error','test error');
title('training and test error rates versus K');
xlabel('K');
ylabel('error rate');
