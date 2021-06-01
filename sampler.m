function sampler(varargin)
err=0; SS1=''; err_msg=''; filename='';
if nargin==0
   filename='param.txt';
elseif nargin==6
   facfile=varargin{1};
   SS=varargin{2};
   OvrSamSiz=str2num(varargin{3});
   NumLev=str2num(varargin{4});
   NumTraj=str2num(varargin{5});
   SamFileType=varargin{6};
else 
   err_msg='Six arguments are required: sampler [facfile] [SS] [OvrSamSiz] [NumLev] [NumTraj] [SamFileType]'; err=1;
end

if ~isempty(filename)
  fid = fopen(filename,'r');
  headerlines=0;
  if fid~=-1 
	   for m=1:headerlines
      line = fgetl(fid);
     end

    line = fgetl(fid); if ischar(line); facfile=sscanf(line,'%s'); point_pos=find(facfile=='.'); facfile= facfile(1:point_pos+3);end
    line = fgetl(fid); if ischar(line); auxSS=sscanf(line,'%s'); SS=auxSS(1); end
    line = fgetl(fid); if ischar(line); OvrSamSiz=sscanf(line,'%f');end
    line = fgetl(fid); if ischar(line); NumLev=sscanf(line,'%f');end
    line = fgetl(fid); if ischar(line); NumTraj=sscanf(line,'%f');end
    line = fgetl(fid); if ischar(line); SamFileType=sscanf(line,'%s'); end
%        ; SamFileType=auxSamFileType(1); end
   else

   err_msg='                     param.txt not found'; err=1;
  end
end
if err==0
 switch upper(SS(1))
   case 'O'; SS='OT';
   case 'M'; SS='MOT';
   case 'S'; SS='SU';
   case 'E'; SS='eSU';
   otherwise, err_msg=['Sampling Strategy not valid. Use OT, MOT, SU or eSU']; err=1;
 end
end
% %s\n',facfile,SS,OvrSamSiz,NumLev,NumTraj,SamFileType);
if err==0, Fac_Sampler(facfile,SS,OvrSamSiz,NumLev,NumTraj,SamFileType); 
 else
 fprintf(1,'\t---------------------------- ERROR ------------------------------\n');
 fprintf(1,'\t %s\n', err_msg);
 fprintf(1,'\t-----------------------------------------------------------------\n\n');
end