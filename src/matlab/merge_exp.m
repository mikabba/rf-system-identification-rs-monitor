clc
clear
close all
cartelle = dir;
j = 1;
% creare una matrice di stringhe chiamata nomicartelle contenente i nomi di
% tutte le sottocartelle presenti nella cartella corrente di MATLAB.
for i = 1:numel(cartelle)
    if cartelle(i).isdir
        if cartelle(i).name ~= "." && cartelle(i).name ~= ".."
            nomicartelle(j) = string(cartelle(i).name);
            j = j + 1;
        end
    end
end
%% Inizializzare alcune variabili necessarie per l'identificazione dei 
% modelli. In particolare, viene definito un array di stringhe freq 
% contenente le frequenze dei segnali di ingresso, e una struttura maximum 
% contenente i valori massimi di diverse grandezze di interesse.
freq = ["25MHz" ...
    "35MHz" ...
    "45MHz" ...
    "55MHz" ...
    "65MHz" ...
    "75MHz" ...
    "85MHz" ...
    "95MHz"];
% Il codice continua a cercare il miglior modello per ogni combinazione di 
% segnale di ingresso e frequenza. Dopo aver testato tutte le combinazioni,
% viene visualizzato il modello con il miglior valore di "FitPercent" tra 
% tutti i modelli testati.
l = 1;
for n = 2:numel(nomicartelle)
    % scorre tutti i segnali di ingresso presenti nella matrice di sign
    for f = 2:numel(freq)
        % scorre tutte le frequenze presenti nella matrice di stringhe freq
        load(sprintf("%s/%s/data_iddataC.mat",nomicartelle(n),freq(f)))
        eval(sprintf("data%d=data;",l));
        l = l + 1;
    end
end
stringa = "";
for i = 1:l-1
    stringa = sprintf("%sdata%d,",stringa,i);
end

data = merge(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14,data15,data16,data17,data18,data19,data20,data21,data22,data23,data24,data25,data26,data27,data28,data29,data30,data31,data32,data33,data34,data35,data36,data37,data38,data39,data40,data41,data42,data43,data44,data45,data46,data47,data48,data49);
save("allExperiment.mat","data");
