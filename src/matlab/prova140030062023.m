clc
clear
close all
%%
load("Segnale Sweep\25MHz\data_iddataC.mat");
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);

validTot = data(2500+1:end);
% for i = 1:numel(data.OutputData)
%     if(mod(i,3) == 0)
%         y(i) = data.OutputData(i);
%         u(i) = data.InputData(i);
%     end
% end
% y = y';
% u = u';
% data = iddata(y,u,data.Ts*3);
data = idresamp(data,2,1);
totalData = numel(data.OutputData);
figure,plot(data)
train = data(1:round(0.55*totalData));
valid = data(round(0.55*totalData)+1:end);
figure,plot(train)
figure,plot(valid)
%%
m1 = bj(train,[50 50 50 50 1])
figure,compare(valid,m1)
%%
m2 = armax(train,[8 8 8 1])
figure,bode(m1,m2)
u = filter(m2.C,m2.A,data.InputData);
y = filter(m2.C,m2.A,data.OutputData);
data = iddata(y,u,data.Ts);
train = data(1:3500);

m3 = armax(train,[8 8 8 1])
figure,bode(m1,m3)
figure,compare(valid,m3)

u = filter(m3.C,m3.A,data.InputData);
y = filter(m3.C,m3.A,data.OutputData);
data = iddata(y,u,data.Ts);
train = data(1:3500);

m4 = armax(train,[8 8 8 1])
figure,bode(m1,m4)
figure,compare(valid,m4)

disp('m4 is the best');

m5 = arx(train,[15 15 1])
figure,compare(valid,m5)

%%

