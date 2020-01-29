function [ R2, MSE, MAE ] = errors( nn_vars )
global nn_input nn_gauge

NumofData = size(nn_input,1);
SumofSq=0;
SumofAbs=0;
Mean = sum(nn_gauge)/NumofData;
DisToMean = 0;
for i=1:size(nn_input,1)
    [outputs,~] = eec_neuralnet(nn_input(i,:)',nn_vars);
    SumofSq=SumofSq+(outputs{3}-nn_gauge(i)).^2;
    SumofAbs=SumofAbs+abs(outputs{3}-nn_gauge(i));
    DisToMean = DisToMean + (Mean-nn_gauge(i)).^2;
end 

MSE = SumofSq/NumofData;
MAE = SumofAbs/NumofData;
R2 = 1 - SumofSq / DisToMean;


end

