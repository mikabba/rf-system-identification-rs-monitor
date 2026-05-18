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

maximum.Fit = -inf;
maximum.numberData = 0;
maximum.models = "";
maximum.na = 0;
maximum.nb = 0;
maximum.nc = 0;
maximum.nd = 0;
maximum.nf = 0;
maximum.nk = 0;
maximum.sig = "";
maximum.freq = "";
% definiti due parametri importanti per l'identificazione dei modelli: 
% il valore minimo di "fit percentuale" (min_fit) e un array cases che 
% contiene diverse casistiche di identificazione dei modelli.
min_fit = 75;
cases = [2 2 1 1 2 1;
    4 4 1 1 4 1;];
% Questo array di stringhe definisce i modelli di sistema dinamico che 
% verranno utilizzati per l'identificazione. 
models = ["nlarx(data_cell{i},[na nb nk])"...
    "armax(data_cell{i},[na nb nc nk])"...
    "bj(data_cell{i},[nb nf nc nd nk])"...
    "nlarx(data_cell{i},[na nb nk])"];
l = 1;
% Il codice continua a cercare il miglior modello per ogni combinazione di 
% segnale di ingresso e frequenza. Dopo aver testato tutte le combinazioni,
% viene visualizzato il modello con il miglior valore di "FitPercent" tra 
% tutti i modelli testati.
for n = 2:numel(nomicartelle)
    % scorre tutti i segnali di ingresso presenti nella matrice di sign
    for f = 1:numel(freq)
        % scorre tutte le frequenze presenti nella matrice di stringhe freq
        load(sprintf("%s/%s/data_iddataC.mat",nomicartelle(n),freq(f)))
        data500 = data(1:500);
        data1000 = data(1:1000);
        data2000 = data(1:2000);
        data5500 = data(1:5500);
        data8500 = data(1:8500);
        valid = data(8501:10000);
        data_cell = {data500,data1000,data2000,data5500,data8500,valid};
        for k = 1:numel(models)
            % scorre tutti i modelli
            na = 0;
            nb = 0;
            nc = 0;
            nd = 0;
            nf = 0;
            nk = 0;
            for j = 1:2
                % scorre tutte le casistiche
                na = cases(j,1);
                nb = cases(j,2)*ones(1,2);
                nc = cases(j,3);
                nd = cases(j,4);
                nf = cases(j,5)*ones(1,2);
                nk = cases(j,6)*ones(1,2);
                for i = 1:numel(data_cell)
                    % scorre tutti i sottoinsiemi di dataset

                    m = eval(models(k)); %system identification con il
                                         % modello k-esimo
                    if m.Report.Fit.FitPercent > min_fit
                        % Valutazione del Fit del modello ottenuto
                        model.Fit = m.Report.Fit.FitPercent;
                        model.numberData = size(data_cell{i});
                        model.models = models(k);
                        model.identified = m;
                        model.na = na;
                        model.nb = nb;
                        model.nc = nc;
                        model.nd = nd;
                        model.nf = nf;
                        model.nk = nk;
                        model.sig = nomicartelle(n);
                        model.freq = freq(f);
                        best_model{l} = model;
                        l = l + 1;
                        if m.Report.Fit.FitPercent > maximum.Fit
                            % Verifica se il Fit del modello ottenuto è il
                            % migliore
                            maximum.Fit = m.Report.Fit.FitPercent;
                            maximum.numberData = size(data_cell{i});
                            maximum.models = models(k);
                            maximum.identified = m;
                            maximum.na = na;
                            maximum.nb = nb;
                            maximum.nc = nc;
                            maximum.nd = nd;
                            maximum.nf = nf;
                            maximum.nk = nk;
                            maximum.sig = nomicartelle(n);
                            maximum.freq = freq(f);

                        end
                    end

                end
            end
        end

    end
end

maximum
%%
save("bestFit.mat","maximum",'-mat');
save("bestFit_model.mat","best_model",'-mat');
load(sprintf("%s/%s/data_iddataC.mat",maximum.sig,maximum.freq))
valid = data(8501:10000);
data1000 = data(1:1000);

figure, compare(maximum.identified,data1000)

figure, compare(maximum.identified,valid)
