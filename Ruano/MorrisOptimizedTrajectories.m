% Optimization in the choice of trajectories for the Morris experiment
% clear all

% Inputs
% N:= [1,1]         Total number of trajectories Same 
% p:= [1,1]         Number of levels
% r:= [1,1]     Optimum number of trajectories
% k:= [1,1]   Number of factors 
% LB:= [k,1]  Lower bound of the uniform distribution for each factor
% UB:= [k,1]  Upper bound of the uniform distribution for each factor
% GroupMat:=[k,NumGroups] Matrix describing the groups. Each column represents a group and its elements 
%                               are set to 1 in correspondence of the factors that belong to the fixed group. All
%                               the other elements are zero.
% Diagnostic:= [1,1]            Boolean 1=plot the histograms and compute the
%                               efficiency of the samplign or not, 0
%                               otherwise
%   Note: This code modified from simlab matlab code Sampling_Function_2.m, which can
%         be found at http://simlab.jrc.ec.europa.eu/docs/html/Morris__Optimized__Groups_8m-source.html
%         The use of groups has been removed. 

%clear all;
% p= input('How many levels in your morris sampling scheme?');
% k= input('How many factors?');
% UB = input('What is the Upper limit of each factor? Input as a matrix (numfactors,1)ie [1;1;1;1]');
% LB = input('What is the Lower limit of each factor? Input as a matrix (numfactors,1)ie [0;0;0;0]');
% N=input('How Many Trajectories should be created?');
% r=input('How many optimized trajectories?');%this will be used when the selection strategy is programmed

% declare type of distribution for each factor 0 = uniform, 1=normal,...
% 3 = poisson (others can be added

% FactDistType=input('Factor distribution (0=uniform,1=normal,2=gamma)? input as a mtrix (k,1) ie [0; 0; 1; 2]');

%  Define quantiles for non uniform distribution
%QuantP4=[.125,.375,.625,.875];
%QuantP6=[.0833,.25,.4166,.5833,.75,.9166];
%QuantP8=[.0625,.1875,.3125,.4375,.5625,.6875,.8125,.9375];

%tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Inputs
function[Traj]=MorrisOptimizedTrajctories(N,k,p,r)
%p=4;                %  levels
%k=100;                %factors
UB(1:k,1)=ones;     %Upperbound
LB(1:k,1)=zeros;    %lowerbound
%N=1000;             % number of potential trajectories
%r=20;               % number of optimized trajectories

%FactDistType=[0;0;0;0];

% Define r (MaxNumTraj=r(k+1)) from morris 1991.  Be sure r>10 otherwise it
%      is not oversampling. r=10 is required.  Round r up to integer.



[Outmatrix, OutFact] = TrajectorySampler(p, k, N, UB, LB );   % Version with Groups

sizeb = k + 1;

Dist = zeros(N,N);
Diff_Traj = [1:1:N];


% Compute the distance between all pair of trajectories (sum of the distances between points)
% The distance matrix is a matrix N*N
% The distance is defined as the sum of the distances between all pairs of points
% if the two trajectories differ, 0 otherwise
%for j =1:N
%    for z = j+1:N
    
%        MyDist = zeros(sizeb, sizeb);
%        for i = 1:sizeb,
%            for ll = 1:sizeb,    
%                MyDist(i,ll) = (sum((Outmatrix((j-1)*(sizeb) + i,:) - Outmatrix((z-1)*(sizeb) + ll,:)).^2))^0.5;
%            end
%        end
        
%        if size(find(MyDist==0),1) == sizeb,
%            % Same trajectory. If the number of zeros in Dist matrix is equal to 
%            % (k+1) then the trajectory is a replica. In fact (k+1) is the maximum numebr of 
%            % points that two trajectories can have in common
%            Dist(j,z) = 0;     
%            Dist(z,j) = 0;  
            
%           % Memorise the replicated trajectory
%            Diff_Traj(1,z) = 0; 
%        else
%            % Define the distance between two trajectories as 
%            % the minimum distance among their points
%            Dist(j,z) = sum(sum(MyDist));     
%            Dist(z,j) = sum(sum(MyDist));
%        end        
%    end
%end
LB=LB';
UB=UB';
[OptimizedTraj]=TrajOptimizer(Outmatrix,k,LB,UB,r,N);
%[ tempii ] = FactorHistV2(OptimizedTraj,Outmatrix,k,r,p);

% for ii=1:k
%     for jj=1:r*(k+1)
%         if OptimizedTraj(jj,ii)==0
%             OptimizedTraj(jj,ii)=.125;
%         else
%             if OptimizedTraj(jj,ii)==(2/3)
%                 OptimizedTraj(jj,ii)=0.625;
%             else
%                 if OptimizedTraj(jj,ii)==1
%                     OptimizedTraj(jj,ii)=0.875;
%                 else
%                     OptimizedTraj(jj,ii)=0.375;
%                 end
%             end
%         end
%     end
% end
Traj=OptimizedTraj;
end
%toc
















