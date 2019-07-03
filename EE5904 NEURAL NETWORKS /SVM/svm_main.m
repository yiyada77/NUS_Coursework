%Init
close all;clear;clc;

%Import dataset
load('train.mat');
load('eval.mat');

%Standardization
MTrain=mean(train_data,2);
StdTrain=std(train_data,0,2);
NorTrain=(train_data-MTrain)./StdTrain;
NorEval=(eval_data-MTrain)./StdTrain;
[Feature,Sample]=size(NorTrain);

%Quadratic Programming H
Gram=zeros(Sample,Sample);%Mercer¡¯s Condition check
sigma=25;%Gaussian kernel
for i=1:Sample
    for j=1:Sample
        Gram(i,j)=exp(sum((NorTrain(:,i)-NorTrain(:,j)).^2)/(-0.5*sigma^2));
    end
end
K=eig(Gram);
min_k=min(K);
if min_k<-1e-6
    disp('one of the eigenvalues is negative');
else%Mercer¡¯s Condition check over
    H=zeros(Sample,Sample);
    for i=1:Sample
        for j=1:Sample
            kernel=exp(sum((NorTrain(:,i)-NorTrain(:,j)).^2)/(-0.5*sigma^2));
            D=train_label(i)*train_label(j);
            H(i,j)=D.*kernel;
        end
    end
    f=-ones(Sample,1);
    A=[];
    b=[];
    C=13.5;
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
    g=train_label(idx);
    bN=zeros(Num_SVM,1);
    for i=1:Num_SVM
        a_d_k=zeros(Sample,1);
        for j=1:Sample
            a_d_k(j)=Alpha(j).*train_label(j).*exp(sum((NorTrain(:,j)-NorTrain(:,idx(i))).^2)/(-0.5*sigma^2));
        end
        bN(i)=g(i)-sum(a_d_k);
    end
    bo=mean(bN);
    %Discriminant function & Accuracy
    %eval
    g_eval=zeros(length(eval_label),1);
    for i=1:length(eval_label)
        ta_d_k=zeros(Sample,1);
        for j=1:Sample
            ta_d_k(j)=Alpha(j).*train_label(j).*exp(sum((NorTrain(:,j)-NorEval(:,i)).^2)/(-0.5*sigma^2));
        end
        g_eval(i)=sum(ta_d_k)+bo;
    end
    eval_predicted=sign(g_eval);
    diff_eval=eval_label-eval_predicted;
    acc_eval=find(diff_eval==0);
    accuracy_eval=length(acc_eval)/length(eval_label);
    disp(['accuracy_eval=',num2str(accuracy_eval)]);
    %train
    g_train=zeros(Sample,1);
    for i=1:Sample
        ta_d_k=zeros(Sample,1);
        for j=1:Sample
            ta_d_k(j)=Alpha(j).*train_label(j).*exp(sum((NorTrain(:,j)-NorTrain(:,i)).^2)/(-0.5*sigma^2));
        end
        g_train(i)=sum(ta_d_k)+bo;
    end
    d_new_Train=sign(g_train);
    diff_Train=train_label-d_new_Train;
    acc_Train=find(diff_Train==0);
    accuracy_Train=length(acc_Train)/length(train_label);
    disp(['accuracy_train=',num2str(accuracy_Train)]);
end

