clc
clear
close all
u = 0:0.01:10;
y = sin(u);
% figure,plot(u,y)
X = [1 2 3 2.5; ...
     2 5 -1 2; ...
     -1.5 2.7 3.3 -.8]';
y = y;
X = u;

% Weights-Biases initialization
in = X;
nHLayer = 2;
% nNeurons_hl = 3;
[nOut,nBatch] = size(y);
layers(1) = init_layer(in,50,'ReLU');
layers(2) = init_layer(layers(1).out,50,'ReLU');
layers(3) = init_layer(layers(2).out,50,'ReLU');
layers(4) = init_layer(layers(3).out,nOut,'linear');
alpha = 0.1;
for i = 1:1000
    layers(1) = forward_ann(layers(1),X);
    layers(2) = forward_ann(layers(2),layers(1).out);
    layers(3) = forward_ann(layers(3),layers(2).out);
    layers(4) = forward_ann(layers(4),layers(3).out);
    
    layers(4).error = y - layers(4).out;
    layers(3).error = (layers(4).weights)'*layers(4).error;
    layers(2).error = (layers(3).weights)'*layers(3).error;
    layers(1).error = (layers(2).weights)'*layers(2).error;

    layers(4).dW = alpha*layers(4).error.*deltaActivation_fun(layers(4).z,layers(4).type)*layers(4).in';
    layers(4).dB = alpha*layers(4).error.*deltaActivation_fun(layers(4).z,layers(4).type);
    layers(4).weights = layers(4).weights + layers(4).dW;
    layers(4).biases = layers(4).biases + layers(4).dB;

    layers(3).dW = alpha*layers(3).error.*deltaActivation_fun(layers(3).z,layers(3).type)*layers(3).in';
    layers(3).dB = alpha*layers(3).error.*deltaActivation_fun(layers(3).z,layers(3).type);
    layers(3).weights = layers(3).weights + layers(3).dW;
    layers(3).biases = layers(3).biases + layers(3).dB;

    layers(2).dW = alpha*layers(2).error.*deltaActivation_fun(layers(2).z,layers(2).type)*layers(2).in';
    layers(2).dB = alpha*layers(2).error.*deltaActivation_fun(layers(2).z,layers(2).type);
    layers(2).weights = layers(2).weights + layers(2).dW;
    layers(2).biases = layers(2).biases + layers(2).dB;

    layers(1).dW = alpha*layers(1).error.*deltaActivation_fun(layers(1).z,layers(1).type)*layers(1).in';
    layers(1).dB = alpha*layers(1).error.*deltaActivation_fun(layers(1).z,layers(1).type);
    layers(1).weights = layers(1).weights + layers(1).dW;
    layers(1).biases = layers(1).biases + layers(1).dB;

    error(i) = (1/numel(y))*sum((y-layers(4).out).^2);
end

disp(layers(4).out)
% figure,plot(error)
figure,
plot(u,layers(4).out)
figure,
plot(u,layers(4).out)
hold on
plot(u,y)


% % for i = 1:nHLayer
% %     layers(i) = init_layer(in,nNeurons_hl);
% %     in = [];
% %     in = layers(i).out;
% % end
% layers(1) = forward_ann(layers(1),X);
% disp(layers(1).out)

% disp(layers(2).out)