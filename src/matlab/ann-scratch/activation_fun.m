function out = activation_fun(in,type)
    switch type
        case 'sigmoid'
            out =  1./(1 + exp(-in));
        case 'ReLU'
            out = in.*(in > 0);
            nanIndices = isnan(out);
            out(nanIndices) = 0;  % Sostituzione dei NaN con 0
        case 'SoftMax'
            exponents = exp(in-max(in));
            sum_exponents = sum(exponents);
            out = exponents ./ sum_exponents;
        case 'tanh'
            out = tanh(in);
        case 'linear'
            out = in;
    end
end