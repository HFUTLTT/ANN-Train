function dy = der_act_func( z, func_type )
switch func_type
    % 0 sigmoid
    case 0
        dy = act_func(z,func_type).*(1-act_func(z,func_type));
    % 1 linear
    case 1
        dy = 1;
    % 2 tangent hyborbolic
    case 2
        dy = sech(z).^2;
    % 3 ReLu
    case 3
        dy = z>0;
    

end

