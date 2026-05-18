function out = deltaActivation_fun(in, type)
    switch type
        case 'sigmoid'
            sigmoid_output = 1./ (1 + exp(-in));
            out = sigmoid_output.* (1 - sigmoid_output);
        case 'ReLU'
            out = in > 0;
        case 'SoftMax'
            exponents = exp(in-max(in));
            sum_exponents = sum(exponents);
            softmax_output = exponents ./ sum_exponents;
            out = softmax_output .* (1 - softmax_output);
        case 'tanh'
            out = 1 - tanh(in).^2;
        case 'linear'
            out = 1;
    end
end
