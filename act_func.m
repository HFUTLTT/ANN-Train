function y = act_func( z, func_type )
switch func_type
    % 0 sigmoid
    case 0
        y = 1./(1+exp(-z));
    % 1 linear
    case 1
        y = z;
    % 2 tangent hyborbolic
    case 2
        y = tanh(z);
    % 3 ReLu
    case 3
        y = max([0 z]);
    

end

