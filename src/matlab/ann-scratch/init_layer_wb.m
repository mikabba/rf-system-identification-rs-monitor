function layer = init_layer_wb(X,type,weights,biases)
    % Init
    layer.in = X;
    X = zeros(size(X));
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