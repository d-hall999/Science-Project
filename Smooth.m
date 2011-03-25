function [image_stack_s]=Smooth(image_stack_b)

cd 'Smoothing'
[~,~,Z]=size(image_stack_b);

% User Input-Decide which smoothing filter

for Z=1:Z; % selects image from its z value
image_slice=image_stack_b(:,:,Z);


% This starts loop as if user was unhappy about image
C=0;
count=1;
while C==0 || User_Error==0 %this loop allows user to change filter if unhappy about analysed image 
% If input incorrect starts loop regardless wether user inputs 1 or 0

count_text=['Applied smoothing filter to this image ',num2str(count),' before'];
disp(count_text);
%Asks user for input
Smoothing_Filter=input('Please enter "A" for smoothing based on average of neighbouring pixels or enter "G" for gaussian blur:','s');



switch Smoothing_Filter %switch allowing user to select smoothing filter
%========================================================================
    case 'A'
close all       
% Convulation kernel's correspond to neighbouring pixels 0 is pixel
% currently selected during computation
% 1 1 1
% 1 0 1
% 1 1 1
kernel = [1 1 1;1 0 1;1 1 1];

%This computes sum of neighbouring pixels
sumX= conv2(double(image_slice),kernel,'same');  

% Logical operator next to array makes it calculate the number of neighbouring pixels
nX = conv2(double(image_slice>=0),kernel,'same');

% element by element division to get the required average
smoothed_image=sumX./nX;

% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);
% Set figure size, Positon
set(figure_1,'Position',[10 10 800 800]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);

% Converts image back to 16-bit and sets brightness
round(smoothed_image);
J=uint16(smoothed_image);
[h,~] = max(J(:));

% Defines suplot & its position
SP2=subplot(1,2,2);imshow(J,[0 h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
User_Error=1;
Print_Text='Average from Neighbouring cells ';
%==========================================================================

    case 'G' %user selects gaussian blur
g_size=input('Please enter size of gaussian square: ');
myfilter = fspecial('gaussian',[g_size,g_size], 0.5);% selects gaussian and size,
J = imfilter(image_slice, myfilter, 'replicate');% filters image

% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);
% Set figure size, Positon
set(figure_1,'Position',[50 10 1120 840]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);

% Displays subplot 2
[h,~] = max(J(:));        
SP2=subplot(1,2,2);imshow(J,[0 h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
User_Error=1;
Print_Text=['Gaussian blur, size: ',num2str(g_size),' '];
%==========================================================================

    otherwise % minimize errors from user
        disp('Unknown input!!! please enter a or g: ');
        User_Error=0;
        
end
disp('Please ensure you if you redo that you use same method and same size if using gaussian blur');
User_happy=input('Please enter Y if you are happy with image, enter N to start smoothing from original image, \n enter REDO to apply Smoothing again: ','s');

switch User_happy
    case 'Y'
        C=1;
        image_text=['Applied ', Print_Text,num2str(count),' times'];
        fig_to_file=figure;imshow(J, [0 h]);
        TXT=text(20,20,image_text);
        set(TXT,'color',[1 0 0]);
	print(fig_to_file, '-dtiffn',files{Z});
        
    case 'N'
        C=0;
        image_slice=image_stack_b(:,:,Z);
        count=1;
    case 'REDO'
        C=0;
        image_slice=J;
        count=count+1;
    otherwise
        disp('Unknown input beginning Smoothing for image slice again')
        C=0;
end



end
image_stack_s(:,:,Z)=J;

% clear variables not need
clear kernel
clear sumX
clear nX
clear smoothed_image
clear location
clear J

end