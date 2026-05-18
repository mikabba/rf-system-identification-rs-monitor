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
clc
close all
[out,weight,Jt,Jv,epoch] = train_ann(inputTrain,outTrain,[8 8],0.15,0.1,3000,inputValid,outValid);
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
        weights{i} = rand(hiddenSizes(i-1), hiddenSizes(i));
    end
    weights{numHiddenLayers + 1} = rand(hiddenSizes(end), 1);
end

function [output, hiddenOutputs] = feedforward(input, weights)
    % Calcola l'output della rete neurale utilizzando l'algoritmo di feedforward
    numHiddenLayers = numel(weights) - 1;
    hiddenOutputs = cell(1, numHiddenLayers);
    
    % hiddenOutputs{1} = tanh(sum(input*whi,1))*who
    hiddenOutputs{1} = tanh(sum(input*weights{1}, 1));
    for i = 2:numHiddenLayers
        hiddenOutputs{i} = tanh(sum(hiddenOutputs{i-1}*weights{i}, 1));
    end
    
    output = hiddenOutputs{end}*weights{end};
end

function [weights, J] = levenbergMarquardt(input, target, weights, lambda)
    % Implementazione dell'algoritmo di Levenberg-Marquardt per l'aggiornamento dei pesi
    numHiddenLayers = numel(weights) - 1;
    numSamples = size(input, 1);
    
    % Calcolo degli output e degli hiddenOutputs
    [output, hiddenOutputs] = feedforward(input, weights);
    
    % Calcolo dell'errore
    error = target - output;
    
    % Inizializzazione della matrice Jacobiana
    J = cell(numHiddenLayers + 1, 1);
    J{numHiddenLayers + 1} = hiddenOutputs{end}';
    
    % Calcolo della Jacobiana per gli strati intermedi
    for i = numHiddenLayers:-1:1
        J{i} = hiddenOutputs{i-1}';
    end
    
    % Calcolo della Hessiana approssimata
    H = J{end}' * J{end};
    for i = 1:numHiddenLayers
        H = H + J{i}' * J{i};
    end
    
    % Aggiunta del termine di regolarizzazione alla Hessiana
    H = H + lambda * eye(size(H));
    
    % Calcolo dell'aggiornamento dei pesi
    deltaWeights = H \ (J{end}' * error);
    for i = 1:numHiddenLayers
        deltaWeights = [J{i}' * error; deltaWeights];
    end
    
    % Aggiornamento dei pesi
    weights{1} = weights{1} + deltaWeights{1};
    for i = 2:numHiddenLayers + 1
        weights{i} = weights{i} + deltaWeights{i};
    end
end

function [out, weights, J_train, J_val, epoch] = train_ann(input, target, hiddenSizes, learningRateOL, learningRateHL, epochs, validationInput, validationTarget)
    % Addestra la rete neurale per un numero specificato di epoche utilizzando l'algoritmo di Levenberg-Marquardt
    inputSize = size(input, 2);
    weights = initializeWeights(inputSize, hiddenSizes);
    
    numHiddenLayers = numel(hiddenSizes);
    J_train = zeros(epochs, 1);
    J_val = zeros(epochs, 1);
    prev_J_val = Inf;
    lambda = 0.01; % Fattore di regolarizzazione
    
    for epoch = 1:epochs
        out = zeros(size(input, 1), 1);
        for i = 1:size(input, 1)
            currentInput = input(i, :);
            currentTarget = target(i);
            [output, hiddenOutputs] = feedforward(currentInput, weights);
            [weights, ~] = levenbergMarquardt(currentInput, currentTarget, weights, lambda);
            out(i) = output;
        end
        
        J_train(epoch) = (1/numel(input)) * sum((target - out).^2);
        
        [val_out, ~] = feedforward(validationInput, weights);
        J_val(epoch) = (1/numel(validationInput)) * sum((validationTarget - val_out).^2);
        
        % if epoch > 1 && abs(J_val(epoch) - prev_J_val) < 1e-5
        %     break;
        % end
        
        prev_J_val = J_val(epoch);
    end
end
