function [image_stack_roi]=select_area(image_stack_s)

msgbox('Select area of image for further analysis avoiding bright spots caused by anomilies such as debris');
pause(3)
[h,~] = max(image_stack_s(:));
show_image=figure;imshow(image_stack_s(:,:,1),[0 h]);
%% Creating ROI and mask

%This creates a freehand drawing on image, Parameters Closed and Value True
%ensure freehand area is closed
roi= imrect;

% Creates mask based on freehand ROI above shown image
BW=createMask(roi);

% Column vectors to find x,y of ROI
[y,x,v]=find(BW==1);


% These find the min and max co-ordinates to allow the creation of a
% rectangular array needed for creation of plot
max_x=max(x);
min_x=min(x);
max_y=max(y);
min_y=min(y);

%Apply mask to stack
[~,~,Z]=size(image_stack_s);

for Z=1:Z; % selects image from its z value

image_stack_roi(:,:,Z)=image_stack_s(min_y:max_y,min_x:max_x,Z);


end
end