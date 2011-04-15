%% readme

% Author: Darryl Hall
% Prototype 18/3/11

%Tested on Ubuntu 10.10
%To use on other operating systems simply define paths within .m files

% Paths to work on Mac Added
% Tested 

% Version 1.00 14/4/11


% Purpose:
% Construct Fluorescent Ratio Images with all intermediate steps including
% automatic stack registration,background removal, smoothing,
% normalization, Ratio and application of limits, Plotting Originals & Log Ratio

% Input: Directory saved in current search path containing appropiately named individual files, all
% control images ie stainings of nucleus when studying other cellular organelles
% need to be removed or else will be incorporated to ratio

% Most Image capture softwares automatically number files
% However if you are manually naming:
' Images needs appropiate file name as this is used to name ratios,';
'numbered prefix will help place them in correct order';
%staining1=1_Timepoint_1_Vinculin.tiff, staining2=2_Timepoint_1_Zyxin.tiff,

%It is possible to do ratios between timepoints of same stain, file names will have to be
%name accordingly
%1_Timepoint_1_Vinculin.tiff, 2_Timepoint_2_Vinculin.tiff,

% Program analyes images in rows
%Comparisons=Rows i.e Image1/Image2
%Columns are repeats, experiments

% Output
% .mat file with arrays containing data
% Background images stored in a directory with methods written on images
% Smoothing images stored in a directory with methods written on images
% 3 directorys of ratio images with colorbar and limits set to 10-0.1,
% 5-0.05,2-0.02 saved as tiff files

'Warning Please ensure if program run again that Ouptut directories are not';
'in search path as they may share same file names';

%% Auxillary files

'Ensure one instance of ImageJ is open whilst matlab is running';
%This matlab file calls certain ImageJ functions

% Requires ImageJ to be installed
% available to download "http://rsbweb.nih.gov/ij/download.html"

% Requires 2 plugins:
% TurboReg & StackReg available to download
% "http://rsbweb.nih.gov/ij/plugins/index.html"

% Instructions for installing plugins found in documentation on site

% MIJ availabe "http://bigwww.epfl.ch/sage/soft/mij/"
% To use add MI.jar file to MATLAB/java

% Download imoverlay from matlab file exchange
% http://www.mathworks.com/matlabcentral/fileexchange/10502-image-overlay#comments
% main file shows how to include auxillary files; imoverlay just needs to be
% placed in search path



%% M Files:Make sure they are in search path

readme.m % Purely descriptive
main.m % starts MIJ & calls both ImageJ & Matlab functions
Istack.m % Automatic Image alignment
background.m % remove background
Smooth.m % smooth image
normalize.m % normalize image 0-1
Ratio_Calc.m % Performs calculations
Ratio_Names.m % Names ratio files using nCr to calculate possibilities
MyColormaps.mat % Custom colormap.
select_area.m % selects rectangular ROI
displayIm3d.m % Stack viewer
overlay_s.m % Applys black to area where  no proteins present


%% Walthrough

% Program procceses data in rows i.e
%experiment_1    stain_1 stain_2 stain_3
%goes through image processing steps then continues
%experiment_2    stain_1 stain_2 stain_3


% 1. In command window type >>main
% 2. When warning for ImageJ appears hit any key
% 3. Slect folder where images stored
% 3. Input the numer of comparisons ie 2 stains=2, 3 stains=3,
% 4. Image Alignment follow instructions on program
% 4.1 Automatic or manual registration 
% 5. Background follow instrunctions on program
% 5.1 Background methods Rolling ball, Bandpass Filter, Outside cell,None
% 6. Smoothing follow instrunctions
% 6.1 Smoothing= Average from neighbours, 
% 7. Select_area
% 7.1 User selects area to zoom in for ratio avoiding debris causing bright
% spots
% Rest of steps automated require no user input
% 8.Normalization values given value range 0-1
% 9. Ratios calculated, limited 
% 10. Steps 4-9 repeat for however many experiments/repeats
% 11. When repeats completed ratios plotted in log scale and printed to
% folder depending on colorbar limits



%% Acknowledgements

% Big Thanks to supervisors for materials and technical support:
% Dr Christoph Ballestrem, Dr Alexandre Carisey, Adam Huffman 

% Thanks to http://stackoverflow.com/questions/3402081/test-the-surrounding-non-zeros-elements
% for convuluting filter of surrounding pixels

% Thanks to P. Thévenaz, U.E. Ruttimann, M. Unser';
%"A Pyramid Approach to Subpixel Registration Based on Intensity,"
% IEEE Transactions on Image Processing,vol. 7, no. 1, pp. 27-41, January 1998
% Providing TurboReg and StackReg

% Thanks to:
% Daniel Sage1, Dimiter Prodanov2, and Carlos Ortiz
% Providing MIJ, Matlab to ImageJ interface

% Thanks to Steve Eddins for imoverlay



