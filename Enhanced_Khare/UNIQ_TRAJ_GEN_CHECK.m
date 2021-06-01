function [Mat,c] = UNIQ_TRAJ_GEN_CHECK(NumFact,r,p)
%Function UNIQ_TRAJ_GEN_CHECK generates first and last points of 'r'
%trajectories using function SAMGEN1. It also provides check for uniqness
%of first and last points. Function returns matrix of first points
%(Mat). 

FacMat(1:r,1:NumFact)=zeros;

%Function p4GEN, P8GEN etc. returns a vector of size r containing values of first
%points of a given factor/parameter 
for i=1:NumFact
    if p==4
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
Mat=FacMat;
c=0;
end

