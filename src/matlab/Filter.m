clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat");
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
data = detrend(data)
train = data(1:3500);
valid = data(3500+1:end);
m1 = bj(train,[3 2 2 2 1])
figure,compare(valid,m1)

C = m1.C;
D = m1.D;
uf = filter(C,D,data.InputData);
yf = filter(C,D,data.OutputData);
data = iddata(yf,uf,data.Ts);
train = data(1:3500);
m1 = bj(train,[3 2 2 2 1])
figure,compare(valid,m1)

C = m1.C;
D = m1.D;
uf = filter(C,D,data.InputData);
yf = filter(C,D,data.OutputData);
data = iddata(yf,uf,data.Ts);
train = data(1:3500);
m1 = bj(train,[3 2 2 2 1])
figure,compare(valid,m1)

m2 = nlhw(train,[2 1 1])
figure,compare(valid,m2)