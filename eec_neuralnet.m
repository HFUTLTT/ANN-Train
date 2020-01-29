function [outputs,unacted] = eec_neuralnet( inputs,nn_vars )
global n_hid nofinp first_func_type second_func_type
w1=nn_vars(1:n_hid*(nofinp+1));
w2=nn_vars((n_hid*(nofinp+1))+1:end);
w1=reshape(w1,n_hid,[]);
w2=reshape(w2,1,[]);
z1=w1*[inputs;1];
y1=act_func(z1,first_func_type);
z2=w2*[y1;1];
y2=act_func(z2,second_func_type);
% outNN=y2;

outputs{1}=[inputs;1];
outputs{2}=[y1;1];
outputs{3}=y2;

unacted{2}=z1;
unacted{3}=z2;


 
end

