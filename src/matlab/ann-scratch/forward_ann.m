function layer = forward_ann(layer,in)
    layer.in = in;
    layer.z = layer.weights*layer.in + layer.biases;
    layer.out = activation_fun(layer.z,layer.type);
end