function [modFacSamples] = Triangular(OptimizedTraj,a,b,c,LT,UT)
%This program mapps factor trajectories from U[1:0] to triangular 
%distribution.  requires:   OptimizedTraj(factor coordinates)
%                           a = base point lower bound
%                           b = base point upper bound
%                           c = apex 

        %collect sample data
        tempFacSamples=LT+(UT-LT)*OptimizedTraj; 
        modFacSamples(1:length(OptimizedTraj))=zeros;
        
   for iii=1:length(tempFacSamples);

        p = tempFacSamples(iii);
        if p<(c-a)/(b-a)
            modFacSamples(iii) = a+sqrt(p*(b-a)*(c-a));
        else
            modFacSamples(iii) = b-sqrt((1-p)*(b-a)*(b-c));
        end
    end
end

