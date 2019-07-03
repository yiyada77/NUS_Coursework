%init
close all;clear;clc;

x=linspace(-pi,pi,400);
trainX=[x;sinc(x)];%2x400 matrix 

%parameter
w=rand(40,2); %randomly init weigth 40 neurons in output layer
sigma0=sqrt(1^2+40^2)/2;%M=1,N=40
eta0=0.1;
T=100000;%iterations
tau1=T/log(sigma0);
tau2=T;
eta=eta0;
sigma=sigma0;

%algorithm
for n=1:T
    i=randperm(size(trainX,2),1);%randomly select vector x
    %competitive process
    [min_dist,Idx]=min(dist(trainX(:,i)',w'));% 1*2 * 2*40 =1*40
    %adaptation process
    for j=1:40
       h=exp((j-Idx).^2/-(2*sigma.^2));
       w(j,:)=w(j,:)+eta*h*(trainX(:,i)'-w(j,:));
    end 
    %update eta&sigma
    eta=eta0*exp(-n/tau2);
    sigma=sigma0*exp(-n/tau1);
end
figure(1)
plot(trainX(1,:),trainX(2,:),'--','LineWidth',1.5);hold on;
plot(w(:,1),w(:,2),'LineWidth',1); hold on;
scatter(w(:,1),w(:,2),'o');hold on;
axis([-pi,pi,-0.4,1.1]);
title(['The topological adjacent neurons , T=',num2str(T)]);
legend('ideal output','SOM output','neurons');