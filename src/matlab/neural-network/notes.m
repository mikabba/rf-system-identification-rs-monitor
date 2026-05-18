clc
clear
clc
clear
load("../Segnale nullo/25MHz/data_iddataC.mat");
input = data.InputData(:,1);
neuralnetwork(input,10,1,5,50)
function output = neuralnetwork(input, neurons_inputlayer, neurons_outputlayer, hidden_layers, neurons_hiddenlayers)
    weights_input = rand(1, neurons_inputlayer);
    weights_hidden = rand(hidden_layers, neurons_hiddenlayers);
    weights_output = rand(1, neurons_outputlayer);
    bias_input = rand(1, neurons_inputlayer);
    bias_hidden = rand(hidden_layers, neurons_hiddenlayers);
    bias_output = rand(1, neurons_outputlayer);

    outputinputlayer = neuralLayer(input, weights_input, bias_input, neurons_inputlayer);
    
    if hidden_layers > 0
        outputhidden = outputinputlayer;
        for i = 1:hidden_layers-1
            outputhidden = neuralLayer(outputhidden, weights_hidden(i, :), bias_hidden(i, :), neurons_hiddenlayers);
        end
        output = neuralLayer(outputhidden, weights_output, bias_output, neurons_outputlayer);
    elseif neurons_outputlayer > 0
        output = neuralLayer(outputinputlayer, weights_output, bias_output, neurons_outputlayer);
    else
        output = outputinputlayer;
    end
end

function layerOutput = neuralLayer(input, weights, bias, numNeurons)
    
    for i = 1:numNeurons
        layerOutput(i) = neuron(input, weights(i), bias(i));
    end
end

function alpha = neuron(input, weights, bias)
    n = sum(input .* weights) + bias;
    alpha = 1./ (1 + exp(-n));
end
