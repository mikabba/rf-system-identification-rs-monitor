clc
clear
close all
%%
load("Segnale Sweep\25MHz\data_iddataC.mat");
datass = iddata(data.OutputData,data.InputData(:,1),data.Ts);
datass = datass(5100:end);
datass = idresamp(datass,2,1);
totalDatass = numel(datass.OutputData);
figure,plot(datass)
trainss = datass(1:round(0.55*totalDatass));
validss = datass(round(0.55*totalDatass)+1:end);
figure,plot(trainss)
figure,plot(validss)
%%
m1 = bj(trainss,[60 60 60 60 1])
figure,compare(validss,m1)
%%
load("Rumore Bianco\25MHz\data_iddataC.mat")
datawn = iddata(data.OutputData,data.InputData(:,1),data.Ts);
datawn = datawn(5100:end);
datawn = idresamp(datawn,2,1);
datawn = detrend(datawn);
totalDatawn = numel(datawn.OutputData);
trainwn = datawn(1:round(0.55*totalDatawn));
validwn = datawn(round(0.55*totalDatawn)+1:end);
y = smoothdata(datawn.OutputData,'movmedian',5);
u = smoothdata(datawn.InputData,'movmedian',5);
datawn = iddata(y,u,datawn.Ts);
trainwn = datawn(1:round(0.55*totalDatawn));
validwn = datawn(round(0.55*totalDatawn)+1:end);
%%
m2 = bj(trainwn,[8 8 8 8 1])
m2a = armax(trainwn,[8 8 8 1])
figure,bode(m1,m2,m2a)
legend m1 m2 m2a
%%
datawnf1 = filterData(datawn,m2.D,m2.C);

trainwnf1 = datawnf1(1:round(0.55*totalDatawn));
validwnf1 = datawnf1(round(0.55*totalDatawn)+1:end);
%%
m3 = bj(trainwnf1,[8 8 8 8 1])
% m3a = armax(trainwnf1,[8 8 8 1])
figure,bode(m1,m2,m3,m3a)
legend m1 m2 m3 m3a
%%
datawnf2 = filterData(datawnf1,m4.D,m4.C);
trainwnf2 = datawnf2(1:round(0.55*totalDatawn));
validwnf2 = datawnf2(round(0.55*totalDatawn)+1:end);
%%
m4 = bj(trainwnf2,[8 8 8 8 1])
m4a = armax(trainwnf2,[8 8 8 1])
figure,bode(m1,m4a,m4)
legend m1 m4a m4

%%
datawnf3 = filterData(datawnf2,m4.D,m4.C);
trainwnf3 = datawnf3(1:round(0.55*totalDatawn));
validwnf3 = datawnf3(round(0.55*totalDatawn)+1:end);
m5 = bj(trainwnf3,[8 8 8 8 1])
figure,bodeplot(m1,m5)

legend m1 m5
figure,compare(validss,m4a)
