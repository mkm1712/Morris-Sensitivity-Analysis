function [Traj,R]= Sampling_Stat(NumFact,r,p)
%Function Sampling_Stat generates 'r' trajectories of 'NumFact' parameters  
Uni_Traj_FLPts(1:r,1:NumFact)=NaN;
ct=1;
while ct==1
    [Uni_Traj_FLPts,c]=UNIQ_TRAJ_GEN_CHECK(NumFact,r,p);%UNIQ_TRAJ_GEN_CHECK generates first and last point of 'r' trajectories and provides check for their uniqueness
    ct=c;
%     if ct==0
%         %I=i;
%         %fprintf('\n Unique Trajectories Generated\n');
%         break;
%     end
end

%Traj_del(1:r*(NumFact+1),1)=zeros;%Traj_del is the pertubation vector used to generate intermediate points of trajectories
%Traj(1:r*(NumFact+1),1:NumFact)=zeros;
% for j=1:r
    %Traj_del((NumFact+1)*(j-1)+1:(NumFact+1)*(j-1)+NumFact,1)=UNI_DEL(NumFact);%Function UNI_DEL generates a unique pertubation vector 'Traj_del'
    %tr=TRAJ_GEN(Uni_Traj_FLPts(j,:),Traj_del((NumFact+1)*(j-1)+1:(NumFact+1)*(j-1)+NumFact,1), NumFact,p);%Function TRAJ_GEN generates complete parameter sample from first and last points and delta vector
    tr=RadialTraj(Uni_Traj_FLPts,p);
    %Traj((NumFact+1)*(j-1)+1:(NumFact+1)*(j-1)+NumFact+1,1:NumFact)=tr;
    Traj=tr;
% end
%D=TRAJ_DIST(Traj,NumFact,r);%Function TRAJ_DIST calculates the Euclidean Distance
    R=Repeat_Count(Traj);%Check to find if there is any repetition of sample point
%     if R(1,1)>0
%     fprintf('\n Caution: One or more sample points are repeated\n');
%     end
end

