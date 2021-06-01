%%%% Run the code step by step
%Step 1: Creating sampling data
Fac_Sampler ('Toy.fac','SU',300,8,16,'Excel')  % This is from a package developed by Y.P. Khare (2017)
%%
%Step 2: Computing model output for sampling data
Modelfile_path ='C:\Users\ak2jj\Desktop\Morris Sensitivity Analysis\Toy_model.xlsx';
Validationfile_path ='C:\Users\ak2jj\Desktop\Morris Sensitivity Analysis\Toy_model_exp.xlsx';
Samplefile_path = 'C:\Users\ak2jj\Desktop\Morris Sensitivity Analysis\Toy_FacSample.xlsx';
Int_time = 40;
Steady_time = 40;
F_non_input_no = 3;
Sample_No = 80; %Number of sampling data
Output_No = 1; %Number of outputs
out = zeros (Sample_No,Output_No);
parfor pari=1:8
[OUTPUT] = Screen_output_model(Modelfile_path, Validationfile_path, Samplefile_path, Int_time, Steady_time,F_non_input_no,pari);
out = out + real(OUTPUT);
end
xlswrite ('Toy_Mod_Out.xlsx', out, 1,'A2');
R = {'Output1'}; % Specify your outputs name
xlswrite('Toy_Mod_Out.xlsx',R ,1,'A1');
delete ('ODEfun.m');
%%
%Step 3: Plotting Morris index and standard deviation
EE_SenMea_Calc('Toy_FacSample.xlsx','Toy_FacSamChar.txt','Toy_Mod_Out.xlsx'); % This is from a package developed by Y.P. Khare (2017)
