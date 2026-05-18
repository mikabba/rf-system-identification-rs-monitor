clc
close all
clear all
load_data

[yest,JT,ann,epochs] = train_ann(inputTrain',outTrain',5000,3,20,["ReLU","linear"],0.02);
JT(end)
epochs

figure,plot(JT)
figure,
plot(yest)
hold on
plot(outTrain)

yv = sim_ann(inputValid',outValid',ann);
figure,
plot(yv)
hold on
plot(outValid')
