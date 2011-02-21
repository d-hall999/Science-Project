%  misalignment
%
% Date:18/2/11
%
% 
%% Clear workspace

clear all
close all
clc

%% Image Upload

%image test.tif was saved in a directory found in search path
image_1='test.tif';

% Reads image data
h=imread(image_1);
h2=h;
[y,x]=find(h>=0);

% These find the min and max co-ordinates to allow the creation of a
% rectangular array needed for creation of plot
max_x=max(x);
max_x=max_x-1;
min_x=min(x);
min_x=min_x+1;

% Below ensures that no edges are detected in h2
max_y=max(y);
max_y=max_y-1;
min_y=min(y);
min_y=min_y+1;

for x=min_x:max_x;
    for y=min_y:max_y;
        moving_array=h2(y-1:y+1,x-1:x+1);% 3x3 kernel
        average_1=mean(moving_array);% 3 values one for each row
        h2(y,x)=round(mean(average_1));% takes all averages and rounds them to an integer and places it x y of current loop
    end
end

% Program works but is very slow
