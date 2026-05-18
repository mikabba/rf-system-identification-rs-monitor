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