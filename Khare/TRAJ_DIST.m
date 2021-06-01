function [dist] = TRAJ_DIST(traj,NumFact,r)
%TRAJ_DIST takes trajectories, number of factors and number of trajectories
%as inputs and returns Euclidean distance between trajectories
%   traj = matrix of trajectories
%   NumFact = number of factors/parameters
%   r = Number of trajectories

%Matrix Initialization
traj_dist(1:r,1:r)=zeros;
sq_traj_dist(1:r,1:r)=zeros;
sum=0;

%Function DIST1 calculates the Euclidean distance between two trajectories
for i=1:r
    for j=i+1:r
        traj_dist(i,j)=DIST1(traj(i*(NumFact+1)-NumFact:i*(NumFact+1),:),traj(j*(NumFact+1)-NumFact:j*(NumFact+1),:),NumFact);%Calculates the Euclidean distances between trajectories t1 and t2
        sq_traj_dist(i,j)=traj_dist(i,j)*traj_dist(i,j);
        sum=sum+sq_traj_dist(i,j);
    end
end
dist=sqrt(sum);
end

