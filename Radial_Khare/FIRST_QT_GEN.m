function [P11] = FIRST_QT_GEN(r)
%Function FIRST_QT_GEN returns trajectories corresponding to
%factor/parameter value 1/8

%Positions (trajectory+first or last point) are selected randomly and uniquelly

P11(1:r/2,1)=zeros;
for i=1:r/2
    P11(i,1)=2*randi(r,1,1);
    if(P11(i,1)==2*r)
        P11(i,1)=P11(i,1);
    else
        P11(i,1)=P11(i,1)+randi([0,1],1,1);
    end
    if i>1
        for j=1:50
            P_=UNICHECK(P11(1:i,1),r);%Function UNICHECK checks the uniquness of the positions
            P11(i,1)=P_;
        end
    end
end
end

