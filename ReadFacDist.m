function [NUMCATV,NMAXCAT] = ReadFacDist(FacFile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% %ModNam = strsplit(InputFile,'.');

fid10 = fopen(FacFile,'r');
fscanf(fid10, '%s         %s' , 2);% reads Misc text
fscanf (fid10,'%f',1); %default truncaton Lower Bound
fscanf (fid10,'%f',1); %default truncaton Upp Bound
NumFact = fscanf (fid10,'%f',1);%number of factors in file
fscanf(fid10, '%s' , 1); 

NUMCATV = 0;
NMAXCAT = 0;
NMAXCAT1 = 0;
NMAXCAT2 = 0;

for i=1:NumFact
    DistType = fscanf(fid10,'%s\n',1); % from fac file used for identification
    strcat(fgets(fid10));
    fl = fgets(fid10);

%-----------------------UNIFORM DISTRIBUTION------------------------------%
% Read user specified distribution parameters (number of intervals, lower 
% and upper bound values for each interval, and weight associated with each interval) 
% for the uniform distribution from the *.fac file
    if strcmp(DistType,'Uniform') == 1
        fscanf (fid10,'%f',1);     
        NumIntervals = fscanf (fid10,'%f',1); % number of intervals
        for iii=1:NumIntervals;
            fscanf(fid10,'%f',1); % Lower bound of interval iii
            fscanf(fid10,'%f',1); % Upper Bound of interval iii
            fscanf(fid10,'%f',1); % weighting factor interval iii
        end
    end
       
%------------------------NORMAL DISTRIBUTION------------------------------% 
% Read user specified distribution parameters (mean, stadard deviation, 
% lower and upper truncation values) for the normal distribution from the 
% *.fac file
    if strcmp(DistType,'Normal') == 1 
        fscanf(fid10,'%f',1);     
        fscanf(fid10,'%f',1); % mean
        fscanf(fid10,'%f',1); % standard deviation
        fscanf(fid10,'%f',1); % lower truncation (probability)
        fscanf(fid10,'%f',1); % upper truncation (probability)
    end
        
%-----------------------LOGNORMAL DISTRIBUTION----------------------------%
% Read user specified distribution parameters distribution parameters
% (mean, stadard deviation, lower and upper truncation values) for the 
% lognormal distribution from the *.fac file
    if strcmp(DistType,'LogNormal') == 1
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % mean
        fscanf(fid10,'%f',1); % standard deviation
        fscanf(fid10,'%f',1); % lower truncation
        fscanf(fid10,'%f',1); % upper truncation
    end
        
%-----------------------EXPONENTIAL DISTRIBUTION--------------------------% 
% Read user specified distribution parameters distribution parameters
% (shape, shift and right hand side truncation values) for the 
% exponential distribution from the *.fac file
    if strcmp(DistType,'Exponential')
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % shape factor (1/Lamda = mean of exp distri)
        fscanf(fid10,'%f',1); % location (Shift by b)
        fscanf(fid10,'%f',1); % r.h.s. truncation
    end
        
%-------------------------WEIBULLL DISTRIBUTION---------------------------%   
% Read user specified distribution parameters distribution parameters
% (shape, scale, shift and right hand side truncation values) for the 
% weibull distribution from the *.fac file
    if strcmp(DistType,'Weibull')
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % shape parameter
        fscanf(fid10,'%f',1); % scale parameter
        fscanf(fid10,'%f',1); % location (shift by b)
        fscanf(fid10,'%f',1); % r.h.s. truncation probability
    end
         
%---------------------------BETA DISTRIBUTION-----------------------------%        
% Read user specified distribution parameters distribution parameters
% (shape factors, lower and upper bounds) for the 
% beta distribution from the *.fac file
    if strcmp(DistType,'Beta')
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % shape parameter >0
        fscanf(fid10,'%f',1); % shape parameter >0
        fscanf(fid10,'%f',1); % lower bound of interval
        fscanf(fid10,'%f',1); % upperbound of interval
    end
         
%---------------------------GAMMA DISTRIBUTION----------------------------%   
% Collect user specified distribution parameters distribution parameters
% (shape, scale,shift factors and r.h.s truncation) for the 
% gamma distribution from the *.fac file
    if strcmp(DistType,'Gamma')
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % shape parameter
        fscanf(fid10,'%f',1); % scale parameter
        %B = 1/lambda;
        fscanf(fid10,'%f',1); % location (shift by b)
        fscanf(fid10,'%f',1); %r.h.s. truncation probability
    end
    
%------------------------CONSTANT DISTRIBUTION----------------------------%    
% Read user specified distribution parameters distribution parameters
% (shape factor) for the constant distribution from the *.fac file
    if strcmp(DistType,'Constant') == 1
        fscanf (fid10,'%f',1);     
        fscanf (fid10,'%f',1); % shape parameter 
    end  

%------------------------TRIANGULAR DISTRIBUTION--------------------------%
% Read user specified distribution parameters distribution parameters
% (min, peak, max) for the 
% constant distribution from the *.fac file
    if strcmp(DistType,'Triangular') == 1
        fscanf (fid10,'%f',1);
        fscanf(fid10,'%f',1);  %imin
        fscanf(fid10,'%f',1);  %ipeak
        fscanf(fid10,'%f',1);  %imax
    end
       
%------------------------LOGUNIFORM DISTRIBUTION--------------------------% 
% Read user specified distribution parameters distribution parameters
% (lower bound, upper bound, weighing factor) for the 
% loguniform distribution from the *.fac file
    if strcmp(DistType,'LogUniform') == 1
        fscanf (fid10,'%f',1);     
        NumIntervals = fscanf (fid10,'%f',1); % number of intervals
        for iii=1:NumIntervals
            fscanf(fid10,'%f',1); % Lower bound interval iii
            fscanf(fid10,'%f',1); % Upper Bound Interval iii
            fscanf(fid10,'%f',1);% weighting factor interval iii
        end
    end
    
%------------------------LOG10UNIFORM DISTRIBUTION--------------------------%
% Read user specified distribution parameters distribution parameters
% (lower bound, upper bound, weighing factor) for the 
% loguniform distribution from the *.fac file
    if strcmp(DistType,'Log10Uniform') == 1
        fscanf (fid10,'%f',1);     
        NumIntervals = fscanf (fid10,'%f',1); % number of intervals
        for iii=1:NumIntervals
            fscanf(fid10,'%f',1); % Lower bound interval iii
            fscanf(fid10,'%f',1); % Upper Bound Interval iii
            fscanf(fid10,'%f',1);% weighting factor interval iii
        end
    end

%--------------------------NOMINAL DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding weights) for the 
% discrete distribution from the *.fac file
    
    if strcmp(DistType,'Nominal') == 1
        fscanf (fid10,'%f',1); 
        numElements = fscanf (fid10,'%f',1); %Number of values in distribution
        
        if (numElements > 2) 
            NUMCATV = NUMCATV+1;
            if NUMCATV == 1
                NMAXCAT1 = nchoosek(numElements,2);
                NMAXCAT2 = NMAXCAT1;
                NMAXCAT = max(NMAXCAT1,NMAXCAT2);
            end
            NMAXCAT1 = nchoosek(numElements,2);
            NMAXCAT2 = NMAXCAT;
            NMAXCAT = max(NMAXCAT1,NMAXCAT2);
                        
            for jj=1:numElements
            fscanf(fid10,'%f',1);
            fscanf(fid10,'%f',1);
            fscanf(fid10,'%f',1);
            end
        else
            for j=1:numElements
            fscanf(fid10,'%f',1);
            fscanf(fid10,'%f',1);
            fscanf(fid10,'%f',1);
            end
        end
    end
	
	%--------------------------Non-UNIFORM DISCRETE DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding non-uniform weights) for the 
% discrete distribution from the *.fac file
    if strcmp(DistType,'NUDiscrete') == 1
        tempFlag = fscanf (fid10,'%f',1); 
        numElements = fscanf (fid10,'%f',1);  %Number of values in distribution
    end
    
%--------------------------------UNIFORM DISCRETE DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding non-uniform weights) for the 
% discrete distribution from the *.fac file
    if strcmp(DistType,'UDiscrete') == 1
        tempFlag = fscanf (fid10,'%f',1); 
        numElements = fscanf (fid10,'%f',1);  %Number of values in distribution

    end
    
end

fclose (fid10);

end

