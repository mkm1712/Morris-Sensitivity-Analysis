function [radtraj] = RadialTraj(Uni_Traj_FPts,p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[NumTraj,NumFac]=size(Uni_Traj_FPts);
LPts(1:NumTraj,1:NumFac)=NaN;

for i =1:NumTraj
    for j=1:NumFac
        if (Uni_Traj_FPts(i,j))<0.5
            LPts(i,j)=(Uni_Traj_FPts(i,j))+(p/(2*(p-1)));
        else
            LPts(i,j)=(Uni_Traj_FPts(i,j))-(p/(2*(p-1)));
        end
    end
end

FP=Uni_Traj_FPts;
LP=LPts;

radtraj(1:(NumFac+1)*NumTraj,1:NumFac)=NaN;
radtraj(1,:)=FP(1,:);
% for k=1:NumFac
%     FPTemp=FP(k,:);
%     FPTemp(1,k)=LP(1,k);
%     radtraj(k+1,:)=FPTemp;
% end
% radtraj
for k = 1:NumTraj
    radtraj((k-1)*(NumFac+1)+1:k*(NumFac+1),1:NumFac) = RadTrajInt(FP(k,:),LP(k,:));
end
radtraj;

end

