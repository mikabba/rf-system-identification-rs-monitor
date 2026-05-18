clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat");
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
numel(data.OutputData)
figure,plot(data)
figure,hold on
plot(data.OutputData);
plot(data.InputData/2);
%%
data = detrend(data,0)
train = data(1:3000);
valid = data(3000+1:end);
figure, plot(train);
figure, plot(valid);
%%
nb = 2;
nf = 2;
nk = 1;
orders = [nb nf nk];
m1 = oe(train,orders)
figure,bode(H,m1)
figure,compare(valid,m1)
nb = 2;
nf = 3;
nk = 1;
orders = [nb nf nk];
m2 = oe(train,orders)
figure,compare(valid,m2)
nb = 3;
nf = 3;
nk = 1;
orders = [nb nf nk];
m3 = oe(train,orders)
figure,compare(valid,m3)
nb = 3;
nf = 4;
nk = 1;
orders = [nb nf nk];
m4 = oe(train,orders)
figure,compare(valid,m4)
nb = 4;
nf = 4;
nk = 1;
orders = [nb nf nk];
m5 = oe(train,orders)
figure,compare(valid,m5)
nb = 4;
nf = 5;
nk = 1;
orders = [nb nf nk];
m6 = oe(train,orders)
figure,compare(valid,m6)
nb = 5;
nf = 5;
nk = 1;
orders = [nb nf nk];
m7 = oe(train,orders)
figure,compare(valid,m7)
nb = 5;
nf = 2;
nk = 1;
orders = [nb nf nk];
m8 = oe(train,orders)
figure,compare(valid,m8)
%%
na = 3;
nb = 3;
nf = 3;
nc = 1;
nd = 4;
nk = 1;
orders = [na nb nk];
m1bj = arx(train,orders)
figure,compare(valid,m1bj)
A = m1bj.A;
uf = filter(1,A,train.InputData);
yf = filter(1,A,train.OutputData);
dataf = iddata(yf,uf,data.Ts);
m2bj = arx(train,orders)
figure,compare(valid,m2bj)





