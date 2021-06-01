clear all;
clc;
fid = fopen('MAPFT1_24bceqn.fac');
ct=0;
for i=1:14
    fprintf('line %d: ',i)
fl = fgets(fid);
if isempty(fl)
    ct=ct+1;
    fscanf(fid,'\n');
    disp(fl);
end
disp(fl);
end

% fid = fopen('fgets.m');

% tline = fgets(fid)
% while ischar(tline)
%     disp(tline)
%     tline = fgets(fid);
% end
% 
% fclose(fid);