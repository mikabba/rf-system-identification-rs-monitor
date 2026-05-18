clc
clear
close all

u_train = 0:0.01:10;
y_train = sin(u_train);

[yest,JT,ann,epochs] = train_ann(u_train,y_train,20,2,10,["ReLU","linear"],0.01);
epochs
JT(end)
figure,
plot(yest)
hold on
plot(y_train)
