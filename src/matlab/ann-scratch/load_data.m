clc
clear
close all
load("..\Segnale Sweep\25MHz\data_iddataC.mat")
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
data = idresamp(data,2,1);

N = numel(data.OutputData);

trainND = data(1:round(0.6*N));
validND = data(round(0.6*N)+1:end);

data = detrend(data);
trainD = data(1:round(0.5*N));
validD = data(round(0.5*N):end);

impulse(data,'sd',1,'fill')
inputTrain = trainD.InputData;
outTrain = trainD.OutputData;
inputValid = validD.InputData;
outValid = validD.OutputData;
close all