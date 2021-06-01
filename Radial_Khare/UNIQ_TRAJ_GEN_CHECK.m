function [Mat,ct] = UNIQ_TRAJ_GEN_CHECK(NumFact,r,p)
%Function UNIQ_TRAJ_GEN_CHECK generates first and last points of 'r'
%trajectories using function SAMGEN1. It also provides check for uniqness
%of first and last points. Function returns matrix of first and last points
%(Mat)and flag (ct). 'ct' is set to 1 if the first and last points are
%non-unique

FacMat(1:r,1:NumFact)=NaN;

R=1;

while R>0

%Function SAMGEN1 returns a vector of size 2*r containing values of first
%and last points of a given factor/parameter 
for i=1:NumFact
    if p==2
        PiVals=p2GEN(r);
    elseif p==4
        PiVals=p4GEN(r);
    elseif p==6
        PiVals=p6GEN(r);
    elseif p==8
        PiVals=p8GEN(r);
    elseif p==10
        PiVals=p10GEN(r);
    elseif p==12
        PiVals=p12GEN(r);
    elseif p==14
        PiVals=p14GEN(r);
    else
        PiVals=p16GEN(r);
    end
    FacMat(:,i)=PiVals;
end

% if p==2
%     FacMat=eye(NumFact);
% end
% FP(1,1:NumFact)=zeros;
% ct=0;    
% FacMat=[FP;FacMat];


%Check for uniqueness of first and last points of trajectories
%Function UNI_TRAJ checks the uniquesness of trajectories by comparing first points
%If first points are non-unique means trajectories are non-unique

% for j=1:r
%     FirstPt(j,:)=FacMat(2*j-1,:);
%     a=min(FirstPt(j,:));
%     if a==0
%         %fprintf('\n Error: Type 1\n');
%         ct=1;
%         break;
%     end
%     if j>1
%         [c]=UNI_TRAJ(FirstPt(1:j,:));
%         ct=c;
%     end
%     if ct==1
%         break;
%     end
% end
R=Repeat_Count(FacMat);%Check to find if there is any repetition of sample point
% if R(1,1)>0
%     fprintf('\n Caution: One or more First Trajectory Points are repeated\n');
% end
end
ct=0;
Mat=FacMat;
end

