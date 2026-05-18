
clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat")
% plot(data)
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
data.Ts*2

%%
% data = smoothdata(data, 'movmean', 5);
y = smoothdata(data.OutputData,'movmedian',5);
u = smoothdata(data.InputData,'movmedian',5);
data = iddata(y,u,data.Ts);
figure,plot(data)

figure
plot(data(1:500))
hold on
data = idresamp(data,2,1);
plot(data(1:500/2))
figure,plot(data)






