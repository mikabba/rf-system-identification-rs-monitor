clc
clear
close all
load("Segnale Sweep\25MHz\data_iddataC.mat")
data = iddata(data.OutputData,data.InputData(:,1),data.Ts);
data = data(5100:end);
data = idresamp(data,2,1);

N = numel(data.OutputData)

trainND = data(1:round(0.6*N));
validND = data(round(0.6*N)+1:end);

data = detrend(data)
trainD = data(1:round(0.6*N));
validD = data(round(0.6*N)+1:end);

impulse(data,'sd',1,'fill')
inputTrain = trainD.InputData;
outTrain = trainD.OutputData;
inputValid = trainD.InputData;
outValid = trainD.OutputData;
%%
% Definizione dei parametri da testare
hiddenSizes = [30, 30];
learningRate = 0.04;
epochs = 1000;

bestParams = struct();
bestJv = Inf;

% Iterazione sui parametri
for i = 1:10
    % Addestramento della rete neurale con i parametri correnti
    i
    [out, weight, Jt, Jv, epoch] = train_ann(inputTrain, outTrain, hiddenSizes, learningRate, epochs, inputValid, outValid);
    
    % Calcolo dell'indice J di validazione finale
    finalJv = Jv(end);
    
    % Verifica se i parametri correnti hanno prodotto un indice J di validazione migliore
    if finalJv < bestJv
        bestParams.hiddenSizes = hiddenSizes;
        bestParams.learningRate = learningRate;
        bestParams.epochs = epochs;
        bestJv = finalJv;
    end
    
    % Generazione di nuovi parametri per la prossima iterazione (esempio casuale)
    hiddenSizes = randi([10, 50], 1, 2);
    learningRate = 0.01 + 0.1*rand();
    epochs = 500 + randi(500);
end

% Addestramento finale con i parametri migliori
[out, weight, Jt, Jv, epoch] = train_ann(inputTrain, outTrain, bestParams.hiddenSizes, bestParams.learningRate, bestParams.epochs, inputValid, outValid);

% Visualizzazione dei risultati
disp("Parametri migliori:");
disp(bestParams);
disp("Indice J di validazione migliore:");
disp(bestJv);
%%
clc
close all
[out,weight,Jt,Jv,epoch] = train_ann(inputTrain,outTrain,[5 5],0.09,0.02,2000,inputValid,outValid);
% [out,weight,Jt,Jv,epoch] = train_ann(inputTrain,outTrain,[40 40] ,0.04,1000,inputValid,outValid);
% [w,error,out] = trainNeuralNetwork(inputTrain, outTrain, [20], 0.1, 100)

epoch
Jt(end)
Jv(end)

figure,
plot(outTrain)
hold on 
plot(out)
% figure,stem(J)
% xlabel("Epoche")
% ylabel("J")
grid on
%%
function weights = initializeWeights(inputSize, hiddenSizes)
    % Inizializza casualmente i pesi tra -1 e 1 per tutti gli strati nascosti
    numHiddenLayers = numel(hiddenSizes);
    weights = cell(1, numHiddenLayers + 1);
    weights{1} = rand(inputSize, hiddenSizes(1));
    for i = 2:numHiddenLayers
        weights{i} = rand(hiddenSizes(i-1), hiddenSizes(i)) ;
    end
    weights{numHiddenLayers + 1} = rand(hiddenSizes(end), 1);
end

function [output, hiddenOutputs] = feedforward(input, weights)
    % Calcola l'output della rete neurale utilizzando l'algoritmo di feedforward
    numHiddenLayers = numel(weights) - 1;
    hiddenOutputs = cell(1, numHiddenLayers);
    
    % hiddenOutputs{1} = tanh(sum(input*whi,1))*who
    hiddenOutputs{1} = tanh(sum(input*weights{1},1));
    for i = 2:numHiddenLayers
        hiddenOutputs{i} = tanh(sum(hiddenOutputs{i-1}*weights{i},1));
    end
    
    output = hiddenOutputs{end}*weights{end};
end

function weights = updateWeights(input, hiddenOutputs, output, target, weights, learningRateOL,learningRateHL)
    % pred_error = target - output;
    % weights{end} = weights{end} + learningRate*hiddenOutputs{end}'*pred_error;
    numHiddenLayers = numel(weights) - 1;
    
    % Calcolo dell'errore dell'output (output delta)
    outputDelta = (target - output);
    
    % Aggiornamento dei pesi dell'ultimo strato nascosto verso l'output
    weights{end} = weights{end} + learningRateOL * (hiddenOutputs{end}' * outputDelta);
    
    % Backpropagation per gli strati nascosti intermedi
    for i = numHiddenLayers:-1:1
        % Calcolo del delta per lo strato nascosto corrente
        delta = (outputDelta * weights{i+1}') .* (1 - tanh(hiddenOutputs{i}).^2);
        
        % Aggiornamento dei pesi dall'input allo strato nascosto corrente
        if i == 1
            weights{i} = weights{i} + learningRateHL * (input' * delta);
        else
            weights{i} = weights{i} - learningRateHL * (hiddenOutputs{i-1}' * delta);
        end
        
        % Preparazione per il prossimo strato nascosto
        outputDelta = delta;
    end
end

function [out, weights, J_train,J_val,epoch] = train_ann(input, target, hiddenSizes, learningRateOL,learningRateHL, epochs,validationInput,validationTarget)
    % Addestra la rete neurale per un numero specificato di epoche
    inputSize = size(input, 2);
    weights = initializeWeights(inputSize, hiddenSizes);
    
    numHiddenLayers = numel(hiddenSizes);
    J = zeros(epochs, 1);
    prev_J_val = Inf;
    
    for epoch = 1:epochs
        out = zeros(size(input, 1), 1);
        for i = 1:size(input, 1)
            currentInput = input(i, :);
            currentTarget = target(i);
            
            [output, hiddenOutputs] = feedforward(currentInput, weights);
            weights = updateWeights(currentInput, hiddenOutputs, output, currentTarget, weights, learningRateOL,learningRateHL);
            out(i) = output;
        end
        weights{1}
        weights{2}
        weights{3}
        J_train(epoch) = (1/numel(input)) * sum((target - out).^2);
        [val_out, ~] = feedforward(validationInput, weights);
        J_val(epoch) = (1/numel(validationInput)) * sum((validationTarget - val_out).^2);
        % if epoch > 1 && abs(J_val(epoch) - prev_J_val) < 1e-5
        %     break;
        % end
        prev_J_val = J_val(epoch);
    end
end

