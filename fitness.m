function cost = fitness(nn_vars)
global nn_input nn_gauge

e_mape=0;

for i=1:size(nn_input,1)
    [outputs,~] = eec_neuralnet(nn_input(i,:)',nn_vars);
    e_mape=e_mape+abs(outputs{3}-nn_gauge(i))/nn_gauge(i)*100;
end    
e_mape=e_mape/size(nn_input,1);

cost=e_mape;
end

