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
trainD = data(1:round(0.5*N));
validD = data(round(0.5*N):end);

impulse(data,'sd',1,'fill')
inputTrain = trainD.InputData;
outTrain = trainD.OutputData;
inputValid = trainD.InputData;
outValid = trainD.OutputData;
%%
clc 
close all
[out,weight,error] = train_ann(inputTrain,outTrain,10,2,0.05,300);
error(end)
figure,
plot(out)
hold on
plot(outTrain)
% figure,stem(J)
% xlabel("Epoche")
% ylabel("J")
grid on
%%
function [weights] = initializeWeights(inputSize, hiddenSize,numHidden, outputSize)
    % Inizializza casualmente i pesi tra -1 e 1
    weights.input_hidden(1,:) = 2 * rand(inputSize, hiddenSize) - 1;
    for i = 1:numHidden-2
        weights.hidden_output(i,:) = 2 * rand(hiddenSize, hiddenSize) - 1;
    end
    weights.hidden_output(i,:) = 2 * rand(hiddenSize, outputSize) - 1;
end

function [output, hidden_output] = feedforward(input, weights,numHiddenLayers)
    % Calcola l'output della rete neurale utilizzando l'algoritmo di feedforward
    for i = 1:numHiddenLayers
        hidden_layer_input = input .* weights.input_hidden(i,:);
        hidden_output(i,:) = tanh(-2.*hidden_layer_input);
        output_layer_input = hidden_output * weights.hidden_output(i,:);
        output = output_layer_input;
        clear input
        input = output;
    end
end


function [weights] = updateWeights(input, hidden_output,numHiddenLayers, output, target, weights, learningRate)
    % Calcola gli aggiornamenti dei pesi utilizzando l'algoritmo di backpropagation
    % output_delta = (target - output) .* sigmoidDerivative(output);
    output_delta = (target - output);
    for i = numHiddenLayers:-1:1
        hidden_delta = (output_delta * weights.hidden_output(i,:)') .*(1 - tanh(hidden_output(i,:)).^2);
        weights.hidden_output(i,:) = weights.hidden_output(i,:) + learningRate * (hidden_output(i,:)' * output_delta);
        weights.input_hidden(i,:) = weights.input_hidden(i,:) + learningRate * (input' * hidden_delta);
    end
end

function [out,weights, J] = train_ann(input, target, hiddenSize,numHiddenLayers, learningRate, epochs)
    % Addestra la rete neurale per un numero specificato di epoche
    inputSize = size(input, 2);
    outputSize = size(target, 2);
    weights = initializeWeights(inputSize, hiddenSize,numHiddenLayers, outputSize);
    
    for epoch = 1:epochs
        totalError = 0;
        for i = 1:size(input, 1)
            currentInput = input(i, :);
            currentTarget = target(i, :);
            
            [output, hidden_output] = feedforward(currentInput, weights,numHiddenLayers);
            error(i) = target(i)-output;
            
            weights = updateWeights(currentInput, hidden_output,numHiddenLayers, output, currentTarget, weights, learningRate);
            out(i) = output;
        end
        J(epoch) = (1/numel(input))*(sum((target-out').^2));
    end
end
