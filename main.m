%Read readme.m as there are additional things needed which I do not have
%right to redistribute ImageJ &/or plugins, & matlab files
%This file calls all the other files to run program type <main> in command window


%% Clean the workspace and the previous figures

clear all
close all
clc

%% Get a timestamp before starting the processing

%Displays warning
ImageJ_str=('Ensure ImageJ remains open !!!!!!!!');
msgbox(ImageJ_str);
pause(3)

%% Search Paths

% Adds default Java search paths, edit for your OS, Windows instrunctions
% provided on MIJ homepage

%Mac

% javaaddpath '/Applications/MATLAB_R2010a.app/java/mij.jar';% this oneshould be in MATLAB/Java
% 
% % Selects between ImageJ or Fiji on Mac
% javaaddpath '/Applications/Fiji.app/jars/ij.jar'; % this one should be in ImageJ file
% javaaddpath '/Applications/Fiji.app'
% MIJ.start('/Applications/Fiji.app/');

%javaaddpath '/Applications/ImageJ/ImageJ64.app/Contents/Resources/Java/ij.jar';
%MIJ.start('/Applications/ImageJ/');

%Linux
javaaddpath '/home/darryl/java/mij.jar';% this one should be in MATLAB/Java
javaaddpath '/home/darryl/ImageJ/ij.jar';% this one should be in ImageJ
javaaddpath '/home/darryl/ImageJ'

MIJ.start('/home/darryl/ImageJ'); % this should link to folder storing imageJ and plugins


msgbox('Close last instance of ImageJ if this program is being run again!!','Icon','warn');
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));

%% Folder setup

%Define folder where images are stored

msgbox('Please specify image directory');
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
pause(0.5)

pathname = uigetdir('directory for images'); %gets image directory
addpath(pathname);
files = dir(pathname);% Gets file names
files= {files(3:end).name};
files_numb = size(files,2);
f=1:files_numb;

msgbox('Please specify output directory')
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
pause(0.5)
output_path=uigetdir('','Directory to store outputs');
cd (output_path);
mkdir('Background');
mkdir('Smoothing');
mkdir('Analysed');
cd (output_path);

for f=1:files_numb;
   
    
   %Reads file number depending on loop
   
   image = imread(fullfile(files{f}));
   strg=['Image ',num2str(f),' loading.'];
   disp(strg);
   
   image_array{f}=image;
   [~, name_linear{f}, ~] = fileparts(files{f});
   
        
end
clc

prompt = {'How many images are you comparing at each condition/timepoint/repeat: ',};
dlg_title = 'Input for comparisons';
num_lines = 2;
def = {'2'};
compare = inputdlg(prompt,dlg_title,num_lines,def);
comparisons=str2double(compare{1,1});
sets=files_numb/comparisons;

image_array=reshape(image_array,comparisons,sets)';
name_array=reshape(name_linear,comparisons,sets)';



%% Preallocation of large arrays with row and column headings

% Template array for storing of singular images
array_with_headings={sets+1,comparisons+1};
for h=1:comparisons
    array_with_headings{1,h+1}=sprintf('Stain_%d',h);
end
%Template array for ratio heading
[file_names_ratio_roi,file_names_ratio_whole,ratio_array_with_headings]=Ratio_Names(sets,comparisons,name_array);

% Preallocate other rows
background_array=array_with_headings;
smooth_array=array_with_headings;
roi_array=array_with_headings;
normalized_roi_array=array_with_headings;
normalized_whole_array=array_with_headings;
ratio_img_roi_array=ratio_array_with_headings;
ratio_img_whole_array=ratio_array_with_headings;
ratio_img_whole_lim_array=ratio_array_with_headings;
ratio_img_roi_lim_array=ratio_array_with_headings;
log_ratio_img_roi_array=ratio_array_with_headings;
log_ratio_img_whole_array=ratio_array_with_headings;



%=========================================================================
%% Image processing

for stack=1:sets
    
    
    
for c=1:comparisons
     image_stack(:,:,c)=image_array{stack,c};
end

%Functions for row of data:
% calls function for automatic StackReg
[image_stack_reg]=Istack(image_stack);
%calls function to begin background removal
C=0;
while C==0;
cd 'Background'
[image_stack_b]=background(image_stack_reg,name_array,stack);
cd ..
%calls function to smooth image
cd 'Smoothing'
[image_stack_s]=Smooth(image_stack_b,name_array,stack);
cd ..

% view smoothing
msgbox('viewing smoothed images before ratio calculation');
pause(4)
image_stack_view=image_stack_s;
displayIm3d(image_stack_view);
uiwait()

msgbox('If you type N or an invalid response you will be returned to background removal','Icon','warn')
pause(5)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
prompt = {'Please check images before progressing Ratios,Type Y to proceed, Type N to return to background removal  ',};
dlg_title = 'Input for happiness';
num_lines = 2;
def = {'Y'};
user_happy = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(User_happy);
if X==0
    User_happy{1,1}='K';
else
end

switch user_happy{1,1};
    case 'Y'
        C=1;
    case 'N'
        C=0;
       
    otherwise
        h = errordlg('Unknown input please select Y or N, Starting registration again');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        C=0;
        
end
end

%User selcts square ROI
[image_stack_roi]=select_area(image_stack_s);
close all
%calls function to normalize all images in stack 0-1
[image_stack_roi_n,image_stack_w_n]=normalize(image_stack_roi,image_stack_s);
%calls function to do ratio of images
[ratio_img_roi_row,ratio_img_roi_lim_row,ratio_img_whole_lim_row,ratio_img_whole_row]=Ratio_Calc(image_stack_roi_n,image_stack_w_n);
% FRI function outputs
[~,sa]=size(ratio_img_whole_row);

% Log ratios

for T=1:sa
    
    % Logs limited ROI array and creates row array
    ratio1=ratio_img_roi_lim_row{1,T};
    log_ratio_1=log10(ratio1);
    log_ratio_img_roi_row{1,T}=log_ratio_1;
    
    ratio2=ratio_img_whole_lim_row{1,T};
    log_ratio_2=log10(ratio2);
    log_ratio_img_whole_row{1,T}=log_ratio_2;
      
end


%stores intermediate data in a single row each stain is given a column,
for c=1:comparisons
    
     background_row{1,c}=image_stack_b(:,:,c);
     smooth_row{1,c}=image_stack_s(:,:,c);
     roi_row{1,c}=image_stack_roi(:,:,c);
     normalized_roi_row{1,c}=image_stack_roi_n(:,:,c);
     normalized_whole_row{1,c}=image_stack_w_n(:,:,c);
    
end 

%=========================================================================
%This is prepares data from intermediate and final steps with headers for saving to
%.MAT file

nCr = nchoosek(comparisons,2);
nCr=nCr+1;
%Background array
background_array{stack+1,1}=name_array{stack,1};
background_array(stack+1,2:comparisons+1)=background_row;

%Smooth_array
smooth_array{stack+1,1}=name_array{stack,1};
smooth_array(stack+1,2:comparisons+1)=smooth_row;
%ROI_array
roi_array{stack+1,1}=name_array{stack,1};
roi_array(stack+1,2:comparisons+1)=background_row;
%Normalized_roi
normalized_roi_array{stack+1,1}=name_array{stack,1};
normalized_roi_array(stack+1,2:comparisons+1)=normalized_roi_row;
%Normalized_whole

normalized_whole_array{stack+1,1}=name_array{stack,1};
normalized_whole_array(stack+1,2:comparisons+1)=normalized_whole_row;
%Ratio image roi

ratio_img_roi_array{stack+1,1}=name_array{stack,1};
ratio_img_roi_array(stack+1,2:nCr)=ratio_img_roi_row;
%Ratio image whole

ratio_img_whole_array{stack+1,1}=name_array{stack,1};
ratio_img_whole_array(stack+1,2:nCr)=ratio_img_whole_row;
%Ratio image whole with limits applied

ratio_img_whole_lim_array{stack+1,1}=name_array{stack,1};
ratio_img_whole_lim_array(stack+1,2:nCr)=ratio_img_whole_lim_row;
%Ratio image roi with limits applied

ratio_img_roi_lim_array{stack+1,1}=name_array{stack,1};
ratio_img_roi_lim_array(stack+1,2:nCr)=ratio_img_roi_lim_row;
% Log of Limited whole image ratio

log_ratio_img_roi_array{stack+1,1}=name_array{stack,1};
log_ratio_img_roi_array(stack+1,2:nCr)=log_ratio_img_roi_row;
% Log of Limited ROI ratio

log_ratio_img_whole_array{stack+1,1}=name_array{stack,1};
log_ratio_img_whole_array(stack+1,2:nCr)=log_ratio_img_whole_row;


% Clearing variables from row loop as change in size of ROI or image will
%cause dimensions mismatch

clear image ratio1 ratio2 normalized_roi_row  image_stack image_stack_reg;
clear image_stack_b image_stack_s image_stack_roi image_stack_roi_n;
clear image_stack_w_n background_row smooth_row roi_row c T P G;
clear log_ratio_1 log_ratio_2 log_ratio_img_whole_row log_ratio_img_roi_row
clear ratio_img_roi_row ratio_img_roi_lim_row ratio_img_whole_lim_row;
clear ratio_img_whole_row nCr  normalized_whole_row
clear I4 C im image_slice user_happy image_stack_man image_stack_view

end

cd 'Analysed'


clear ImageJ_str T array_with_headings comparisons f files files_numb;
clear sets stack strg image_array ratio_array_with_headings sa sets stack;
clear h names_linear num_lines prompt name_linear compare def dlg_title
load('MyColormaps','mycmap');
% saves variables
save('final_arrays.mat');


[mask]=lim_gui(log_ratio_img_roi_array,file_names_ratio_roi,file_names_ratio_whole,log_ratio_img_whole_array,mycmap);
cd ..

 

