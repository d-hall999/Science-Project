%Read readme.m as there are additional things needed which I do not have right to distribute ImageJ &/or plugins
%This file calls all the other files to run program type <main> in command window


%% Clean the workspace and the previous figures

clear all
close all
clc


%% Get a timestamp before starting the processing

tic;

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




for f=1:4 %Here you select number of files if you have 4 images of the same fluorescently labelled 
%cell, make sure range of f=4, always has to be same cell due to automatic image registration
   
    
   %Reads file number depending on loop
   
   image = imread(fullfile(files{f}));
   strg=['Image ',num2str(f),' loading.'];
   disp(strg);
   
   image_stack(:,:,f)=image;
   
        
end

clc

%Displays warning
ImageJ_str=('Ensure ImageJ remains open !!!!!!!! hit any key to continue.');
disp(ImageJ_str);
pause

%% Search Paths

% Adds Java search paths edit for your OS
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

%% Functions

% calls function for automatic StackReg
[image_stack_reg]=Istack(image_stack);

%calls function to begin background removal
[image_stack_b]=background(image_stack_reg,files);

cd ..

%calls function to smooth image
[image_stack_s]=Smooth(image_stack_b);

cd ..

%User selcts square ROI
[image_stack_roi]=select_area(image_stack_s);

%calls function to normalize all images in stack 0-1
[image_stack_n]=normalize(image_stack_roi);

%calls function to do ratio of images
[ratio1,ratio2,ratio3]=FRI(image_stack_n);
%==========================================================================
%% Plots ratios


%  Now set the alpha map for the nan region
mask=isnan(ratio1);
black = [0 0 0];
overlay = imoverlay(rgb, mask, black);
imwrite(overlay, ratio1);
fig1=figure;imshow(ratio1);
load('MyColormaps','mycmap')
set(fig1,'Colormap',mycmap)
set(gca,'CLim',[-1 1]);
% Change last two values to match your screen
set(fig1,'Position',[10 10 1120 750]);
colorbar;

%image division 1st channel/3rd channel

fig2=figure;imshow(ratio2);
load('MyColormaps','mycmap');
set(fig2,'Colormap',mycmap);
set(fig2,'Position',[10 10 1120 750]);
set(fig2,'CLim',[0 1]);
colorbar;


%image division 2nd channel/3rd channel

fig3=figure;imshow(ratio3);
load('MyColormaps','mycmap');
set(fig3,'Colormap',mycmap);
set(fig3,'Position',[10 10 1120 840]);
set(gca,'CLim',[-1 1]);
colorbar;
%  Now set the alpha map for the nan region
z = ratio3;
z(~isnan(ratio3)) = 1;
z(isnan(ratio3)) = 0;
alpha(z);
set(gca, 'color', [0 0 0]);

%=========================================================================
% Plots original Images

%finds max for subplots
[h,~] = max(image_stack_s(:));
[~,~,Z]=size(image_stack_s);
% Image_Presentation

%% Plot smoothing Images

figure;
 for Z=1:Z; % selects image from its z value


image_{Z}=image_stack_s(:,:,Z);
subplot(1,4,Z);imshow(image_{Z},[0 h]);
if Z==1
    set(subplot(1,4,Z),'Position',[0.01 0.01 0.24 1]);
elseif Z==2
    set(subplot(1,4,Z),'Position',[0.25 0.01 0.24 1]);
elseif Z==3
    set(subplot(1,4,Z),'Position',[0.5 0.01 0.24 1]);
elseif Z==4
    set(subplot(1,4,Z),'Position',[0.75 0.01 0.24 1]);
else
    
end    
end
 

toc