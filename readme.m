%% readme

% Author: Darryl Hall
% Prototype 18/3/11

%Tested on Ubuntu 10.10
%To use on other operating systems simply define paths within .m files

% Paths to work on Mac Added
% Tested aswell


% Purpose:
% Construct Fluorescent Ratio Images with all intermediate steps including
% automatic stack registration,background removal, smoothing,
% normalization, Ratio, Plotting Originals & Ratio

%% Image J

'Ensure one instance of ImageJ is open whilst matlab is running';
%This matlab file calls certain ImageJ functions

% Requires ImageJ to be installed
% available to download "http://rsbweb.nih.gov/ij/download.html"


% Requires 2 plugins:
% TurboReg & StackReg available to download
% "http://rsbweb.nih.gov/ij/plugins/index.html"

% Instructions for installing plugin found in documentation on site


% MIJ availabe "http://bigwww.epfl.ch/sage/soft/mij/"
% To use add MI.jar file to MATLAB/java
% main file shows how to use file;



%% Files:Make sure they are in search path

readme.m %descriptive
main.m % starts MIJ & calls both ImageJ & Matlab functions
Istack.m % Automatic Image alignment
background.m % remove background
Smooth.m % smooth image
normalize.m % normalize image 0-1
FRI.m % Performs calculations
MyColormaps.mat % Custom colormap.
select_area.m % selects rectangular ROI 

%Where numerator image is present but denominator image isnt, values are in red.
%where denominator image is present but numerator image isnt, values are in blue.
% Where both are present ratio =1 and yellow
% Where no proteins are ==NaN ie black on FRI

Images %*Example Images provided in named folder. Change dir in script for
% your own use

%% Sample Values which isolate protein cluster values for example images

Stack
%Automatic stack= N
Background
%Image/Channel 1= BPF 40,2 Apply OUT to BPF Image
%Image/Channel 2= BPF 40,2 Apply OUT to BPF Image
%Image/Channel 3= BPF 40,2 Apply OUT to BPF Image
%Image/Channel 4= BPF 40,2 Apply OUT to BPF Image

%% Acknowledgements
% Big Thanks to supervisors for materials and technical support:
% Dr Christoph Ballestrem, Dr Alexandre Carisey, Adam Huffman 

% Thanks to Alexander Carisey

% Thanks to http://stackoverflow.com/questions/3402081/test-the-surrounding-non-zeros-elements
% for convuluting filter of surrounding pixels

% Thanks to P. Thévenaz, U.E. Ruttimann, M. Unser';
%"A Pyramid Approach to Subpixel Registration Based on Intensity,"
% IEEE Transactions on Image Processing,vol. 7, no. 1, pp. 27-41, January 1998
% Providing TurboReg and StackReg

% Thanks to:
% Daniel Sage1, Dimiter Prodanov2, and Carlos Ortiz
% Providing MIJ, Matlab to ImageJ interface



