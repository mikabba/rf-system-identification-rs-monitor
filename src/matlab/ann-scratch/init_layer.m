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