function out = sim_ann(x,y,ann)
    ann = forwardPropagation(ann, x, y);
    out = ann(end).out;
end