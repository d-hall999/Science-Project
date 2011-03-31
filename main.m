%Read readme.m as there are additional things needed which I do not have right to distribute ImageJ &/or plugins
%This file calls all the other files to run program type <main> in command window


%% Clean the workspace and the previous figures

tic

clear all
close all
clc


%% Get a timestamp before starting the processing

%Displays warning
ImageJ_str=('Ensure ImageJ remains open !!!!!!!! hit any key to continue.');
disp(ImageJ_str);
pause

%% Search Paths

% Adds default Java search paths, edit for your OS, Windows instrunctions
% provided on MATLAB central

%Linux
javaaddpath '/home/darryl/java/mij.jar';% this one should be in MATLAB/Java
javaaddpath '/home/darryl/ImageJ/ij.jar';% this one should be in ImageJ file
%Mac
%javaaddpath '/Applications/MATLAB_R2010a.app/java/mij.jar';% this one should be in MATLAB/Java

% Selects between ImageJ or Fiji on Mac
%javaaddpath '/Applications/Fiji.app/jars/ij.jar';% this one should be in ImageJ file
%javaaddpath '/Applications/ImageJ/ImageJ64.app/Contents/Resources/Java/ij.jar';% this one should be in ImageJ file

% MIJ.start('dir to ImageJ and Plugins')

% Linux change directory for own computer
MIJ.start('/home/darryl/ImageJ');

 
% Selects between ImageJ or Fiji on Mac
%MIJ.start('/Applications/Fiji.app/');
%MIJ.start('/Applications/ImageJ/plugins/');

%% Folder setup

%Set path
cd '/home/darryl/Documents/20110311_files';%this is just directory were images are stored

mkdir('Background');
mkdir('Smoothing');
mkdir('Analysed');

%Define folder where images are stored
pathname = '512_indiv';
files = dir(pathname);
files = {files(3:end).name};
files_numb = size(files,2);
f=1:files_numb;
cd '512_indiv'

for f=1:files_numb;
   
    
   %Reads file number depending on loop
   
   image = imread(fullfile(files{f}));
   strg=['Image ',num2str(f),' loading.'];
   disp(strg);
   
   image_array{f}=image;
   
        
end
cd ..
comparisons=input('How many images are you comparing at each condition/timepoint/repeat: ');
sets=files_numb/comparisons;
image_array=reshape(image_array,sets,comparisons);
name_array=reshape(files,sets,comparisons);


%% Preallocation of large arrays with row and column headings

% Template array for storing of singular images
array_with_headings={sets+1,comparisons+1};
if comparisons==2
    array_with_headings{1,2}='Stain_1';array_with_headings{1,3}='Stain_2';
elseif comparisons==3
    array_with_headings{1,2}='Stain_1';array_with_headings{1,3}='Stain_2';
    array_with_headings{1,4}='Stain_3';
end    
%Template array for ratio heading

if comparisons==2
    ratio_array_with_headings={sets+1,comparisons};
    ratio_array_with_headings{1,2}='Stain_1/Stain_2';
elseif comparisons==3
    ratio_array_with_headings={sets+1,comparisons+1};
    ratio_array_with_headings{1,2}='Stain_1/Stain_2';
    ratio_array_with_headings{1,3}='Stain_1/Stain_3';
    ratio_array_with_headings{1,4}='Stain_2/Stain_3';
end

% Array for naming ratio prints

file_names_ratio=ratio_array_with_headings;

if comparisons==2
    for P=1:sets;
    G=1;
    file_names_ratio{P+1,G+1}=[name_array{P,G},'/',name_array{P,G+1}];
    end
% file names if 3 stainings to compare
elseif comparisons==3
    for P=1:sets;
     G=1;
            file_names_ratio{P+1,G+1}=[name_array{P,G},'/',name_array{P,G+1}];
            file_names_ratio{P+1,G+2}=[name_array{P,G},'/',name_array{P,G+2}];
            file_names_ratio{P+1,G+3}=[name_array{P,G+1},'/',name_array{P,G+2}];
     
    end
        
end

%=========================================================================
%% Image processing

for stack=1:sets
    
    
    
for c=1:comparisons
     image_stack(:,:,c)=image_array{1,c};
end

%Functions for row of data:
% calls function for automatic StackReg
[image_stack_reg]=Istack(image_stack);
%calls function to begin background removal
[image_stack_b]=background(image_stack_reg,files);
%calls function to smooth image
[image_stack_s]=Smooth(image_stack_b,files);
%User selcts square ROI
[image_stack_roi]=select_area(image_stack_s);
%calls function to normalize all images in stack 0-1
[image_stack_roi_n,image_stack_w_n]=normalize(image_stack_roi,image_stack_s);
%calls function to do ratio of images
[ratio_img_roi_row,ratio_img_roi_lim_row,ratio_img_whole_lim_row,ratio_img_whole_row]=FRI(image_stack_roi_n,image_stack_w_n);
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

%Background array
background_array=array_with_headings;
background_array{stack+1,1}=name_array{stack,1};
background_array(stack+1,2:comparisons+1)=background_row;
%Smooth_array
smooth_array=array_with_headings;
smooth_array{stack+1,1}=name_array{stack,1};
smooth_array(stack+1,2:comparisons+1)=smooth_row;
%ROI_array
roi_array=array_with_headings;
roi_array{stack+1,1}=name_array{stack,1};
roi_array(stack+1,2:comparisons+1)=background_row;
%Normalized_roi
normalized_roi_array=array_with_headings;
normalized_roi_array{stack+1,1}=name_array{stack,1};
normalized_roi_array(stack+1,2:comparisons+1)=normalized_roi_row;
%Normalized_whole
normalized_whole_array=array_with_headings;
normalized_whole_array{stack+1,1}=name_array{stack,1};
normalized_whole_array(stack+1,2:comparisons+1)=normalized_whole_row;
%Ratio image roi
ratio_img_roi_array=ratio_array_with_headings;
ratio_img_roi_array{stack+1,1}=name_array{stack,1};
ratio_img_roi_array(stack+1,2:comparisons+1)=ratio_img_roi_row;
%Ratio image whole
ratio_img_whole_array=ratio_array_with_headings;
ratio_img_whole_array{stack+1,1}=name_array{stack,1};
ratio_img_whole_array(stack+1,2:comparisons+1)=ratio_img_whole_row;
%Ratio image whole with limits applied
ratio_img_whole_lim_array=ratio_array_with_headings;
ratio_img_whole_lim_array{stack+1,1}=name_array{stack,1};
ratio_img_whole_lim_array(stack+1,2:comparisons+1)=ratio_img_whole_lim_row;
%Ratio image roi with limits applied
ratio_img_roi_lim_array=ratio_array_with_headings;
ratio_img_roi_lim_array{stack+1,1}=name_array{stack,1};
ratio_img_roi_lim_array(stack+1,2:comparisons+1)=ratio_img_roi_lim_row;
% Log of Limited whole image ratio
log_ratio_img_roi_array=ratio_array_with_headings;
log_ratio_img_roi_array{stack+1,1}=name_array{stack,1};
log_ratio_img_roi_array(stack+1,2:comparisons+1)=log_ratio_img_roi_row;
% Log of Limited ROI ratio
log_ratio_img_whole_array=ratio_array_with_headings;
log_ratio_img_whole_array{stack+1,1}=name_array{stack,1};
log_ratio_img_whole_array(stack+1,2:comparisons+1)=log_ratio_img_whole_row;


file_names_ratio{stack+1,1}=name_array{stack,1};




% Clearing variables from row loop as change in size of ROI or image will
%cause dimensions mismatch

clear image; clear ratio1; clear ratio2; clear normalized_roi_row; 

clear image_stack;clear image_stack_reg;clear image_stack_b;clear image_stack_s
clear image_stack_roi;clear image_stack_roi_n;clear image_stack_w_n;
clear  background_row;clear  smooth_row;clear  roi_row;clear  c
clear T;clear P;clear G;clear log_ratio_1;clear log_ratio_2;
clear log_ratio_img_whole_row;clear log_ratio_img_roi_row
clear ratio_img_roi_row;clear ratio_img_roi_lim_row;
clear ratio_img_whole_lim_row;clear ratio_img_whole_row


end

clear ImageJ_str;clear T;clear array_with_headings;clear comparisons
clear f;clear files;clear files_numb;clear sets;clear stack;clear strg
clear image_array;clear ratio_array_with_headings;clear sa;clear sets
clear stack

 

