%init
close all;clear;clc;

%parameter
x_train=-1.6:0.08:1.6;%uniform step 0.08
x_test=-1.6:0.01:1.6;%uniform step 0.01
N=length(x_train);
x=randn(1,N);%random Gaussian noise for xtain not for xtest
d=1.2*sin(pi*x_train)-cos(2.4*pi*x_train)+0.3*x;%x with noise
%calculate phi
rand_index=randperm(N,20);% randomly choose centres 20
M=x_train(rand_index);
coef=length(M)/(-(max(M)-min(M))^2);
phi=zeros(N,length(M));%initialize phi
for i=1:N
    for j=1:length(M)
        r=x_train(i)-M(j);
        phi(i,j)=exp(coef*r^2);
    end
end
phi=[ones(N,1),phi];% bias
w=pinv(phi)*d';%get the unique solution w
%test data
phi_test=zeros(length(x_test),length(M));%initialize phi_test
for i=1:length(x_test)
    for j=1:length(M)
        r=x_test(i)-M(j);
        phi_test(i,j)=exp(coef*r^2);
    end
end
phi_test=[ones(length(x_test),1),phi_test];
d_test=phi_test*w;
ideal_test=1.2*sin(pi*x_test)-cos(2.4*pi*x_test);
error_train=sum((d-(phi*w)').^2)/N;%mse
error_test=sum((ideal_test-d_test').^2)/length(x_test);
figure(1)
plot(x_test,d_test,'LineWidth',1);
hold on;
plot(x_test,ideal_test,'--','LineWidth',1.5);
hold on;
plot(x_train,d,'*');
hold on;
axis([-1.6,1.6,-3,3]);
legend('RBFN test output','ideal test output','train data with noise');
title('The approximation performance of the resulting RBFN');
