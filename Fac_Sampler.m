function  [] = Fac_Sampler(facfile,SS,OvrSamSiz,NumLev,NumTraj,SamFileType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Para_Sampler generates parameter samples in unit hyperspace &  %
% then transforms them according to the specified probability             %
% distributions                                                           %
%                                                                         %
% Currently this code is gives four options for parameter generation      %
% method of Optimized Trajectories (OT), Modified Optimized Trajectories  %
%(MOT), Sampling for Uniformity (SU),and Enhanced Sampling for Uniformity %
%(eSU) all of which are essentially sampling strategies for the method of %
% Elementary Effecs/ Morris Method.                                       %
%                                                                         %
% Generated samples can be as excel file or as a text file                %
%                                                                         %
%-------------------------------------------------------------------------%
%                                  Inputs                                 %
%-------------------------------------------------------------------------%
% (1) facfile:      this is '*.fac' file which shall contain following    %
%                   information                                           %
%                   (a) number of parameters (NumFact)                    %
%                   (b) default distribution truncation values            %
%                   (c) distribution type and distribution                %
%                       characteristics for each parameter                %
%     '*.fac' file can be generated from SimLab v2.2 for exact file       %
%             format please refer SimLab v2.2 manual                      %
%                                                                         %
% (2)   SS:         Sampling Strategy                                     %
%                   Currently we provide four options                     %
%                   [OT] Campolongo et al(2007) - Method of Optimized     %
%                   Trajectories                                          %
%                   [MOT] Ruano et al(2012) - Method of Modified Optimized%
%                   Trajectories                                          %
%                   [SU] Khare et al(2014) - Sampling for Uniformity      %
%                   [eSU] Chitale et al (in preparation) - Enhanced SU    %
%                   [RadialeSU] Khare et al (in preparation) - Radial eSU %
%                                                                         %
% (3) OvrSamSize:   Oversampling Size                                     %
%                   For OT and MOT recommended oversampling size is       %
%                   500-1000                                              %
%                   For SU recommended oversampling size is 300           %
%                   For eSU and Radial eSU oversampling is not required   %
%                                                                         %
% (4)NumLev:        Number of parameter levels.                           %
%                   In EE literature various values for number of levels  %
%                   have been suggested. However standard practice is to  %
%                   use even number of levels usually 4, 6 or 8           %
%                   For SU/eSU/RadialeSU NumLev can be from 
%                   {4,6,8,10,12,14,16}.      %
%                                                                         %
% (5) NumTraj:      Number of trajectories to be generated                %
%                   In EE literature recommended value for number of      %
%                   trajectories vary from as little as 2 to as large as  %
%                   100. However, a number of studies have reported that  %
%                   10-20 trajectories are sufficient                     %
%                                                                         %
% (6) SamFileType: User needs to specify the format in which sample file  %
%                  will be written. Currently we offer two formats        %
%                  (1) Excel                                              %
%                  (2) Text (comma separated file with .sam extension)    %
%-------------------------------------------------------------------------%
%                               Outputs                                   %
%-------------------------------------------------------------------------%                
% (1) Factor_Sample : Parameter sample [ncol,nrows]                       %
%               ncol = NumFact                                            %
%               nrows = NumTraj*(NumFact+1)                               %                                 
%               Each column corresponds to a parameter                    %
%                                                                         %
% (2) *_FacSample.xlsx : Factor samples are written to an excel file      %
%                          Each column corresponds to a factor.           %
%                   	   Factor names are specified on the first row    %
%                       OR                                                %
%     *_FacSample.sam: Factor samples are written in a comma separated text
%     file with .sam extension. First rwo specifies parameter names       %
%                                                                         %
% (3) *_FacSamChar.txt: Characteristics used for generating the sample    %
%                     generation are written to a text file               %
%                     (a) Sampling Strategy                               %
%                     (b) Oversampling Size                               %
%                     (c) Number of levels                                %
%                     (d) Number of trajectories                          %
%                     (e) Number of factors                               %
%                                                                         %
%-------------------------------------------------------------------------%
%                              Syntax                                     %
%-------------------------------------------------------------------------%
%                Fac_Sampler(facfile,SS,OvrSamSiz,NumLev,NumTraj)         %
%                                                                         %
% Example:                                                                %                                                      
% To generate Parameter samples based on distribution details specified   %
% in 'Parameter.fac' file using SU strategy with oversampling size 300,   %
% using 4 levels and 10 trajectories with unit hyperspace                 %
% type following in Matlab command window                                 %
%                  Fac_Sampler('Parameter.fac','SU',300,4,10);            %
%                                                                         %
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%                          Distributions                                  %
%-------------------------------------------------------------------------%
% Currently following parameter distributions can be generated using this %
% package. Please refere EE_SamplerMapper tool documentation for detailed %
% notes on limitations of some of these distributions                     %
%(1) Uniform                                                              %                                                        
%(2) LogUniform                                                           %
%(3) Normal                                                               %
%(4) LogNormal                                                            %
%(5) Nominal                                                              %
%(6) Non-uniform Discrete (NUDiscrete)                                    %
%(7) Uniform Discrete (UDiscrete)                                         %
%(8) Constant                                                             %
%(9) Triangular                                                           %
%(10) Weibull                                                             %
%(11) Beta                                                                %
%(12) Gamma                                                               %
%(13) Exponential                                                         %
%(14) Log10Uniform                                                        %
%                                                                         %
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
% This package is developed by Y.P. Khare. This package is essentially a  %
% collection of individual codes developed by various authors, details of %
% which are given below                                                   %
% OT trajectory generation - Joint Research Center EU                     %
% (http://ipsc.jrc.ec.europa.eu/index.php?id=756)                         %
% MOT trajectory generation - Ruano et al. (2012) obtained by personal    %
% communication                                                           %
% SU trajectory generation - Khare et al. (2015) University of Florida    %
% Trajectory Mapper - modified from Ismael ..... and Dr. Robert Rooney    %
% (University of Florida)....... (personal communication)                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Follwoing part of the code reades the factor file (*.fac) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[NUMCATV,NMAXCAT] = ReadFacDist(facfile);% Read fac file to collect information about presence of categorical factors

InputFile = (facfile);
%str = ['Split ^this string into ^several pieces'];
LIFN = length(InputFile);
ModNam = InputFile(1:LIFN-4);

% %ModNam = strsplit(InputFile,'.');
fid3 = fopen(InputFile,'r');
DefTruncTitle = fscanf(fid3, '%s         %s' , 2);% reads Misc text
DefTruncLB = fscanf (fid3,'%f',1); %default truncaton Lower Bound
DefTruncUB = fscanf (fid3,'%f',1); %default truncaton Upp Bound
NumFact = fscanf (fid3,'%f',1);%number of factors in file
miscText= fscanf(fid3, '%s' , 1); 
Para_Sam(1:1+NumTraj*(1+NumFact),1:NumFact)=NaN;

if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)&&(((strcmp(SS,'SU')==1)+(strcmp(SS,'eSU')==1)+(strcmp(SS,'RadialeSU')==1)==1))
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
            % Check if NumTraj is a multiple of NumLev, if not then increase the NumTraj that
            if rem(NumTraj,NumLev)~=0
                Rem = 1;
                while (Rem~=0)
                    NumTraj = NumTraj+1;
                    Rem = rem(NumTraj,NumLev);
                end
                fprintf('\n SU/eSU/RadialeSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
            end
else
    if (rem(NumTraj,NumLev)~=0)&&(((strcmp(SS,'SU')==1)+(strcmp(SS,'eSU')==1)+(strcmp(SS,'RadialeSU')==1)==1)) % Check if NumTraj is a multiple of NumLev, if not then increase the NumTraj that
        Rem = 1;
        while (Rem~=0)
            NumTraj = NumTraj+1;
            Rem = rem(NumTraj,NumLev);
        end
        fprintf('\n SU/eSU/RadialeSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
    end
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part of the code generates trajectories based on 
% the sampling strategy 'SS' defined by the user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Unit Hyperspace Sample Generation for OT
if (strcmp(SS,'OT') == 1) && (NUMCATV == 0)
    if (OvrSamSiz >= 500) && (OvrSamSiz < NumTraj)   
        fprintf('\n For the method of OT oversampling size can not be less than number of trajectories\n');
        fprintf('\n Increasing oversampling size to %d\n', NumTraj);
        OvrSamSiz = NumTraj;
    end      
    if (OvrSamSiz < 500) && (OvrSamSiz >= NumTraj)
        fprintf('\n-----------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Campolongo et al. (2007) recommend oversampling size \n');
        fprintf('                 in the range of 500 - 1000\n');
        fprintf('                 Consider increasing oversampling size to match recommendation');
        fprintf('\n-----------------------------------------------------------------------------\n\n');
        prompt = '\n Increase oversampling size, ''Y'' or ''N'' (including quotation marks): ';
        YON = input(prompt);
        if (YON == 'y')||(YON == 'Y')
        prompt = '\n Enter new oversampling size in the range of 500 - 1000: ';
        OSZ = input (prompt);
        if (OSZ < 500)
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        else
            OvrSamSiz = OSZ;
        end
        end
        if (YON == 'n')||(YON == 'N')
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        end 
    end
    if (OvrSamSiz < 500) && (OvrSamSiz < NumTraj)
        fprintf('\n----------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Campolongo et al. (2007) recommend oversampling size \n');
        fprintf('                 in the range of 500 - 1000\n');
        fprintf('                 Also, for OT oversampling size can not be less than number of trajectories\n');
        fprintf('                 Consider increasing oversampling size to at least %d',max(500,NumTraj));
        fprintf('\n-----------------------------------------------------------------------------------------\n\n');
        prompt = '\n Increase oversampling size, ''Y'' or ''N'' (including quotation marks): ';
        YON = input(prompt);
        if (YON == 'y')||(YON == 'Y')
        prompt = '\n Enter new oversampling size in the range of 500 - 1000: ';
        OSZ = input (prompt);
        if (OSZ < 500) || (OSZ < NumTraj)
            fprintf('\n Increasing oversampling size to number of trajectories\n');
            OvrSamSiz = NumTraj;
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        else
            OvrSamSiz = OSZ;
        end
        end
        if (YON == 'n')||(YON == 'N')
            fprintf('\n Increasing oversampling size to number of trajectories\n');
            OvrSamSiz = NumTraj;
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        end
    end
    cd Campolongo;
    tic;
    fprintf('\n Program has started generating samples in unit hyperspace using method of OT ...\n\n');
    [OptimizedTraj,vec] = Optimized_Groups(NumFact,OvrSamSiz,NumLev,NumTraj,eye(NumFact,NumFact),0);
    cd .. 
    Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
    GS = 1;
end
if (strcmp(SS,'OT') == 1) && (OvrSamSiz < 500) && (NUMCATV ~= 0)
    fprintf('\n*************************************************************************\n');
    fprintf(' ERROR: You have %d categorical factors with multiple (> 2) categories',NUMCATV);
    fprintf('\n        Method of OT does not handle this type of distributions');
    fprintf('\n*************************************************************************\n\n');
    fprintf('\n--------------------------------------------------------------------------\n');
    fprintf(' RECOMMENDATION: Consider SU/eSU(preferred)/RadialeSU for sample generations');
    fprintf('\n--------------------------------------------------------------------------\n\n');
    GS = 0;
end    
if (strcmp(SS,'OT') == 1) && (OvrSamSiz >= 500) && (NUMCATV ~= 0)
    fprintf('\n*************************************************************************\n');
    fprintf(' ERROR: You have %d categorical factors with multiple (> 2) categories',NUMCATV);
    fprintf('\n        Method of OT does not handle this type of distributions');
    fprintf('\n*************************************************************************\n\n');
    fprintf('\n--------------------------------------------------------------------------\n');
    fprintf(' RECOMMENDATION: Consider SU/eSU(preferred)/RadialeSU for sample generations');
    fprintf('\n--------------------------------------------------------------------------\n\n');
    GS = 0;
end

%% Unit Hyperspace Sample Generation for MOT
if (strcmp(SS,'MOT') == 1) && (NUMCATV == 0)
    if (OvrSamSiz >= 500) && (OvrSamSiz < NumTraj)   
        fprintf('\n For the method of MOT oversampling size can not be less than number of trajectories\n');
        fprintf('\n Increasing oversampling size to %d\n', NumTraj);
        OvrSamSiz = NumTraj;
    end      
    if (OvrSamSiz < 500) && (OvrSamSiz >= NumTraj)
        fprintf('\n-----------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Ruano et al. (2012) recommend oversampling size \n');
        fprintf('                 in the range of 500 - 1000\n');
        fprintf('                 Consider increasing oversampling size to match recommendation');
        fprintf('\n-----------------------------------------------------------------------------\n\n');
        prompt = '\n Increase oversampling size, ''Y'' or ''N'' (including quotation marks): ';
        YON = input(prompt);
        if (YON == 'y')||(YON == 'Y')
        prompt = '\n Enter new oversampling size in the range of 500 - 1000: ';
        OSZ = input (prompt);
        if (OSZ < 500)
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        else
            OvrSamSiz = OSZ;
        end
        end
        if (YON == 'n')||(YON == 'N')
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        end 
    end
    if (OvrSamSiz < 500) && (OvrSamSiz < NumTraj)
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Ruano et al. (2012) recommend oversampling size \n');
        fprintf('                 in the range of 500 - 1000\n');
        fprintf('                 Also, for OT oversampling size can not be less than number of Trajectories\n');
        fprintf('                 Consider increasing oversampling size to at least %d',max(500,NumTraj));
        fprintf('\n---------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Increase oversampling size, ''Y'' or ''N'' (including quotation marks): ';
        YON = input(prompt);
        if (YON == 'y')||(YON == 'Y')
        prompt = '\n Enter new oversampling size in the range of 500 - 1000: ';
        OSZ = input (prompt);
        if (OSZ < 500) || (OSZ < NumTraj)
            fprintf('\n Increasing oversampling size to number of trajectories\n');
            OvrSamSiz = NumTraj;
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        else
            OvrSamSiz = OSZ;
        end
        end
        if (YON == 'n')||(YON == 'N')
            fprintf('\n Increasing oversampling size to number of trajectories\n');
            OvrSamSiz = NumTraj;
            fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
            fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
            fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
        end
    end
    cd Ruano;
    tic;
    fprintf('\n Program has started generating samples in unit hyperspace using method of MOT...\n\n');
    [OptimizedTraj] = MorrisOptimizedTrajectories(OvrSamSiz,NumFact,NumLev,NumTraj);
    cd ..
    Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
    GS = 1;
end
if (strcmp(SS,'MOT') == 1) && (OvrSamSiz < 500) && (NUMCATV ~= 0)
    fprintf('\n*************************************************************************\n');
    fprintf('ERROR: You have %d categorical factors with multiple (> 2) categories',NUMCATV);
    fprintf('\n        Method of OT does not handle this type of distributions');
    fprintf('\n*************************************************************************\n\n');
    fprintf('\n--------------------------------------------------------------------------\n');
    fprintf('RECOMMENDATION: Consider SU/eSU(preferred)/RadialeSU for sample generations');
    fprintf('\n--------------------------------------------------------------------------\n\n');
    GS = 0;
end    
if (strcmp(SS,'MOT') == 1) && (OvrSamSiz >= 500) && (NUMCATV ~= 0)
    fprintf('\n*************************************************************************\n');
    fprintf('ERROR: You have %d categorical factors with multiple (> 2) categories',NUMCATV);
    fprintf('\n        Method of OT does not handle this type of distributions');
    fprintf('\n*************************************************************************\n\n');
    fprintf('\n--------------------------------------------------------------------------\n');
    fprintf('RECOMMENDATION: Consider SU/eSU(preferred)/RadialeSU for sample generations');
    fprintf('\n--------------------------------------------------------------------------\n\n');
    GS = 0;
end
if ((strcmp(SS,'eSU')==1)||(strcmp(SS,'SU')==1)||(strcmp(SS,'RadialeSU') == 1))&& (mod(NumTraj,NumLev)==0)
%% Radial Sampling
if (strcmp(SS,'RadialeSU') == 1)&& (NUMCATV ~= 0) && (NMAXCAT > NumTraj)
    fprintf('\n MSG: You have %d categorical factors with multiple (> 2) categories \n',NUMCATV);
    % We need to ask to increase number of traj in this case
    while NMAXCAT > NumTraj
    fprintf('\n-------------------------------------------------------------------------------\n');
    fprintf(' RECOMENDATION: To get optimal sample with SU for categorical factors \n');
    fprintf('                it is recommended to increase number of trajectories to %d\n',  NMAXCAT);
    fprintf('                Ideally 2-4 times %d',NMAXCAT);
    fprintf('\n-------------------------------------------------------------------------------\n\n');
    prompt = '\n Enter number of trajectories: ';
    NumTraj = input (prompt);
    end
    fprintf('\n Program has started generating samples in unit hyperspace using method of RadialeSU...\n\n');
    tic;
    cd Radial_Khare;
    [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
    cd ..
    toc;
    GS = 1;
else
    if (strcmp(SS,'RadialeSU') == 1)
        fprintf('\n Program has started generating samples in unit hyperspace using method of RadialeSU...\n\n');
    tic;
    cd Radial_Khare;
    [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
    cd ..    
    GS = 1;        
    end
    
end
%% Unit Hyperspace Sample Generation for SU
if (strcmp(SS,'SU') == 1)&& (NUMCATV ~= 0) && (NMAXCAT <= NumTraj)
    fprintf('\n MSG: You have %d categorical factors with multiple (> 2) categories \n',NUMCATV);
    fprintf('\n      Adjusting NumTraj to considering number of categories for Nominal type factors\n');
    NumTraj = NMAXCAT;
    
    % We dont have to ask to increase traj
    if (NumFact < 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 300)
        % Ask to increase over sampling size     
        fprintf('\n======================================\n');
        fprintf(' CAUTION: You have only %d factors ', NumFact);
        fprintf('\n======================================\n\n');
        fprintf('\n----------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: For such low dimensinality, in order to obtain optimal samples\n');
        fprintf('                      use higher sampling size ~ 300 - 1000');
        fprintf('\n----------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Enter new oversampling size in the range of 300 - 1000: ';
            OSZ = input (prompt);
            if OSZ < 300
                fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
                OvrSamSiz = OSZ;
            else
                OvrSamSiz = OSZ;
            end
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end 
    if (NumFact >= 10) && (OvrSamSiz < 300)
        % Ask to reduce over sampling size
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Based on Khare et al. (2015), for SU ideal oversampling size is 300\n');
        fprintf('                 Consider increasing oversampling size');
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        prompt = '\n Increase oversampling size to 300? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 300;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end

        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
end

if (strcmp(SS,'SU') == 1)&& (NUMCATV ~= 0) && (NMAXCAT > NumTraj)
    fprintf('\n MSG: You have %d categorical factors with multiple (> 2) categories \n',NUMCATV);
    % We need to ask to increase number of traj in this case
    while NMAXCAT > NumTraj
    fprintf('\n-------------------------------------------------------------------------------\n');
    fprintf(' RECOMENDATION: To get optimal sample with SU for categorical factors \n');
    fprintf('                it is recommended to increase number of trajectories to %d\n',  NMAXCAT);
    fprintf('                Ideally 2-4 times %d',NMAXCAT);
    fprintf('\n-------------------------------------------------------------------------------\n\n');
    prompt = '\n Enter number of trajectories: ';
    NumTraj = input (prompt);
    end
    if (NumFact < 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 300)
        % Ask to increase over sampling size     
        fprintf('\n======================================\n');
        fprintf(' CAUTION: You have only %d factors ', NumFact);
        fprintf('\n======================================\n\n');
        fprintf('\n----------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: For such low dimensinality, in order to obtain optimal samples\n');
        fprintf('                      use higher sampling size ~ 300 - 1000');
        fprintf('\n----------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Enter new oversampling size in the range of 300 - 1000: ';
            OSZ = input (prompt);
            if OSZ < 300
                fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
                OvrSamSiz = OSZ;
            else
                OvrSamSiz = OSZ;
            end
            
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end 
    if (NumFact >= 10) && (OvrSamSiz < 300)
        % Ask to reduce over sampling size
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Based on Khare et al. (2015), for SU ideal oversampling size is 300\n');
        fprintf('                 Consider increasing oversampling size');
        fprintf('\n---------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Increase oversampling size to 300? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 300;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end   
end

if (strcmp(SS,'SU') == 1)&& (NUMCATV == 0) 
    if (NumFact < 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 300)
        % Ask to increase over sampling size     
        fprintf('\n======================================\n');
        fprintf(' CAUTION: You have only %d factors ', NumFact);
        fprintf('\n======================================\n\n');
        fprintf('\n----------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: For such low dimensinality, in order to obtain optimal samples\n');
        fprintf('                      use higher sampling size ~ 300 - 1000');
        fprintf('\n----------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Enter new oversampling size in the range of 300 - 1000: ';
            OSZ = input (prompt);
            if OSZ < 300
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
                OvrSamSiz = OSZ;
            else
                OvrSamSiz = OSZ;
            end
                           
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz >= 300)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end 
    if (NumFact >= 10) && (OvrSamSiz < 300)
        % Ask to reduce over sampling size
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: Based on Khare et al. (2015), for SU ideal oversampling size is 300\n');
        fprintf('                 Consider increasing oversampling size');
        fprintf('\n---------------------------------------------------------------------------------------------\n');
        prompt = '\n Increase oversampling size to 300? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 300;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for SU/eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n SU/eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of SU ...\n\n');
        tic;
        % Generate sample
        cd Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end   
end


%% Unit Hyperspace Sample Generation for eSU
if (strcmp(SS,'eSU')==1)&&(OvrSamSiz>1)
    fprintf('\n For eSU Oversampling is not necessary. Reducing OvrSamSiz to 1\n');
    OvrSamSiz=1;
end
if (strcmp(SS,'eSU') == 1)&& (NUMCATV ~= 0) && (NMAXCAT <= NumTraj)
    fprintf('\n MSG: You have %d categorical factors with multiple (> 2) categories \n',NUMCATV);
    fprintf('\n      Adjusting NumTraj to considering number of categories for Nominal type factors\n');
    NumTraj = NMAXCAT;
    
    % We dont have to ask to increase traj
     if (NumFact < 10) && (OvrSamSiz >= 100)
        % Change and display if NumLev is not 4, 6, 8, 10, 12, 14 or 16       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 100)
%         % Ask to increase over sampling size     
%         fprintf('\n======================================\n');
%         fprintf(' CAUTION: You have only %d factors ', NumFact);
%         fprintf('\n======================================\n');
%         fprintf('\n-----------------------------------------------------------------------------------------\n');
%         fprintf(' RECOMMENDATION: For such low dimensinality, in order to obtain optimal samples \n');
%         fprintf('                 use higher sampling size ~ 100 - 1000');
%         fprintf('\n-----------------------------------------------------------------------------------------\n');
%         prompt = '\n Enter new oversampling size in the range of 100 - 1000: ';
%             OSZ = input (prompt);
%             if OSZ < 100
%                 fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
%                 fprintf('WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
%                 fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
%                 OvrSamSiz = OSZ;
%             else
%                 OvrSamSiz = OSZ;
%             end
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz == 1)
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end 
    if (NumFact >= 10) && (OvrSamSiz > 1)
        % Ask to reduce over sampling size
        fprintf('\n----------------------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: As per Khare et al. () [manuscript in preparation] oversampling \n');
        fprintf('                 is not necessary for eSU when number of factors are 10 or more\n');
        fprintf('                 Consider reducing oversampling size to 1 in order to reduce sample generation time');
        fprintf('\n-----------------------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Reduce oversampling size to 1? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 1;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING LARGER OVERSAMPLING SIZE, SAMPLING GENERATION MAY TAKE LONG TIME');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
end

if (strcmp(SS,'eSU') == 1)&& (NUMCATV ~= 0) && (NMAXCAT > NumTraj)
    fprintf('\n MSG: You have %d categorical factors with multiple (> 2) categories \n',NUMCATV);
    % We need to ask to increase number of traj in this case
    while NMAXCAT > NumTraj
    fprintf('\n--------------------------------------------------------------------------------------------\n');
    fprintf(' RECOMENDATION: To get optimal sample with eSU for categorical factors it is recommended \n');
    fprintf('                    to increase number of trajectories to %d,  (ideally 2-4 times %d)',NMAXCAT,NMAXCAT);
    fprintf('\n--------------------------------------------------------------------------------------------\n\n');
    prompt = '\n Enter number of trajectories: ';
    NumTraj = input (prompt);
    end
    if (NumFact < 10) && (OvrSamSiz >= 100)
        fprinntf('\n For eSU oversampling is not required. Reducing OvrSamSiz to 1.\n');
        OvrSamSiz = 1;
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 100)
%         if OvrSamSiz>1
%             fprintf('\n For eSU oversampling is not required. Reducing OvrSamSiz to 1\n');
%             OvrSamSiz = 1;
%         end
%         Ask to increase over sampling size     
%         fprintf('\n======================================\n');
%         fprintf(' CAUTION: You have only %d factors ', NumFact);
%         fprintf('\n======================================\n\n');
%         fprintf('\n---------------------------------------------------------------------------------------------\n');
%         fprintf(' RECOMMENDATION: For such low dimensinality use higher sampling size ~ 100 - 1000');
%         fprintf('\n----------------------------------------------------------------------------------------------\n\n');
%         prompt = '\n Enter new oversampling size in the range of 100 - 1000: ';
%             OSZ = input (prompt);
%             if OSZ < 100
%                 fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
%                 fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
%                 fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
%                 OvrSamSiz = OSZ;
%             else
%                 OvrSamSiz = OSZ;
%             end

        
% Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end    
    if (NumFact >= 10) && (OvrSamSiz == 1)
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz > 1)
        % Ask to reduce over sampling size
        fprintf('\n For eSU oversampling is not necessary. Reducing OvrSamSiz to 1\n');
        OvrSamSiz = 1;
        fprintf('\n----------------------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: As per Khare et al. () [manuscript in preparation] oversampling \n');
        fprintf('                 is not necessary for eSU when number of factors are 10 or more\n');
        fprintf('                 Consider reducing oversampling size to 1 in order to reduce sample generation time');
        fprintf('\n-----------------------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Reduce oversampling size to 1? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 1;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING LARGER OVERSAMPLING SIZE, SAMPLING GENERATION MAY TAKE LONG TIME');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
end

if (strcmp(SS,'eSU') == 1)&& (NUMCATV == 0) 
    if (NumFact < 10) && (OvrSamSiz >= 100)
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact < 10) && (OvrSamSiz < 100)
        % Ask to increase over sampling size     
%         fprintf('\n======================================\n');
%         fprintf(' CAUTION: You have only %d factors ', NumFact);
%         fprintf('\n======================================\n\n');
%         fprintf('\n---------------------------------------------------------------------------------------------\n');
%         fprintf(' RECOMMENDATION: For such low dimensinality use higher sampling size ~ 100 - 1000');
%         fprintf('\n----------------------------------------------------------------------------------------------\n\n');
%         prompt = '\n Enter new oversampling size in the range of 100 - 1000: ';
%             OSZ = input (prompt);
%             if OSZ < 100
%                 fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
%                 fprintf(' WARNING: YOU ARE USING SMALLER OVERSAMPLING SIZE, GENERATED SAMPLES MAY NOT BE OPTIMAL');
%                 fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
%                 OvrSamSiz = OSZ;
%             else
%                 OvrSamSiz = OSZ;
%             end
        if OvrSamSiz > 1
            fprintf('eSU does not need oversampling. Reducing OvrSamSiz to 1\n');
            OvrSamSiz = 1;
        end
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end    
    if (NumFact >= 10) && (OvrSamSiz == 1)
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
    if (NumFact >= 10) && (OvrSamSiz > 1)
        % Ask to reduce over sampling size
        fprintf('\n----------------------------------------------------------------------------------------------------------\n');
        fprintf(' RECOMMENDATION: As per Khare et al. () [manuscript in preparation] oversampling \n');
        fprintf('                 is not necessary for eSU when number of factors are 10 or more\n');
        fprintf('                 Consider reducing oversampling size to 1 in order to reduce sample generation time');
        fprintf('\n-----------------------------------------------------------------------------------------------------------\n\n');
        prompt = '\n Reduce oversampling size to 1? ''Y''/''N'' (including quotation marks): ';
        OSZC = input(prompt);
            if (OSZC == 'Y')||(OSZC == 'y')
            OvrSamSiz = 1;
            end
            if (OSZC == 'N')||(OSZC == 'n')
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
                fprintf(' WARNING: YOU ARE USING LARGER OVERSAMPLING SIZE, SAMPLING GENERATION MAY TAKE LONG TIME');
                fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
            end
        % Change and display if NumLev is not 4       
        if (NumLev ~= 4)&&(NumLev ~= 6)&&(NumLev ~= 8)&&(NumLev ~= 10)&&(NumLev ~= 12)&&(NumLev ~= 14)&&(NumLev ~= 16)
            fprintf('\n Default Grid Size for eSU method is 4\n'); 
            NumLev = 4;
        end
        % Check if NumTraj is a multiple of NumLev, if not then increase
        % the NumTraj
        % that
        if rem(NumTraj,NumLev)~=0
            Rem = 1;
            while (Rem~=0)
                NumTraj = NumTraj+1;
                Rem = rem(NumTraj,NumLev);
            end
            fprintf('\n eSU needs NumTraj to be a multiple of NumLev, increased NumTraj to %d\n',NumTraj);
        end
        fprintf('\n Program has started generating samples in unit hyperspace using method of eSU ...\n\n');
        tic;
        % Generate sample
        cd Enhanced_Khare;
        [OptimizedTraj,HypDist,timereq] = SU_Sampling(NumFact,OvrSamSiz,NumTraj,NumLev);
        cd ..
        Factor_Sample(1:NumTraj*(NumFact+1),1:NumFact) = NaN;
        GS = 1;
    end
end

elseif((strcmp(SS,'eSU')==1)||(strcmp(SS,'SU')==1)||(strcmp(SS,'RadialeSU') == 1))&& (mod(NumTraj,NumLev)~=0)
    fprintf('\n NumTraj need to be in multiples of NumLev to obtain perfectly uniform samples.\n');
    fprintf('Please revise NumTraj\n');
elseif(((strcmp(SS,'OT') == 1)+strcmp(SS,'MOT')==1)==1) && (OvrSamSiz >= 500) && (NUMCATV == 0)
    fprintf('\n Since OT/MOT was used, generated samples may not be uniform.\n');
elseif(((strcmp(SS,'OT') == 1)+strcmp(SS,'MOT')==1)==1) && (OvrSamSiz < 500) && (NUMCATV == 0)
     fprintf('\n Since OT/MOT was used with OvrSamSiz, generated samples may not be optimal and uniform.\n');
else
    if (((strcmp(SS,'OT') == 1)+strcmp(SS,'MOT')==1)==1) && (NUMCATV ~= 0)
     fprintf('\n Sample was not generated\n');
    end
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                       
% the following goes factor by factor and performas the following steps   %
%       1: identify the type of distribution (if statements)              %
%       2: read the relavant distribution parameters from fac file        %
%       3: using a function, map the uniform distribution pecentiles      %
%       (sam trajectory values) for identified factor to the factors      %
%       distribution.  This is accomplished using the cdf of the          %
%       distribution or the inverse of the dist.                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if GS == 1
    fprintf('\n Samples are being transformed to respective distributions ...\n\n');    
for i=1:NumFact
    DistType = fscanf(fid3,'%s\n',1); % from fac file used for identification
    FacNames{i} = strcat(fgets(fid3));
    fl = fgets(fid3);
        
%----------------the following are the mapping algorithms-----------------%   

%-----------------------UNIFORM DISTRIBUTION------------------------------%
% Collect user specified distribution parameters (number of intervals, lower 
% and upper bound values for each interval, and weight associated with each interval) 
% for the uniform distribution from the *.fac file
    if strcmp(DistType,'Uniform') == 1
        fscanf (fid3,'%f',1);     
        NumIntervals = fscanf (fid3,'%f',1); % number of intervals
        for iii=1:NumIntervals;
            IntLB(iii,1) = fscanf(fid3,'%f',1); % Lower bound of interval iii
            IntUB(iii,1) = fscanf(fid3,'%f',1); % Upper Bound of interval iii
            Weight(iii,1) = fscanf(fid3,'%f',1); % weighting factor interval iii
        end
        [modFacSamples] = Uniform(OptimizedTraj(:,i),IntLB,IntUB,...
               Weight,NumIntervals);
           clear IntLB
           clear IntUB
           clear Weight
    end
       
%------------------------NORMAL DISTRIBUTION------------------------------% 
% Collect user specified distribution parameters (mean, stadard deviation, 
% lower and upper truncation values) for the normal distribution from the 
% *.fac file
    if strcmp(DistType,'Normal') == 1 
        fscanf (fid3,'%f',1);     
        mu = fscanf (fid3,'%f',1); % mean
        sig = fscanf(fid3,'%f',1); % standard deviation
        a = fscanf(fid3,'%f',1); % lower truncation (probability)
        b = fscanf(fid3,'%f',1); % upper truncation (probability)
               
        itempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempFacSamples = b+(a-b)*(1-itempFacSamples); % scaling the probabilities
        modFacSamples = norminv(tempFacSamples,mu,sig); % map probabilities to cdf to get values consistant with distribution values
    end
        
%-----------------------LOGNORMAL DISTRIBUTION----------------------------%
% Collect user specified distribution parameters distribution parameters
% (mean, stadard deviation, lower and upper truncation values) for the 
% lognormal distribution from the *.fac file
    if strcmp(DistType,'LogNormal') == 1
        fscanf (fid3,'%f',1);     
        mu = fscanf (fid3,'%f',1); % mean
        sig = fscanf(fid3,'%f',1); % standard deviation
        a = fscanf(fid3,'%f',1); % lower truncation
        b = fscanf(fid3,'%f',1); % upper truncation
                
        itempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempFacSamples = b+(a-b)*(1-itempFacSamples); % scaling the probabilities
        modFacSamples = logninv(tempFacSamples,mu,sig); % map probabilities to cdf to get values consistant with distribution values
    end
        
%-----------------------EXPONENTIAL DISTRIBUTION--------------------------% 
% Collect user specified distribution parameters distribution parameters
% (shape, shift and right hand side truncation values) for the 
% exponential distribution from the *.fac file
    if strcmp(DistType,'Exponential')
        fscanf (fid3,'%f',1);     
        Lambda = fscanf (fid3,'%f',1); % shape factor (1/Lamda = mean of exp distri)
        b = fscanf(fid3,'%f',1); % location (Shift by b)
        a = fscanf(fid3,'%f',1); % r.h.s. truncation
            
        itempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempFacSamples = -(1/Lambda)*log(1-itempFacSamples*a); %scaling the probabilities
        modFacSamples = tempFacSamples+b; % shift by b
     end
        
%-------------------------WEIBULLL DISTRIBUTION---------------------------%   
% Collect user specified distribution parameters distribution parameters
% (shape, scale, shift and right hand side truncation values) for the 
% weibull distribution from the *.fac file
    if strcmp(DistType,'Weibull')
        fscanf (fid3,'%f',1);     
        beta = fscanf (fid3,'%f',1); % shape parameter
        n = fscanf(fid3,'%f',1); % scale parameter
        b = fscanf(fid3,'%f',1); % location (shift by b)
        RhTruncation = fscanf(fid3,'%f',1); % r.h.s. truncation probability
        RT = n*(-log(1-RhTruncation))^(1/beta);

        itempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempModFacSamples = n*(-log((1-itempFacSamples).*exp(-(0/n)^beta)+itempFacSamples.*exp(-(RT/n)^beta))).^(1/beta); % map probabilities to cdf to get values consistant with distribution values
        modFacSamples = tempModFacSamples+b; % shift by b
    end
         
%---------------------------BETA DISTRIBUTION-----------------------------%        
% Collect user specified distribution parameters distribution parameters
% (shape factors, lower and upper bounds) for the 
% beta distribution from the *.fac file
    if strcmp(DistType,'Beta')
        fscanf (fid3,'%f',1);     
        alpha = fscanf (fid3,'%f',1); % shape parameter >0
        beta = fscanf(fid3,'%f',1); % shape parameter >0
        a = fscanf(fid3,'%f',1); % lower bound of interval
        b = fscanf(fid3,'%f',1); % upperbound of interval
                                  
        tempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempModFacSamples = betainv(tempFacSamples,alpha,beta); % map probabilities to cdf to get values consistant with distribution values
        modFacSamples = tempModFacSamples.*(b-a)+a; % shift by b
    end
         
%---------------------------GAMMA DISTRIBUTION----------------------------%   
% Collect user specified distribution parameters distribution parameters
% (shape, scale,shift factors and r.h.s truncation) for the 
% gamma distribution from the *.fac file
    if strcmp(DistType,'Gamma')
        fscanf (fid3,'%f',1);     
        r = fscanf (fid3,'%f',1); % shape parameter
        lambda = fscanf(fid3,'%f',1); % scale parameter
        B = 1/lambda;
        b = fscanf(fid3,'%f',1); % location (shift by b)
        RT = fscanf(fid3,'%f',1); %r.h.s. truncation probability
                      
        tempFacSamples = OptimizedTraj(:,i); % collect sample data
        tempModFacSamples = gaminv(tempFacSamples*RT,r,B); % map probabilities to cdf to get values consistant with distribution values
        modFacSamples = tempModFacSamples+b; % shift by b
    end
    
%------------------------CONSTANT DISTRIBUTION----------------------------%    
% Collect user specified distribution parameters distribution parameters
% (shape factor) for the constant distribution from the *.fac file
    if strcmp(DistType,'Constant') == 1
        fscanf (fid3,'%f',1);     
        C = fscanf (fid3,'%f',1); % shape parameter 
        
        tempFacSamples = OptimizedTraj(:,i); % collect sample data
        modFacSamples(1:size(tempFacSamples),1)= C; % replace all values with constant
    end  

%------------------------TRIANGULAR DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (min, peak, max) for the 
% constant distribution from the *.fac file
    if strcmp(DistType,'Triangular') == 1
        fscanf (fid3,'%f',1);
        a = fscanf(fid3,'%f',1);  %imin
        c = fscanf(fid3,'%f',1);  %ipeak
        b = fscanf(fid3,'%f',1);  %imax
        LT = DefTruncLB;
        RT = DefTruncUB;
       
        [modFacSamples] = Triangular(OptimizedTraj(:,i),a,b,c,LT,RT);
    end
       
%------------------------LOGUNIFORM DISTRIBUTION--------------------------% 
% Collect user specified distribution parameters distribution parameters
% (lower bound, upper bound, weighing factor) for the 
% loguniform distribution from the *.fac file
    if strcmp(DistType,'LogUniform') == 1
        fscanf (fid3,'%f',1);     
        NumIntervals = fscanf (fid3,'%f',1); % number of intervals
        for iii=1:NumIntervals
            IntLB(iii,1) = fscanf(fid3,'%f',1); % Lower bound interval iii
            IntUB(iii,1) = fscanf(fid3,'%f',1); % Upper Bound Interval iii
            Weight(iii,1) = fscanf(fid3,'%f',1);% weighting factor interval iii
        end
        [modFacSamples] = LogUniform(OptimizedTraj(:,i),...
                IntLB,IntUB,Weight, NumIntervals);
            clear IntLB;
            clear IntUB;
            clear Weight;
            clear NumIntervals;
    end
    
%------------------------LOG10UNIFORM DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (lower bound, upper bound, weighing factor) for the 
% loguniform distribution from the *.fac file
    if strcmp(DistType,'Log10Uniform') == 1
        fscanf (fid3,'%f',1);     
        NumIntervals = fscanf (fid3,'%f',1); % number of intervals
        for iii=1:NumIntervals
            IntLB(iii,1) = fscanf(fid3,'%f',1); % Lower bound interval iii
            IntUB(iii,1) = fscanf(fid3,'%f',1); % Upper Bound Interval iii
            Weight(iii,1) = fscanf(fid3,'%f',1);% weighting factor interval iii
        end
        [modFacSamples] = LogUniform(OptimizedTraj(:,i),...
            IntLB,IntUB,Weight, NumIntervals);
        clear IntLB;
        clear IntUB;
        clear Weight;
        clear NumIntervals;
    end

%--------------------------NOMINAL DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding weights) for the 
% discrete distribution from the *.fac file
    
    if strcmp(DistType,'Nominal') == 1
        fscanf (fid3,'%f',1); 
        numElements = fscanf (fid3,'%f',1); %Number of values in distribution
        
        if (numElements > 2) && ((strcmp(SS,'SU')+strcmp(SS,'eSU')+strcmp(SS,'RadialeSU')) == 1)
            [modFacSamples,SNT] = CATEGORICAL(numElements,NumTraj,OptimizedTraj(:,i));
            for jj=1:numElements
            element(jj,1) = fscanf(fid3,'%f',1);
            temp(jj,1) = fscanf(fid3,'%f',1);
            Weight(jj,1) = fscanf(fid3,'%f',1);
            end
        end
        if (numElements == 2) && ((strcmp(SS,'SU')+strcmp(SS,'eSU')+strcmp(SS,'RadialeSU')) == 1)
            for j=1:numElements
            element(j,1) = fscanf(fid3,'%f',1);
            temp(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = 0.5;
            end
            [modFacSamples] = Discrete(OptimizedTraj(:,i),numElements,...
                element,Weight);            
        end
        if (numElements == 2) && ((strcmp(SS,'SU')+strcmp(SS,'eSU')+strcmp(SS,'RadialeSU')) ~= 1)
            for j=1:numElements
            element(j,1) = fscanf(fid3,'%f',1);
            temp(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = 0.5;
            end
            [modFacSamples] = Discrete(OptimizedTraj(:,i),numElements,...
                element,Weight);  
        end
    end
    
%--------------------------Non-UNIFORM DISCRETE DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding non-uniform weights) for the 
% discrete distribution from the *.fac file
    if strcmp(DistType,'NUDiscrete') == 1
        tempFlag = fscanf (fid3,'%f',1); 
        numElements = fscanf (fid3,'%f',1);  %Number of values in distribution
        
        for j=1:numElements
            element(j,1) = fscanf(fid3,'%f',1);
            temp(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = fscanf(fid3,'%f',1);
        end
        [modFacSamples] = Discrete(OptimizedTraj(:,i),numElements,...
                element,Weight);
    end
    
%--------------------------------UNIFORM DISCRETE DISTRIBUTION--------------------------%
% Collect user specified distribution parameters distribution parameters
% (number of discrete values, discrete values and corresponding non-uniform weights) for the 
% discrete distribution from the *.fac file
    if strcmp(DistType,'UDiscrete') == 1
        tempFlag = fscanf (fid3,'%f',1); 
        numElements = fscanf (fid3,'%f',1);  %Number of values in distribution
        
        for j=1:numElements
            element(j,1) = fscanf(fid3,'%f',1);
            temp(j,1) = fscanf(fid3,'%f',1);
            Weight(j,1) = fscanf(fid3,'%f',1);
        end
        [modFacSamples] = Discrete(OptimizedTraj(:,i),numElements,...
                element,Weight);
    end
    
%%   
%%%%%%%%%%%%%%%%%%%% WRITE MAPPED FACTORS TO MASTER MATRIX %%%%%%%%%%%%%%%%
%put mapped trajectories into new sample matrix.  Same dimensions as OptimizedTraj matr
    Factor_Sample(:,i)=modFacSamples(:);
    clear b
    clear c
    clear tempFacSamples
    clear temp
    clear element
    clear Weight
end

fclose (fid3);

%%%%%%%%%%%%%%%%%%%%%%% PLOT HISTOGRAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creat histograms of generated parameters for visualization purpose
    R=Repeat_Count(Factor_Sample);%Check to find if there is any repetition of sample point
    if R(1,1)>0
    fprintf('\n Caution: %d sample points are repeated i.e. %2.2f percent of the sample is repeated\n',R,R/length(Factor_Sample)*100)
    end
%for kk=1:NumFact
%    figure(kk)
%    hist(Factor_Sample(:,kk),NumLev);
%   title(FacNames{kk});
%end
if (strcmp(SS,'RadialeSUp2')==1)
    Factor_Sample = OptimizedTraj;
end
%%
%%%%%%%%%%%%%%%%%%% WRITING PARAMETER VALUES TO EXCEL FILE%%%%%%%%%%%%%%%%%
fprintf('\n Sample Generation and Transformation Time = %.2f secs\n\n',toc);
fprintf('\n Samples are being written to file ...\n\n');

if strcmp(SamFileType,'Excel')==1
    AA=num2cell(Factor_Sample);
    BB=cellstr(FacNames);
    CC=[BB;AA];
    xfilename = strcat(ModNam,'_FacSample.xlsx');
    xlswrite(xfilename,CC); % User can specify any other file name
end
if strcmp(SamFileType,'Text')==1
    xfilename = strcat(ModNam,'_FacSample.sam');
    FacNames1=FacNameString(FacNames);
    fin=fopen(xfilename,'w');
    if fin ~= -1
        fprintf(fin,'%s\n',FacNames1{1});
        fclose(fin);
    end
    dlmwrite(xfilename,Factor_Sample,'-append'); % User can specify any other file name
end

FacCharFilNam = strcat(ModNam,'_FacSamChar.txt');
fid=fopen(FacCharFilNam,'w');
fprintf(fid,'%s\n',SS);
fprintf(fid,'%d\n',OvrSamSiz);
fprintf(fid,'%d\n',NumLev);
fprintf(fid,'%d\n',NumTraj);
fprintf(fid,'%d\n',NumFact);
fclose(fid);
fprintf('\n Sample file writing is complete\n\n');

end
end

