%Initialization
clc;clf;clear;

%load data set
load('train_set.mat'); 
load('valid_set.mat');

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
net=perceptron('hardlim','learnpn');
net.trainParam.epochs=100;  
net.trainParam.show=50;      
net.divideFcn = 'dividetrain';
net.performParam.regularization = 0.1; 

%train
net=train(net,train_set,train_label);

%validate
output_valid=sim(net,valid_set);

%accuracy
output_train=sim(net,train_set);
valid=0;
train=0;
for i=1:100
    value=abs(output_valid(i)-valid_label(i));
    if(value<0.5)
        valid=valid+1;    
    end
end
for i=1:900
    value=abs(output_train(i)-train_label(i));
    if(value<0.5)
        train=train+1;    
    end
end

accuracy_train=sprintf('accuracy_train= %0.1f%%',train/9);
disp(accuracy_train);
accuracy_valid=sprintf('accuracy_valid= %0.1f%%',valid);
disp(accuracy_valid);


