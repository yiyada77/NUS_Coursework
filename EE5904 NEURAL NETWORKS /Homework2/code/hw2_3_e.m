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

%Specify the structure and learning algorithm
n=10;
[net,accu_train,accu_val]=train_seq( n, train_set_N, train_label, 900, 0, 100 );

%validate
output_valid=sim(net,valid_set_N);

%accuracy
output_train=sim(net,train_set_N);
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


