clc
clear
close all
u = 0:0.01:10;
y = [sin(u)];
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
[yest,J,weights] = train_ann(u,y,30,3,20,["ReLU","linear"],0.1);

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