% Identificazione sistema radio in trasmissione
% Scelta del dataset e pre-processing
% Per l'identificazione del sistema si intende valutare il dataset di misura del segnale sweep in ingresso. Questo segnale può fornire una migliore copertura dello spettro delle frequenze rispetto ad altri segnali.
clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat")
figure,plot(data)
% Il dataset è costituto da due ingressi: il segnale portante e il segnale in bassa frequenza. Al fine di semplificare il processo di identificazione e concentrarsi sul comportamento del sistema di modulazione e demodulazione, le misure relative alla portante non sono considerate nell'identificazione. Inoltre, nei primi 2 secondi, sia il segnale a bassa frequenza che il segnale in uscita mostrano delle discontinuità rispetto al resto dell'andamento del segnale. Quindi, si considerano i campioni di segnale misurati a partire da 2 secondi.
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
data = detrend(data);
% 
% for i = 1:numel(data.OutputData)
%     y(i) = data.OutputData(i);
%     u(i) = data.InputData(i);
% end
% y = y';
% u = u';
% ts = data.Ts;
% data = iddata(y,u,data.Ts);
figure,plot(data)
figure(3)
plot(data(1:1000))
hold on
%%
data = idresamp(data,3,1)
plot(data(1:1000/3))
%%
for i = 1:numel(data.OutputData)
    if(mod(i,2) == 0)
        y1(i) = data.OutputData(i);
        u1(i) = data.InputData(i);
    elseif(i>1)
        y1(i) = y1(i-1);
        u1(i) = u1(i-1);
    end
end
y1 = y1';
u1 = u1';
clear data

data = iddata(y1,u1,ts*2);
data = detrend(data)
plot(data(1:500))









