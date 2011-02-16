%% script file:ROI.m

% Purpose:
% Allow the user to select a freehand Region of Interest(ROI),program calculates the
% maximum and minimum intensities and plots a 3d graph of freehand area
%
% Author:Darryl Hall
%
% Recorded dates:
% Program created 10/02/11

%% Data Dictionary

% image_1=file to be uploaded
% h=array of data with x,y and intensity of image
% show_image=Displayed image
% roi= Region of interest selcted by user
% BW= Mask where pixels with roi are assigned value 1
%% Clear workspace

clear all
close all
clc

%% Image Upload

%image test.tif was saved in a directory found in search path
image_1='test.tif';

% Reads image data
h=imread(image_1);

% Displays Image to ensure right image has been uploaded
show_image=imshow(image_1);

%% Creating ROI and mask

%This creates a freehand drawing on image, Parameters Closed and Value True
%ensure freehand area is closed
roi= imfreehand('Closed','true');

% Creates mask based on freehand ROI above shown image
BW=createMask(roi,show_image);

%% Calculates region properties of ROI,
% Generalformat: regionprops(region,image,property)

%Max intensity calculated
maximum_intensity=regionprops(BW,h,'MaxIntensity')

% Min intensity calculated
minimum_intensity=regionprops(BW,h,'MinIntensity');


%% 3D Plot of intensity

%  Example intensity plot taken from 
% http://www.mathworks.com/support/solutions/en/data/1-18QD5/index.html?product=IP&solution=1-18QD5

% This isolates the x and y co-ordinates of ROI v is a row vector which
% simply states logical operater is true
[y,x,v]=find(BW==1);

% These find the min and max co-ordinates to allow the creation of a
% rectangular array needed for creation of plot
max_x=max(x);
min_x=min(x);
max_y=max(y);
min_y=min(y);

%this creates a subarray based on co-ordinates of min and max values
h2=h(min_y:max_y,min_x:max_x);

% this creates grid for plot
X=min_x:max_x;
Y=min_y:max_y;
[xx,yy]=meshgrid(X,Y);

% extracts array information 
i=im2double(h2);

%Plots 3D graph of intensity in ROI
figure;surf(xx,yy,i);
colorbar

%This shows section of image being analysed
figure;imshow(i)
