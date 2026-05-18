clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat")
figure,plot(data)
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);

figure,plot(data)

figure,plot(data(1:500))
hold on
data = idresamp(data,2,1);
data = data(1:1/data.Ts);
plot(data(1:500/2))
hold off

figure,plot(data)
N = numel(data.OutputData);
train = data(1:round(0.6*N));

load("Sin800Hz\85MHz\data_iddataC.mat")
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(1:0.8/data.Ts)
figure,plot(data)
data = idresamp(data,2,1);
N2 = numel(data.OutputData);
valid = data;
figure,plot(train)
figure,plot(valid)
%%
mse_a = [];
for n = 1:55
    m1 = bj(train,[n n n n 1])
    [m_v,fit,x0] = compare(valid,m1)
    m = norm(valid.OutputData-mean(valid.OutputData))
    mse = (1/numel(m_v.OutputData))*sum((valid.OutputData-m_v.OutputData).^2)
    % mse = (1/numel(valid.OutputData))*((m - fit/100)^2)
    mse_a = [mse_a;mse]
end
mse_a
figure,stem(mse_a)
%%
fpe_a = [];
for n = 1:55
    m1 = bj(train,[n n n n 1])
    [m_v,fit,x0] = compare(valid,m1)
    m = norm(valid.OutputData-mean(valid.OutputData))
    N = numel(m_v.OutputData);
    mse = (1/N)*sum((valid.OutputData-m_v.OutputData).^2)
    % mse = (1/numel(valid.OutputData))*((m - fit/100)^2)
    fpe = ((N+n)/(N-n))*mse;
    fpe_a = [fpe_a;fpe]
    n
end
figure,stem(fpe_a)
%%
fpet_a = [];
fpev_a = [];
mset_a = [];
msev_a = [];
aic_a = [];
for n = 1:60
    m1 = bj(train,[n n n n 1]);
    fpet_a = [fpet_a;m1.Report.Fit.FPE]
    mset_a = [mset_a;m1.Report.Fit.MSE]
    aic_a = [aic_a;m1.Report.Fit.AIC];
    [m_v,fit,x0] = compare(valid,m1);
    m = norm(valid.OutputData-mean(valid.OutputData));
    N = numel(m_v.OutputData);
    mse = (1/N)*sum((valid.OutputData-m_v.OutputData).^2);
    % mse = (1/numel(valid.OutputData))*((m - fit/100)^2)
    fpe = ((N+n)/(N-n))*mse;
    fpev_a = [fpev_a;fpe];
    msev_a = [msev_a;mse];
    n
end
figure,stem(fpet_a)
figure,stem(fpev_a)
figure,stem(mset_a)
figure,stem(msev_a)
%%
fpet_a = [];
fpev_a = [];
mset_a = [];
msev_a = [];
aic_a = [];
for n = 1:20
    m1 = nlhw(train,[n n 1]);
    fpet_a = [fpet_a;m1.Report.Fit.FPE]
    mset_a = [mset_a;m1.Report.Fit.MSE]
    aic_a = [aic_a;m1.Report.Fit.AIC];
    [m_v,fit,x0] = compare(valid,m1);
    m = norm(valid.OutputData-mean(valid.OutputData));
    N = numel(m_v.OutputData);
    mse = (1/N)*sum((valid.OutputData-m_v.OutputData).^2);
    % mse = (1/numel(valid.OutputData))*((m - fit/100)^2)
    fpe = ((N+n)/(N-n))*mse;
    fpev_a = [fpev_a;fpe];
    msev_a = [msev_a;mse];
    n
end
figure,stem(fpet_a)
figure,stem(fpev_a)
figure,stem(mset_a)
figure,stem(msev_a)
%%
close all
figure
title("FPE")
hold on
plot(fpet_a)
plot(fpev_a)
figure
title("MSE")
hold on
plot(mset_a)
plot(msev_a)
figure
title("AIC")
plot(aic_a)
%%
m_best = bj(train,[55 55 55 55 1])
figure,compare(valid,m_best)

%%
hold on
plot(fpe_a)
%%
% m1 = bj(train,[5 5 5 5 1])
% [m_v,fit,x0] = compare(valid,m1)
% mse = (1/numel(m_v.OutputData))*sum((valid.OutputData-m_v.OutputData).^2)
