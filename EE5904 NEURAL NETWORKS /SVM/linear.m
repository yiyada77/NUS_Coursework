%Init
close all;clear;clc;

%Import dataset
load('train.mat');
load('test.mat');

%Standardization
MTrain=mean(train_data,2);
StdTrain=std(train_data,0,2);
NorTrain=(train_data-MTrain)./StdTrain;
NorTest=(test_data-MTrain)./StdTrain;
[Feature,Sample]=size(NorTrain);

%Mercer¡¯s Condition check
MCC=NorTrain'*NorTrain;
K=eig(MCC);
min_k=min(K);
if min_k<-1e-4
    disp('one of the eigenvalues is negative');
else
    %Quadratic Programming H
    H=zeros(Sample,Sample);
    for i=1:Sample
        for j=1:Sample
            kernel=NorTrain(:,i)'*NorTrain(:,j);
            D=train_label(i)*train_label(j);
            H(i,j)=D.*kernel;
        end 
    end
    f=-ones(Sample,1);
    C=1e1;
    A=[];
    b=[];
    Aeq=train_label';
    Beq=0;
    lb=zeros(Sample,1);
    ub=ones(Sample,1)*C;
    x0=[];
    options=optimset('LargeScale','off','MaxIter',1000);
    threshold=1e-4;
    Alpha=quadprog(H,f,A,b,Aeq,Beq,lb,ub,x0,options);
    idx=find(Alpha>threshold);

    Num_SVM=length(idx);
    w=zeros(Feature,Num_SVM);
    for i=1:Num_SVM
        w(:,i)=Alpha(idx(i)).*train_label(idx(i)).*NorTrain(:,idx(i));
    end
    wo=sum(w,2);
    b=zeros(Num_SVM,1);
    for i=1:Num_SVM
        b(i)=1/(train_label(idx(i)))-wo'*NorTrain(:,idx(i));
    end
    bo=mean(b);

    %Discriminant function & Accuracy
    g_Test=wo'*NorTest+bo;
    d_new_Test=sign(g_Test);
    diff_Test=test_label'-d_new_Test;
    acc_Test=find(diff_Test==0);
    accuracy_Test=length(acc_Test)/length(test_label);
    disp(['c=',num2str(C),',accuracy_test=',num2str(accuracy_Test)]);

    g_Train=wo'*NorTrain+bo;
    d_new_Train=sign(g_Train);
    diff_Train=train_label'-d_new_Train;
    acc_Train=find(diff_Train==0);
    accuracy_Train=length(acc_Train)/length(train_label);
    disp(['c=',num2str(C),',accuracy_train=',num2str(accuracy_Train)]);
end