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

    layers(4) = updateWeightsAndBiases(layers(4), alpha);
    layers(3) = updateWeightsAndBiases(layers(3), alpha);
    layers(2) = updateWeightsAndBiases(layers(2), alpha);
    layers(1) = updateWeightsAndBiases(layers(1), alpha);

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
%%
[yest,J,weights] = train_ann(u,y,1000,4,20,["ReLU","linear"],0.1);

J(end)
% figure,plot(J)
figure,
plot(u,yest)
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