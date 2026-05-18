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