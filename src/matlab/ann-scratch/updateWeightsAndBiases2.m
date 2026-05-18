function updatedLayers = updateWeightsAndBiases2(layers, alpha)
    numLayers = numel(layers);
    [~,nSamples] = size(layers(1).in);
    for i = numLayers:-1:1
        layers(i).dW = alpha*layers(i).error.*deltaActivation_fun(layers(i).z,layers(i).type)*layers(i).in';
        layers(i).dB = (2/nSamples)*alpha*sum(layers(i).error.*deltaActivation_fun(layers(i).z,layers(i).type),2);
        
        % Aggiunta della saturazione a layers(i).dW
        saturation_threshold_dw = 1.0; % Valore massimo consentito per dW
        layers(i).dW = max(min(layers(i).dW, saturation_threshold_dw), -saturation_threshold_dw);
    
        % Aggiunta della saturazione a layers(i).dB
        saturation_threshold_db = 1.0; % Valore massimo consentito per dB
        layers(i).dB = max(min(layers(i).dB, saturation_threshold_db), -saturation_threshold_db);
    
        % Aggiunta della saturazione agli aggiornamenti dei pesi
        saturation_threshold_weights = 100.0; % Valore massimo consentito per gli aggiornamenti dei pesi
        layers(i).weights = max(min(layers(i).weights, saturation_threshold_weights), -saturation_threshold_weights);
        
        % Aggiunta della saturazione agli aggiornamenti dei bias
        saturation_threshold_biases = 100.0; % Valore massimo consentito per gli aggiornamenti dei bias
        layers(i).biases = max(min(layers(i).biases, saturation_threshold_biases), -saturation_threshold_biases);
    end
    
    updatedLayers = layers;
end