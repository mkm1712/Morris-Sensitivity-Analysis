function [Traj] = TRAJ_GEN(TrajFLP,del,NumFact,p)
%Function TRAJ_GEN generates complete parameter sample from first and last
%points and delta vector
[m,n]=size(TrajFLP);
Traj(1:m+n,1:n)=zeros;
Traj(1,:)=TrajFLP(1,:);
for i=1:(m+n)-1
    Traj(i+1,:)=Traj(i,:);
    for j=1:NumFact
            if del(i,1)==j
                if Traj(i+1,j)<0.5
                    Traj(i+1,j)=Traj(i+1,j)+((p/2)/(p-1));
                else
                    Traj(i+1,j)=Traj(i+1,j)-((p/2)/(p-1));
                end
            end
    end
end
end

