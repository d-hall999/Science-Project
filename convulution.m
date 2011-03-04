
% Original code taken from
%http://stackoverflow.com/questions/3402081/test-the-surrounding-non-zeros-elements

%% Clear workspace

clear all
close all
clc

%% Image Upload

%image test.tif was saved in a directory found in search path
image_1='Image_1.tif';

% Reads image data
h=imread(image_1);
h2=h;

%% User Input-Decide which smoothing filter

Smoothing_Filter=input('Please enter "a" for smoothing based on average of neighbouring pixels, enter "g" for gaussian blur:','s');

switch Smoothing_Filter
    case 'a'
       
% Convulation kernel1's correspond to neighbouring pixels 0 is pixel
% currently selected during computation
% 1 1 1
% 1 0 1
% 1 1 1

kernel = [1 1 1;1 0 1;1 1 1];


%This computes sum of neighbouring pixels
sumX= conv2(double(h2),kernel,'same');  

% Logical operator next to array makes it calculate the number of neighbouring pixels
nX = conv2(double(h2>=0),kernel,'same');

% element by element division to get the required average
misalign_image=sumX./nX;

round(misalign_image);
new_image=uint8(misalign_image);
imshow(new_image);

    case 'g'
        
myfilter = fspecial('gaussian',[3 3], 0.5);
        
myfilteredimage = imfilter(h2, myfilter, 'replicate');
        
imshow(myfilteredimage);

    otherwise
        disp('Unknown input please enter a or g');
        
end
        

