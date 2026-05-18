clc
clear
close all
load("../Segnale nullo/25MHz/data_iddataC.mat");
% input = data.OutputData(1:1000);
input = 0:0.01:10;
input = sin(input);



[y_est,J] = neuralnetwork(input,30,0.2,4,20)


figure,
plot(y_est)
hold on
plot(input)
figure;
subplot(2,1,1);
plot(y_est);
grid on;
ylabel('y_{est}');
legend('y_{est}');

subplot(2,1,2);
plot(input);
grid on;
ylabel('Input');
xlabel('Time');

legend('Input');
