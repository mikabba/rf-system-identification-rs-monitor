function layerOutput = neuralLayer(input, weights, numNeurons,type)
    for i = 1:numNeurons
        layerOutput(i,:) = neuron(input, weights, type);
    end
end