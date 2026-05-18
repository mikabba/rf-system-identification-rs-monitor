function [out,error_training,error_valid,ann,epoch] = train_ann2(x, y,x_val,y_val, epochs,nLayers,hidden_size, activations, alpha)
    layers = init_ann(x, y, nLayers,hidden_size, activations);
    [nOut,nBatch] = size(y);
    prev_error = repmat(1000,nOut,1);
    for epoch = 1:epochs
        layers = forwardPropagation(layers, x, y);
        if(epoch + 1 < epochs)
           layers = updateWeightsAndBiases(layers, alpha);
        end
        ann = init_ann(x, y, nLayers,hidden_size, activations);
        for j = 1:numel(layers)
            ann(j).weights = layers(j).weights;
            ann(j).biases = layers(j).biases;
        end
        if nOut > 1
            error_training(:, epoch) = (1/numel(y)) * sum((y - layers(end).out).^2, 2);
            [yval_est,error_valid(:,epoch)] = sim_ann(x_val,y_val,ann);
        else
            error_training(epoch) = (1/numel(y)) * sum((y - layers(end).out).^2);
            [yval_est,error_valid(epoch)] = sim_ann(x_val,y_val,ann);
        end
        
        if abs(error_valid(epoch) - prev_error) <= 1e-10
            break;
        end
        prev_error = error_valid(epoch);
        
    end
    out = layers(end).out;

end