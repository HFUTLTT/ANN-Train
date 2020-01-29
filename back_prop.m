global nofinp nn_gauge nn_input opt_nnvar n_hid first_func_type second_func_type

n_out = 1; % number of  neurons in the output layer
eta_max = 0.01; % max learning rate
eta_min = 0.001; % max learning rate
nofset=size(nn_input,1);

%initializing weights
    % ---------------------------------------------------------------------
    % between input and hidden layer:
    % [weight is a n_hid*(nofinp) matrix , bias is n_hid*1 matrix] => w1 becomes a n_hid*(nofinp+1) matrix
    % --
    % between hidden and output layer:
    % [weight is a 1*n_hid matrix , bias is 1*1 matrix] => w2 becomes 1*n_hid+1 matrix
    % ---------------------------------------------------------------------
    % one neuron with a constant value (1) is added to input and hidden
    % layers in modd_NN_test.m
    % ---------------------------------------------------------------------
w1=(rand(n_hid,nofinp+1)*2)-1;
w2=(rand(1,n_hid+1)*2)-1;

%declaring weight corrections and errors
dw1=zeros(size(w1));
dw2=zeros(size(w2));
e=zeros(nofset,1);
de=zeros(size(e));

ep_num=300;
for epoch=1:ep_num
    eta=eta_min+(eta_max-eta_min)/epoch;
    %determination of feedforward signal
    for i=1:nofset
        inp=nn_input(i,:)';
        nn_var = [reshape(w1,1,[]), reshape(w2,1,[])];
        [outputs,unacted] = eec_neuralnet( inp, nn_var );
        temp1 = outputs{1};
        y(i,1) = outputs{3};
        %Error and Derivative of Error
        e(i,1) = abs(y(i,1) - nn_gauge(i));
        de(i,1)=(y(i,1)>nn_gauge(i))-(y(i,1)<nn_gauge(i));

        %calculation of weight correction (between output and hidden layer)
        for j=1:(n_hid+1)
            dw2(j)=-eta*de(i,1)*outputs{2}(j)*der_act_func(unacted{3},second_func_type);
        end

        %calculation of weight correction (hidden layer and input)
        for j=1:n_hid
            for k=1:(nofinp+1)
                dw1(j,k)=-eta*de(i,1)*w2(j)*outputs{1}(k)*der_act_func(unacted{2}(j),first_func_type);
            end
        end
 
        %applying weight corrections 
        w1=w1+dw1;
        w2=w2+dw2;
        
        
    end

%     %averaging weight corrections 
%     dw1=dw1/nofset;
%     dw2=dw2/nofset;
    

    
    %calculating Mean Squared Error
    MAPE=sum(e)/nofset;

   
    
    %printing error and epoch
    display(MAPE)
    display(epoch)
end

opt_nnvar=nn_var;
