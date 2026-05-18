function alpha = neuron(input, weights,type)
    
    n = sum(input.*weights,1);
    switch(type)
        case 'hidden'
            alpha = tanh(n);
        case 'output'
            alpha = n;
    end
end
