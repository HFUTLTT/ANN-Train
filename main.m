%% READING AND NORMALIZING DATA 
disp('Reading Data From data.xlsx...')
readnorm_data()


%% Simulation Settings
% optimization algorithm 
% 0 for PSO (Particle Swarm Optimization)
% 1 for SFLA (Shuffled Leap Frog)
% 2 for Back Propogation
optimization_type=2;

% input data type
% 0 for socio-ecenomic variables
% 1 for socio-ecenomic variables plus DSM
% 2 for EEC
input_data_type=0;




%% GLOBAL PARAMETERS
global nofinp nn_input nn_gauge opt_nnvar n_hid first_func_type second_func_type
% activation function type
% 0 sigmoid
% 1 linear
% 2 tangent hyborbolic
% 3 ReLu
% first layer activation function
first_func_type = 1;
% second layer activation function
second_func_type = 0;

n_hid=10;

disp('Using GDP, IMP, EXP, POP 1967-2001 as input');
nofinp=4;
input_range=2:35;
nn_input=[GDP(train_range),IMP(train_range),EXP(train_range),POP(train_range)];
nn_gauge=EEC(train_range);
%% Particle Swarm Optimization
disp('Training Neural Network...')

switch optimization_type
    case 0
        disp('Using Particle Swarm Optimization');
        pso_ann();
    case 1 
        disp('Using Shuffled Frog-Leaping Algorithm');
        sfla_ann();
    case 2 
        disp('Using BackPropogation Algorithm');
        back_prop();    
end        

%% CALCULATE THE ERROR USING OPTIMIZED WEIGHT AND BIAS VALUES

disp('Testing Neural Network using 2002-2009 data...')


nn_input=[GDP(test_range),IMP(test_range),EXP(test_range),POP(test_range)];
nn_gauge=EEC(test_range);

e_mape=fitness(opt_nnvar);
[ R2, MSE, MAE ] = errors( opt_nnvar );
disp(['MAPE Error= ' num2str(e_mape) '%' ]);
disp(['MSE Error= ' num2str(MSE) ]);
disp(['MAE Error= ' num2str(MAE)  ]);
disp(['R2 Score= ' num2str(R2) ]);

%% GENERATE DATA FOR 2010-2030
nofy_future = 20;
if (input_data_type==0 || input_data_type==1)
    %GDP
    GDP=[GDP;gen_new_data(GDP,YEARS(end),nofy_future)];
    %IMP
    IMP=[IMP;gen_new_data(IMP,YEARS(end),nofy_future)];
    %EXP
    EXP=[EXP;gen_new_data(EXP,YEARS(end),nofy_future)];
    %POP
    POP=[POP;gen_new_data(POP,YEARS(end),nofy_future)];

    YEARS = [YEARS; (1:nofy_future)'+YEARS(end)];

    EEC=[EEC; zeros(size(1:nofy_future))'];

    switch input_data_type
        case 0
            nn_input=[GDP(test_range(end):end),IMP(test_range(end):end),EXP(test_range(end):end),POP(test_range(end):end)];
    end
    for i=1:nofy_future
        j=length(YEARS)-nofy_future+i;
        [outputs,~] = eec_neuralnet(nn_input(i,:)',opt_nnvar);
        EEC(j)= outputs{3};
    end
    
    figure
    var_plot(YEARS,EEC*(max_EEC-min_EEC)+min_EEC,'Forecast','Years','EEC');
end