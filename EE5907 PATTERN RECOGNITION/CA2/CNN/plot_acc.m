%init
close all;clear;clc;

[net,info]=faceCNN();
acc=[1.-[info.train(:).top1err]; 1.-[info.val(:).top1err]];
acc_save=acc';
X=net.meta.trainOpts.numEpochs;
figure;
plot(1:X,acc(1,:),'LineWidth',1.5);hold on;
plot(1:X,acc(2,:),'LineWidth',1.5);hold on;
xlabel('Epoch'); ylabel('Accuracy');
title(['Accuracy for each Epochs, epoch = ',num2str(X), ...
    ', batchsize =  ', num2str(net.meta.trainOpts.batchSize)]);
legend('Traing Accuracy', 'Testing Accurary');
disp(['The first MAX accuracy for train: ',num2str(100.*max(acc(1,:))), ...
    ' % , at epoch = ', num2str(find(acc(1,:)==max(acc(1,:)),1))]);
disp(['The first MAX accuracy for test: ',num2str(100.*max(acc(2,:))), ...
    ' % , at epoch = ', num2str(find(acc(2,:)==max(acc(2,:)),1))]);