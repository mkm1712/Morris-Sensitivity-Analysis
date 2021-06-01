function [Traj,time,R] = SU_Sampling(NumFact,Q,r,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SU_Sampling function generates parameter samples to perform parameter   %                                        
%   screening using the method of Elementary Effects                      %                                                              
%                                                                         %                                  
% This code is based on logic - Sampling for Uniformity- developed by     %
%   Khare et al.                                                          %
%                                                                         %                                 
% There are three inputs to this function:-                               %
% NumFact = Number of Input Factor or Parameters to be Sampled            %
% Q = Oversampling Size                                                   %
% r = Number of Trajectories (should be an even number)                   %
% trunc = truncation to be done or not: 0 - no truncation, 1 - truncation %
%								at 0.125 and 0.875 						  %
% p = 4; Number of levels (Hard coded)                                    %
%                                                                         %
% Function outputs consist of:-                                           %
% (1) Traj: sample in the form of 'r' trajectories sampled from unit      %
%       hyperspace truncated at 0.125 and 0.875                           %
% (2) D: Euclidean Distance between trajectories, a measure of sample     %
%       spread                                                            %
% (3) time: time required for sample generation in seconds                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = unifrnd(1,10,1,1);%To induce randomness in trajectory generation
c = ceil(c);
%if mod(r,2)==0
    %Matrix initilization
    %D(1,1)=zeros;
    R1(1:Q,1)=zeros;
    R2(1:Q,1)=zeros;
    %R(1:1,1)=zeros;
    time(1,1)=zeros;
    traj1(1:(NumFact+1)*r,1:NumFact)=zeros;
    traj2(1:(NumFact+1)*r,1:NumFact)=zeros;
    
    c;
    %Sampling_Stat(c,4,4); %Used to induce randomness in trajectory
    %generation
    %counter =0;
    tic;%start of sample generation
    R=1;
    %while (R>0)||(counter<101)
       % counter=counter+1;
    % for loop below repeats the sample generation experiment 'N' times and
    % selects the trajectories with highest spread
    for ii=1:Q 
        %ii
        %Function Sampling Stat generates 'r' trajectories for 'NumFact'
        %parameters and corresponding Euclidean distance 'D' 
        [traj2,R2(ii,1)]=Sampling_Stat(NumFact,r,p);
        if (ii>1)&&(R2(ii,1)<R1(ii-1,1))
            fprintf('ii>2 and R2<R1\n');
            traj1=traj2;
            R1(ii,1)=R2(ii,1);
        elseif (ii>1)&&(R2(ii,1)>=R1(ii-1,1))
            fprintf('ii>2 and R2>=R1\n');
            R1(ii,1)=R1(ii-1,1);
        else
            traj1=traj2;
            R1(ii,1)=R2(ii,1);
        end
        %[ii,R1(ii,1),R2(ii,1)]
    end
    %time=toc;% end of sample generation
    Traj=traj1;
    %R=R1(Q,1)
      
    %end
	%trunc = 0;
%     if trunc==0
%         [Traj_tr]=TRAJ_TRANS(Traj);
%         Traj=Traj_tr;
%     end
% else
% 
%     % This program requires 'r' to be an even number
%     % If 'r' is not even, no sample is generated and following error is
%     % flashed
%     fprintf('\n Error: Number of Trajectoris (r) should be even\n');
end



