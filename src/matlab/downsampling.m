clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat");
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
validTot = data(2500+1:end);
for i = 1:numel(data.OutputData)
    if(mod(i,3) == 0)
        y(i) = data.OutputData(i);
        u(i) = data.InputData(i);
    end
end
y = y';
u = u';
data = iddata(y,u,data.Ts*3);
figure,plot(data)
train = data(1:3500);
valid = data(3500+1:end);
%%
fpe = [];
for n = 1:100
    n
    m1 = nlarx(train,[n n 1]);
    fpe = [fpe;m1.Report.Fit.FPE];
    mse = [fpe;m2.Report.Fit.MSE];
end
plot(n,fpe)
% m1 = nlarx(train,[85 85 1])
figure,compare(valid,m1)
%%
m1 = nlarx(train,[85 85 1])
figure,compare(valid,m1)
%%
mbj = armax(train,[2 2 5 5])
figure,compare(valid,mbj)
%%
m2 = nlarx(train,mbj)
figure,compare(valid,m2)