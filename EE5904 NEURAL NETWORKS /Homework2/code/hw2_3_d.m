%Initialization
clc;clf;clear;

%load data set
load('train_set.mat'); 
load('valid_set.mat');

%Normalize
train_mean=mean(train_set,'all');
train_m=train_set-train_mean*ones(1024,900);
train_std=std(train_m,0,'all');
train_set_N=train_m/train_std;

valid_mean=mean(valid_set,'all');
valid_m=valid_set-valid_mean*ones(1024,100);
valid_std=std(valid_m,0,'all');
valid_set_N=valid_m/valid_std;

%init train label & valid label
train_label=zeros(1,900);
valid_label=zeros(1,100);

for i=1:450
    train_label(1,i+450)=1;
end
for i=1:50
    valid_label(1,i+50)=1;
end

%set network
n=10;                   
net=patternnet(n,'trainscg','crossentropy');
net=configure(net,train_set_N,train_label);
net.trainParam.epochs=1;  
net.trainParam.lr=0.01;   
net.trainParam.show=50;    
net.divideFcn = 'dividetrain';
net.performParam.regularization = 0.6;

r_accu_t=zeros(1,200);
r_accu_v=zeros(1,200);
for j=1:200
    %train
    net=train(net,train_set_N,train_label);
    %validate
    output_valid=sim(net,valid_set_N);
    %accuracy
    output_train=sim(net,train_set_N);
    m_valid=0;
    m_train=0;
    for i=1:100
        value=abs(output_valid(i)-valid_label(i));
        if(value<0.5)
            m_valid=m_valid+1;

        end
    end
    for i=1:900
        value=abs(output_train(i)-train_label(i));
        if(value<0.5)
            m_train=m_train+1;    
        end
    end
    r_accu_t(j)=m_train/900;
    r_accu_v(j)=m_valid/100;
end

x=1:200;
figure(2);
plot(x,r_accu_t(1:200),'--','color','r'),hold on;
plot(x,r_accu_v(1:200),'color','b'),hold on;
legend('train','valid');
title('Regulation:0.6');
xlabel('Epoch');
ylabel('Accuracy');

