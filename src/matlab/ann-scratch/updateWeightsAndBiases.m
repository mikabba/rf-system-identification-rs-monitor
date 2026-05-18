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