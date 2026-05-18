function layers = init_ann(x,y, nLayers, hidden_size, activations)
    layers(1) = init_layer(x,hidden_size,activations(1));
    
    for i =2:nLayers-1
        layers(i) = init_layer(layers(i-1).out,hidden_size,activations(1));
    end
    [nOut,nBatch] = size(y);
    layers(end+1) = init_layer(layers(nLayers-1).out,nOut,activations(2));
end
