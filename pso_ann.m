%% Problem Definition
global nofinp opt_nnvar

CostFunction=@(x) fitness(x);        % Cost Function
nVar=1+(nofinp+2)*10;               % Number of Decision Variables
VarSize=[1 nVar];                   % Size of Decision Variables Matrix
VarMin=-1;                         % Lower Bound of Variables
VarMax=1;                         % Upper Bound of Variables
%% PSO Parameters
MaxIt=4000;      % Maximum Number of Iterations
nPop=50;        % Population Size (Swarm Size)
Best_Sols=zeros(MaxIt,1);
% PSO Parameters
w=0.9;            % Inertia Weight
w_max=0.9;        % Max Inertiawegith
w_min=0.4;      % Min Inertiawegith
c1=1.5;         % Personal Learning Coefficient
c1_min=1.5;
c1_max=2.5;
c2=1.5;         % Global Learning Coefficient
c2_min=1.5;
c2_max=2.5;
% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;
%% Initialization
empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
particle=repmat(empty_particle,nPop,1);
GlobalBest.Cost=inf;
Best_Particle_Index=0;
for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    %particle(i).Velocity=zeros(VarSize);
    particle(i).Velocity=VelMax*(2*rand(VarSize)-1);
    
    % Evaluation
    particle(i).Cost=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        Best_Particle_Index=i;
        GlobalBest=particle(i).Best;
        
    end
    
end
BestCost=zeros(MaxIt,1);
%% PSO Main Loop
niter=0;
for it=1:MaxIt
    old_gb=GlobalBest;
        
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
                
                Best_Particle_Index=i;
            end
            
        end
        
        
%         % mutation operation
%         if ((rand()*100<5) && ((i>30 && i<90) || (i>110 && i<250)) )
%             % Initialize Position
%             rand_i=ceil(rand()*nPop);
%             %particle(rand_i).Position(ceil(rand()*nVar))=VarMin+rand()*(VarMax-VarMin);
%             particle(rand_i).Position=unifrnd(VarMin,VarMax,VarSize);
%             % Evaluation
%             particle(rand_i).Cost=CostFunction(particle(rand_i).Position);
% 
%             % Update Personal Best
%             particle(rand_i).Best.Position=particle(rand_i).Position;
%             particle(rand_i).Best.Cost=particle(rand_i).Cost;
% 
%             % Update Global Best
%             if particle(rand_i).Best.Cost<GlobalBest.Cost
%                 GlobalBest=particle(rand_i).Best;
%                 Best_Particle_Index=rand_i;
%             end
%         end
%         
        
    end
    
    if (old_gb.Cost-GlobalBest.Cost)<1e-3
        niter=niter+1;
    end

    if niter>2
        particle(Best_Particle_Index).Position=unifrnd(VarMin,VarMax,VarSize);
        particle(Best_Particle_Index).Cost=CostFunction(particle(Best_Particle_Index).Position);
        niter=0;
    end
    

    BestCost(it)=GlobalBest.Cost;
    Best_Sols(it)=BestCost(it);    

    %Update Intertial weight Learning coeffcients
    w=w_max-(w_max-w_min)/MaxIt*it;
    w=w*(it<200);
    c1=c1_max-(c1_max-c1_min)/MaxIt*it;   
    c2=c2_min+(c2_max-c2_min)/MaxIt*it;     
    
    ss=sum(abs(old_gb.Position-GlobalBest.Position));
    if ss~=0
        %disp(['Global Best Diff= ' num2str(ss)])
        disp(['Global Best= ' num2str(GlobalBest.Position(1:4))])
        disp(['Best Index= ' num2str(Best_Particle_Index)])
    end
    %disp(['Best Cost at It ' num2str(it) ' ='  num2str(GlobalBest.Cost)])
end
BestSol = GlobalBest;
disp(['Min Fitness Functions = ' num2str(GlobalBest.Cost) '%']);
var_plot(1:MaxIt,Best_Sols,'Convergence','Iterations','Fitness function')
opt_nnvar=GlobalBest.Position;