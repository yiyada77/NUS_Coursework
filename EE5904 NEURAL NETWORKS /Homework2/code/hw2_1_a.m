%init
close all;clear;clc;

%plot f(x,y)
x=-1:0.01:3;
y=-1:0.01:3;
f=(1-x).^2+100.*(y-x.^2).^2;

plot3(x,y,f);