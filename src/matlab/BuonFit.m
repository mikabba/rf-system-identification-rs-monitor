clc
clear
close all
load("Rumore Bianco\35MHz\data_iddataC.mat");

train = data(1:200);
% figure,plot(train)
valid = data(200+1:501);
na = 2;
nb = [1 21];
nf = [20 4];
nc = 4;
nd = 4;
nk = 1*ones(1,2);
orders=[na nb nc nd nf nk];
pem1 = nlhw(data,[nb nf nk])
figure,compare(valid,pem1)
figure,compare(data,pem1)
%%

