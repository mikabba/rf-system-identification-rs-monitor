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
% Create and configure the neural network
clc
net = feedforwardnet([10 10]); % Two hidden layers with 10 neurons each
net.layers{1}.transferFcn = 'tansig'; % Tangent sigmoid activation function for the first layer
net.layers{2}.transferFcn = 'purelin'; % Linear activation function for the output layer
net.trainParam.epochs = 100;

% Prepare the training data
inputTrain = trainD.InputData;
outTrain = trainD.OutputData;

% Train the neural network
[trained_net, TR]  = train(net, inputTrain, outTrain);

% Evaluate the network
inputValid = validD.InputData;
outValid = validD.OutputData;

outputValid = sim(trained_net, inputValid);
figure,
hold on
plot(outputValid)
plot(outValid)
% Compare the predicted output with the actual output and compute metrics
% Add your own code here to analyze the performance of the network

%%
close all
[y_est,J,W,hidden_layers] = neuralnetwork(inputTrain',outTrain',100,0.1,0.01,5,40,1e-3);

J(end)
figure,plot(y_est)
% figure,plot(outTrain)
% figure,stem(J)
% xlabel("Epoche")
% ylabel("J")
grid on
%%
inputValid = validND.InputData;
outValid = validND.OutputData;
[output,JV] = feedforward(outValid',W,hidden_layers);
figure,
plot(output)
hold on
plot(outValid)
legend JV
%%
clc
close all
[y_est,J,W,hidden_layers] = neuralnetwork(inputTrain',outTrain',200,0.1,0.1,2,20,1e-3);

J(end)
figure,plot(y_est)
% figure,plot(outTrain)
% figure,stem(J)
% xlabel("Epoche")
% ylabel("J")
grid on
%%
function alpha = neuron(input, weights,type)
    
    n = sum(input.*weights,1);
    switch(type)
        case 'hidden'
            % alpha = max(0.01*n,n);
            alpha = (1-exp(-2*n))/(1+exp(-2*n));
            % alpha = sin(n);
            % alpha = (1)/(1+exp(-n));
            % alpha = max(0,n);
        case 'output'
            alpha = n;
    end
end

function layerOutput = neuralLayer(input, weights,type)
    [nin,nout] = size(weights);
    for i = 1:nout
        layerOutput(i,:) = neuron(input, weights(:,i), type);
    end
end

function [output,J,weights,hidden_layers,neurons_hiddenlayers] = neuralnetwork(input,out,epocs,learning_rate_init,learning_rate_decay,hidden_layers,neurons_hiddenlayers,J_threshold)
    
    stop_training = false;
    layersTot = 2+hidden_layers;
    neurons_layers = [1 repmat(neurons_hiddenlayers,1,hidden_layers) 1];
    grad_sq_sum = cell(1, layersTot-1); % Sum of squared gradients for Adagrad
    for i = 1:layersTot-1
        weights{i} = rand(neurons_layers(i),neurons_layers(i+1));
        grad_sq_sum{i} = zeros(neurons_layers(i),1);
    end
    
    epsilon = 1e-8; % Small constant to avoid division by zero
    
    
    for p = 1:epocs
        % Feed forward
        for t = 1:numel(input)
            input_hidden{1} = input(:,t);
            outputhidden{1} = neuralLayer(input_hidden{1}, weights{1},'hidden');
            input_hidden{2} = outputhidden{1};
            i = 2;
            while(i <= hidden_layers)
                outputhidden{i} = neuralLayer(input_hidden{i}, weights{i},'hidden');
                input_hidden{i+1} = outputhidden{i};
                i = i + 1;
            end
            output(:,t) = neuralLayer(input_hidden{i}, weights{i},'output');
            error(:,t) = out(:,t) - output(:,t);

            % Backpropagation-output layer
            if(p < epocs)
                grad_sq_sum{end} = grad_sq_sum{end} + outputhidden{end}.^2;
                weights{end} = weights{end} + (learning_rate_init./(sqrt(grad_sq_sum{end}) + epsilon)) .* outputhidden{end} .* error(:,t);
                
                % Backpropagation-hidden layer
                for i = layersTot-2:-1:1
                    nextLayerWeights = weights{i+1};
                    layerWeights = weights{i};
                    grad_sq_sum{i} = grad_sq_sum{i} + input_hidden{i}.^2; % Accumulate squared gradients
                    [nin_nl, nout_nl] = size(nextLayerWeights);
                    [nin_l, nout_l] = size(layerWeights);
                    for j = 1:nout_l
                        n = sum(layerWeights(:,j).*input_hidden{i});
                        % dFun = 0.01*(n<=0) + 1*(n>0);
                        % dFun = cos(n);
                        dFun = 1 - tanh(n)^2;
                        % dFun = exp(-n)/(exp(-n) + 1)^2;
                        % dFun = n > 0;
                        grad_update = (learning_rate_init./(sqrt(grad_sq_sum{i}) + epsilon)) .* input_hidden{i} .* dFun .* sum(-nextLayerWeights(j,:).*error(:,t));
                        layerWeights(:,j) = layerWeights(:,j) - grad_update;
                    end
                    weights{i} = layerWeights;
                    clear nextLayerWeights layerWeights
                end
            end

        end
        
        J(p) = (1/numel(input))*sum(error.^2);
        if J(p) < J_threshold
            stop_training = true;
            break;
        end
        
        % Decay learning rate for Adagrad
        learning_rate_init = learning_rate_init * learning_rate_decay;
    end

    if stop_training
        disp('Training terminato in anticipo a causa del raggiungimento della soglia J.');
    else
        disp('Training completato per il numero massimo di epoche.');
    end
    
end

function [output,J] = feedforward(input,weights,hidden_layers)
    for t = 1:numel(input)
                input_hidden{1} = input(:,t);
                outputhidden{1} = neuralLayer(input_hidden{1}, weights{1},'hidden');
                input_hidden{2} = outputhidden{1};
                i = 2;
                while(i <= hidden_layers)
                    outputhidden{i} = neuralLayer(input_hidden{i}, weights{i},'hidden');
                    input_hidden{i+1} = outputhidden{i};
                    i = i + 1;
                end
                output(:,t) = neuralLayer(input_hidden{i}, weights{i},'output');
                error(:,t) = out(:,t) - output(:,t);
    end
    J = (1/numel(input))*sum(error.^2);
end
