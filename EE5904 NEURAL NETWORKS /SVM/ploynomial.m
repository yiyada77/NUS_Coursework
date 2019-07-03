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

threshold_g=-1e-4;
C=1.1;
%Quadratic Programming H
pp=[1,2,3,4,5];
for P=1:length(pp)
    p=pp(P);
    %Mercer¡¯s Condition check
    MCC=(NorTrain'*NorTrain+1).^p;
    K=eig(MCC);
    min_k=min(K);
    if min_k<threshold_g
        disp('one of the eigenvalues is negative');
    else    
        H=zeros(Sample,Sample);
        for i=1:Sample
            for j=1:Sample
                kernel=(NorTrain(:,i)'*NorTrain(:,j)+1)^p;
                D=train_label(i)*train_label(j);
                H(i,j)=D.*kernel;
            end 
        end
        f=-ones(Sample,1);
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

        g=train_label(idx);
        bN=zeros(Num_SVM,1);
        for i=1:Num_SVM
            a_d_k=zeros(Sample,1);
            for j=1:Sample
                a_d_k(j)=Alpha(j).*train_label(j).*(NorTrain(:,j)'*NorTrain(:,idx(i))+1).^p;
            end
            bN(i)=g(i)-sum(a_d_k);
        end
        bo=mean(bN);
        %Discriminant function & Accuracy
        %test
        g_test=zeros(length(test_label),1);
        for i=1:length(test_label)
            ta_d_k=zeros(Sample,1);
            for j=1:Sample
                ta_d_k(j)=Alpha(j).*train_label(j).*(NorTrain(:,j)'*NorTest(:,i)+1).^p;
            end
            g_test(i)=sum(ta_d_k)+bo;
        end
        d_new_Test=sign(g_test);
        diff_Test=test_label-d_new_Test;
        acc_Test=find(diff_Test==0);
        accuracy_Test=length(acc_Test)/length(test_label);
        disp(['p=',num2str(p),',c=',num2str(C),',accuracy_test=',num2str(accuracy_Test)]);
        %train
        g_train=zeros(Sample,1);
        for i=1:Sample
            ta_d_k=zeros(Sample,1);
            for j=1:Sample
                ta_d_k(j)=Alpha(j).*train_label(j).*(NorTrain(:,j)'*NorTrain(:,i)+1).^p;
            end
            g_train(i)=sum(ta_d_k)+bo;
        end
        d_new_Train=sign(g_train);
        diff_Train=train_label-d_new_Train;
        acc_Train=find(diff_Train==0);
        accuracy_Train=length(acc_Train)/length(train_label);   
        disp(['p=',num2str(p),',c=',num2str(C),',accuracy_train=',num2str(accuracy_Train)]);
    end
end
