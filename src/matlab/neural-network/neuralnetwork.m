function [output,J,weights] = neuralnetwork(input,epocs,learning_rate,hidden_layers,neurons_hiddenlayers)
    
    weights = randn(neurons_hiddenlayers,hidden_layers+1);
    for p = 1:epocs
        %% Feed forward
        for t = 1:numel(input)
            input_hidden{1} = input(:,t);
            outputhidden{1} = neuralLayer(input_hidden{1}, weights(:,1), neurons_hiddenlayers,'hidden');
            input_hidden{2} = outputhidden{1};
            i = 2;
            while(i <= hidden_layers)
                outputhidden{i} = neuralLayer(input_hidden{i}, weights(:,i), neurons_hiddenlayers,'hidden');
                input_hidden{i+1} = outputhidden{i};
                i = i + 1;
            end
            output(:,t) = neuralLayer(input_hidden{i}, weights(:,i), 1,'output');
            error(:,t) = input(:,t) - output(:,t);
            %% Backpropagation-output layer
            
            weights(:,end) = weights(:,end) + learning_rate*outputhidden{end}*error(t);
            %% Backpropagation-hidden layer
            for i = hidden_layers:-1:1
                dFun = 1 - tanh(sum(weights(:,i).*input_hidden{i}))^2;
                weights(:,i) = weights(:,i) - learning_rate * input_hidden{i} * dFun * sum(-error(t) * weights(:,end)');
            end
        end
        J(p) = (1/numel(input))*sum(error.^2);
    end
end

