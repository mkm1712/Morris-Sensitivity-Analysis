function [OUTPUT] = Screen_output_model(Modelfile_path, Validationfile_path, Samplefile_path, Int_time, Steady_time,F_non_input_no,pari)

% Part 1
% Parse out model's name (xls2Netflux needs it)
namepos = strfind(Modelfile_path,'.xls');
if rem (namepos,1)== 0
    namestr = Modelfile_path(1:namepos-1);
    namestr = cellstr(namestr);
else
    disp ('Error: please insert the path for model file with correct extension');
    return
end
%
% Part 2
% generate ODE from model spreadsheet
[specID,reactionIDs,~,paramList,ODElist,~,~] = util.xls2Netflux(namestr,Modelfile_path);
commandLine = util.exportODE(specID,paramList,ODElist); % Model V1 (Automation Validation)
% commandLine = util.exportODE2(specID,paramList,ODElist); %Model V2 (Automation Validation)
util.textwrite('ODEfun.m',commandLine);
%
% Part 3
% set up simulation options
tspan_ss = [0 Steady_time]; % run out to ss
tspan_int = [0 Int_time]; % run out to ss
%
% Part 4
% Read the validation sheet & Identification of each main columns
[~, txt, ~] = xlsread(Validationfile_path);
IncodeColumn = cellfun(@(x)isequal(x,'Input Code'), txt(1,:))';
OutputColumn = cellfun(@(x)isequal(x,'Output'), txt(1,:))';
MeasurementColumn = cellfun(@(x)isequal(x,'Measurement'), txt(1,:))';
IDColumn =  cellfun(@(x)isequal(x,'ID'), txt(1,:))';
%
num = xlsread(Samplefile_path);
Sample_no = size (num,1);
% Part 5
% remove rows without data
noData = cellfun(@(x)isequal(x,'No Data'), txt(1:end, MeasurementColumn));
txt(noData, :) = [];
noData = cellfun(@isempty, txt(1:end, MeasurementColumn));
txt(noData, :) = [];
%
% Part 6
% Having validation inputs in workspace for debugging & Extracting Data from Validation file
assignin('base', 'txt', txt);
validationIDs = txt(2:end, IDColumn);
inputCode = txt(2:end, IncodeColumn);
measurement = txt(2:end,MeasurementColumn);
outputSpec = txt(2:end, OutputColumn);
UninputCode = unique(inputCode);
%
% Part 7
% convert species and rxn names to integer values to map name and reaction
% ID's to numerical integers, allowing the input code to be evaluated
% directly
for k = 1:length(specID)
    if isempty(specID{k})
        disp (['specID ',num2str(k),' missing']);
    else
        eval([specID{k},' = ',num2str(k),';']);
    end
end
for i = 1:length(reactionIDs)
    if isempty(reactionIDs{i})
        disp (['reactionIDs ',num2str(i),' missing']);
    else
        eval([reactionIDs{i},' = ',num2str(i),';']);
    end
end
for j = 1:length(validationIDs)
    if isempty(validationIDs{j})
        disp (['validationIDs ',num2str(j),' missing']);
    else
        eval([validationIDs{j}, ' = ', num2str(j), ';']);
    end
end

%
% Part 8
% Set validation threshold change
thresh1 = 0.001;% threshold, Khalili et al., 2020 set to 0.001 for sensitivity analysis
thresh2 = 1e-3*thresh1;
options = odeset('RelTol',0.1*thresh1,'AbsTol',0.1*thresh2); 
inc = {'Increase'};
dec = {'Decrease'};
noc = {'No Change'};
OUTPUT = zeros (Sample_no, 1);
%
% Part 9
% Define the size of some variable changing in loops and find indices of output species
outputSpeciesIndex = zeros(1, length(measurement));
yStartL = cell(1, length(UninputCode));
yEndL = cell(1, length(UninputCode));
prediction = cell(1, length(inputCode));
predChange = cell(1, length(inputCode));
match = zeros(1, length(measurement));
for k = 1:length(outputSpec)
    [~,outputSpeciesIndex(k)] = ismember(outputSpec{k},specID);
end
%
% Part 10
% loop over all validation simulations read from the excel sheet
for x=((Sample_no/8)*(pari-1)+1):(Sample_no/8)*pari %Run solution x times choosing different values
    if x <=(Sample_no/8)
        counter = 8*x;
        disp (counter);
    end
    numMatching = 0;
    for i = 1:length(UninputCode)
        [w,n,EC50,tau,ymax,y0] = paramList{:}; % reset params\
        % Specify the varying parameter and its domain, default domian for sampling data is (0,1)
        w(F_non_input_no:end)=num(x,:); % Varying W in (0.0,1.0)
%       EC50(F_non_input_no:end)=0.8*num(x,:)+0.1; % Varying EC50 in (0.1,0.9)

        % Initial (control) Simulation
        a= strfind (UninputCode{i},';');
        b= strfind (UninputCode{i},'w(');
        if length(a)> 1.1 && length(b)> 0.1
            eval([UninputCode{i}(1:a(1)), '%', UninputCode{i}(a(1)+1:end)]);
        end
        rpar = [w;n;EC50];
        params = {rpar,tau,ymax,specID};
        [~,y] = ode15s(@ODEfun, tspan_int, y0, options, params);
        yStart = y(end,:)'; % use the "no input" steady state as control
        
        % evaluate validation conditions from excel sheet
        eval(UninputCode{i});
        
        % Main Simulation
        rpar = [w;n;EC50];
        params = {rpar,tau,ymax,specID};
        [~,y] = ode15s(@ODEfun, tspan_ss, y0, options, params);
        yEnd = y(end,:)';
        
        % Determine Change of Species' Activity after Stimulation
        yStartL{i} = yStart;
        yEndL{i} = yEnd;
    end
    % Part 11
    % Determination of activity change in each experiment
    for i=1:length(inputCode)
        idx = find(ismember(UninputCode, inputCode{i}));
        activityChange = real(yEndL{idx}(outputSpeciesIndex(i)))-real(yStartL{idx}(outputSpeciesIndex(i)));
        activityChange_check = abs(((real(yEndL{idx}(outputSpeciesIndex(i)))-real(yStartL{idx}(outputSpeciesIndex(i))))/real(yStartL{idx}(outputSpeciesIndex(i)))));
        
        % Determine type of Changes
        if activityChange > thresh2 && activityChange_check > thresh1 % increase
            prediction{i} = 'Increase';
            predChange{i} = num2str(activityChange);
            if isequal(inc,measurement(i))
                numMatching = numMatching + 1;
                match(i) = 1; %if the simulation matches the experimental validation put a 1 in the vector
            else
                match(i) = 0; %if the simulation does not match put a 0 in the matrix
            end
        elseif activityChange < -thresh2 && activityChange_check > thresh1 % decrease
            prediction{i} = 'Decrease';
            predChange{i} = num2str(activityChange);
            if isequal(dec,measurement(i))
                numMatching = numMatching + 1;
                match(i) = 1;
            else
                match(i) = 0;
            end
        else % no change
            prediction{i} = 'No Change';
            predChange{i} = num2str(activityChange);
            if isequal(noc,measurement(i))
                numMatching = numMatching + 1;
                match(i) = 1;
            else
                match(i) = 0;
            end
        end
        
    end
    %
    % Part 12
    
    OUTPUT(x,1) = numMatching/length(measurement)*100;
    
% Additional outputs other than model validation percent such as variations of signaling nodes
%         [w,n,EC50,tau,ymax,y0] = paramList{:}; % reset params
%         w(F_non_input_no:end)=num(x,:);
% %         EC50(F_non_input_no:end)=0.8*num(x,:)+0.1;
%          rpar = [w;n;EC50];
%          params = {rpar,tau,ymax,specID};
%          [~,y] = ode15s(@ODEfun, tspan_ss, y0, options, params);
%          OUTPUT(x,2) = y(end,1); 
%          OUTPUT(x,3) = y(end,2); 
end