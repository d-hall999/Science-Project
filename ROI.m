%% script file:ROI.m

% Purpose:
% Allow the user to select a freehand Region of Interest(ROI),program calculates the
% maximum and minimum intensities and plots a 3d graph of freehand area
%
% Author:Darryl Hall
%
% Recorded dates:
% Program created 10/02/11
%
% Test file:
% Currently creates a rectangle around ROI for both the axes and data to be
% plotted, y axes are inverted
%
% Date:13/02/11
% Changes Made:
% Cell Added: Applying NaN to oustide of ROI
% im2double removed as was no longer needed due to creation of double array
% earlier
% Plot has been tidied aswell
%
% Test file:
% Creates 3D plot with Y axis in both image and graph corresponding, just
% the ROI is plotted labels added aswell

%% Data Dictionary

% image_1=file to be uploaded
% h=array of data with x,y and intensity of image
% show_image=Displayed image
% roi= Region of interest selcted by user
% BW= Mask where pixels with roi are assigned value 1
% STATS= Output information of max and min
% y=y coordinates of selected array
% x=x coordinates of selected array
% double_array_h= image data converted from uint8 to double
% outsidemaskidx= is a vector displaying index number of points allowing
% selection of individual pixels outside mask.
% each element bsed on x and y
% min_x=minimum x value of ROI
% max_x=maximum x value of ROI
% min_y=minimum y value of ROI
% max_y=maximum y value of ROI
% h2=subarray of double_array_h
% surface_plot=Final graph
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

% Displays Image to ensure right image has been uploaded
show_image=imshow(image_1);

%% Creating ROI and mask

%This creates a freehand drawing on image, Parameters Closed and Value True
%ensure freehand area is closed
roi= impoly;

% Creates mask based on freehand ROI above shown image
BW=createMask(roi,show_image);


%% Calculates region properties of ROI,
% Generalformat: regionprops(region,image,property)

%Max intensity calculated
STATS=regionprops(BW,h,'MaxIntensity')

% Min intensity calculated
STATS=regionprops(BW,h,'MinIntensity')

%==========================================================================
% Change made 13/02/11
% Indexing taken from
% http://www.mathworks.com/company/newsletters/digest/sept01/matrix.html
%% Applying NaN to oustide of ROI
% This isolates the x and y co-ordinates of ROI v is a column vector which
% simply states logical operater is true
[y,x,v]=find(BW==0);

%Converts  image array into double precision so NaN is shown, as uint8 will display NaN as 0
double_array_h=double(h);

%This creates and index based on x y co-ordinates to allow selction of each
%pixel to apply NaN to. y and x have been inverted because row vectors
%needed for sub2ind
outsidemaskidx=sub2ind(size(double_array_h),[y'],[x']);
double_array_h(outsidemaskidx)=NaN;
%==========================================================================

%% 3D Plot of intensity

%  Example intensity plot taken from 
% http://www.mathworks.com/support/solutions/en/data/1-18QD5/index.html?product=IP&solution=1-18QD5

% Column vectors to find x,y of ROI
[y,x,v]=find(BW==1);


% These find the min and max co-ordinates to allow the creation of a
% rectangular array needed for creation of plot
max_x=max(x);
min_x=min(x);


max_y=max(y);
min_y=min(y);

%this creates a subarray based on co-ordinates of min and max values
h2=double_array_h(min_y:max_y,min_x:max_x);

% this creates grid for plot
X=min_x:max_x;
Y=min_y:max_y;
[xx,yy]=meshgrid(X,Y);


%Plots 3D graph of intensity in ROI
figure;surface_plot=surf(xx,yy,h2);

%=========================================================================
% Changes 13/02/10
% Original plot didnt take into account image and graph y axes are inverted
% Inverts Y axis

set(gca,'YDir','reverse');

axis([min_x max_x min_y max_y])



% Removes grid connected points so only surface is seen
set(surface_plot,'edgecolor','none');

% this shows a gradient based on z value(i.e) intensity
colormap(gray);

%shows color bar based on z
cb=colorbar('location','WestOutside');

%==========================================================================
% After running program on 13/11/02 was slight problem of color bar overlapping 
% with plot so when program was run I used codes get(cb,'Position') & get(gca,'Position') ,
% this let me see position, height and width and I manually set these so no
% overlap

c_bar_pos=get(cb,'Position');
c_bar_pos(1)=c_bar_pos(1)-0.1;
set(cb,'Position',c_bar_pos);

gca_pos=get(gca,'Position');
gca_pos(1)=gca_pos(1)+0.05;
set(gca,'Position',gca_pos);
%==========================================================================

%Annotation
xlabel(cb,'intensity');
ylabel('Y');
xlabel('X');
title('3D intensity plot of ROI');
%View is from Az=1 so graph is rotated ie xy are same orientation as image plus show axis and
%Elevation 75 shows image from a good perspective
view(-14,76);





