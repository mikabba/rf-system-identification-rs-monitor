clc
close all
clear all
load_data

[yest,JT,ann,epochs] = train_ann(inputTrain',outTrain',5000,3,20,["ReLU","linear"],0.02);
JT(end)
epochs

figure,plot(JT)
figure,
plot(yest)
hold on
plot(outTrain)

yv = sim_ann(inputValid',outValid',ann);
figure,
plot(yv)
hold on
plot(outValid')

function [out,error,layers2,epoch] = train_ann(x, y, epochs,nLayers,hidden_size, activations, alpha)
    layers = init_ann(x, y, nLayers,hidden_size, activations);
    [nOut,nBatch] = size(y);
    prev_error = repmat(1000,nOut,1);
    for epoch = 1:epochs
        layers = forwardPropagation(layers, x, y);
        layers = updateWeightsAndBiases(layers, alpha);
        
        if nOut > 1
            error(:, epoch) = (1/numel(y)) * sum((y - layers(end).out).^2, 2);
        else
            error(epoch) = (1/numel(y)) * sum((y - layers(end).out).^2);
        end
        if abs(error(epoch) - prev_error) <= 1e-6
            break;
        end
        prev_error = error(epoch);
    end
    out = layers(end).out;
    layers2 = init_ann(x, y, nLayers,hidden_size, activations);
    for j = 1:numel(layers)
        layers2(j).weights = layers(j).weights;
        layers2(j).biases = layers(j).biases;
    end
end
function layers = init_ann(x,y, nLayers, hidden_size, activations)
    layers(1) = init_layer(x,hidden_size,activations(1));
    
    for i =2:nLayers-1
        layers(i) = init_layer(layers(i-1).out,hidden_size,activations(1));
    end
    [nOut,nBatch] = size(y);
    layers(end+1) = init_layer(layers(nLayers-1).out,nOut,activations(2));
end
function layer = init_layer(X,nNeurons,type)
    % Init
    [nInput,nChannel] = size(X);
    layer.in = X;
    X = zeros(size(X));
    weights = 0.10*(2*randn(nNeurons,nInput)-1);
    biases = zeros(nNeurons,1);
    % Feedforward
    out = weights*X + biases;
    layer.type = type;
    layer.weights = weights;
    layer.biases = biases;
    layer.error = out;
    layer.dW = zeros(size(weights));
    layer.dB = zeros(size(biases));
    layer.z = out;
    layer.out = out;
    
end
function updatedLayers = forwardPropagation(layers, X, y)
    numLayers = numel(layers);
    
    layers(1) = forward_ann(layers(1), X);
    
    for i = 2:numLayers
        layers(i) = forward_ann(layers(i), layers(i-1).out);
    end
    
    saturation_threshold = 10000;
    layers(numLayers).error = max(min(y - layers(numLayers).out, saturation_threshold), -saturation_threshold);
    
    for i = numLayers-1:-1:1
        layers(i).error = (layers(i+1).weights)' * layers(i+1).error;
        layers(i).error = max(min(layers(i).error, saturation_threshold), -saturation_threshold);
    end
    
    updatedLayers = layers;
end
function layer = forward_ann(layer,in)
    layer.in = in;
    layer.z = layer.weights*layer.in + layer.biases;
    layer.out = activation_fun(layer.z,layer.type);
end
function out = activation_fun(in,type)
    switch type
        case 'sigmoid'
            out =  1./(1 + exp(-in));
        case 'ReLU'
            out = in.*(in > 0);
            nanIndices = isnan(out);
            out(nanIndices) = 0;  % Sostituzione dei NaN con 0
        case 'SoftMax'
            exponents = exp(in-max(in));
            sum_exponents = sum(exponents);
            out = exponents ./ sum_exponents;
        case 'tanh'
            out = tanh(in);
        case 'linear'
            out = in;
    end
end
function updatedLayers = updateWeightsAndBiases(layers, alpha)
    numLayers = numel(layers);
    
    for i = numLayers:-1:1
        layers(i).dW = alpha*layers(i).error.*deltaActivation_fun(layers(i).z,layers(i).type)*layers(i).in';
        layers(i).dB = alpha*layers(i).error.*deltaActivation_fun(layers(i).z,layers(i).type);
        layers(i).weights = layers(i).weights + layers(i).dW;
        layers(i).biases = layers(i).biases + layers(i).dB;
    end
    
    updatedLayers = layers;
end
function out = deltaActivation_fun(in, type)
    switch type
        case 'sigmoid'
            sigmoid_output = 1./ (1 + exp(-in));
            out = sigmoid_output.* (1 - sigmoid_output);
        case 'ReLU'
            out = in > 0;
        case 'SoftMax'
            exponents = exp(in-max(in));
            sum_exponents = sum(exponents);
            softmax_output = exponents ./ sum_exponents;
            out = softmax_output .* (1 - softmax_output);
        case 'tanh'
            out = 1 - tanh(in).^2;
        case 'linear'
            out = 1;
    end
end


