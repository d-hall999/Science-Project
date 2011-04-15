function [image_stack_s]=Smooth(image_stack_b,name_array,stack);
  
[~,~,h]=size(image_stack_b);

% User Input-Decide which smoothing filter

for Z=1:h; % selects image from its z value
image_slice=image_stack_b(:,:,Z);


% This starts loop as if user was unhappy about image
C=0;
count=0;
while C==0 || User_Error==0 %this loop allows user to change filter if unhappy about analysed image 
% If input incorrect starts loop regardless wether user inputs 1 or 0
clc
count_text=['Applied smoothing filter to image',num2str(Z),' ',num2str(count),' times before'];
msgbox(count_text);
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
pause(0.1)
%Asks user for input
if count>0
msgbox('If you are doing reapply please apply same method as before');
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
pause(0.1)
else
end
pause(0.5)
 prompt = {'Please enter "A" for smoothing based on average of neighbouring pixels or enter "G" for gaussian blur:'} ;
dlg_title = 'Input for smoothing method';
num_lines = 1;
def = {'A'};
Smoothing_Filter = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(Smoothing_Filter);
if X==0
    Smoothing_Filter{1,1}='K';
else
end

switch Smoothing_Filter{1,1} %switch allowing user to select smoothing filter
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
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);title('Original Image')
% Set figure size, Positon
set(figure_1,'Position',[50 50 800 600]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);

% Converts image back to 16-bit and sets brightness
round(smoothed_image);
J=uint16(smoothed_image);
[h,~] = max(J(:));

% Defines suplot & its position
SP2=subplot(1,2,2);imshow(J,[0 h]);title('New Image')
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
uiwait()
User_Error=1;
Print_Text=['Average from Neighbouring cells'];
%==========================================================================

    case 'G' %user selects gaussian blur


prompt = {'Please enter (sigma)radius of gaussian filter: '};
dlg_title = 'Input for gaussianfilter';
num_lines = 1;
def = {'0.5'};
g_size= inputdlg(prompt,dlg_title,num_lines,def);
% If cancel is hit size_r is 0x0 array this makes sure it is readable by switch
[X,~]=size(g_size);
if X==0
    g_size{1,1}=0.5; % if cancel hit default used
else
    g_size{1,1}=str2num(g_size{1,1});
end
myfilter = fspecial('gaussian',[3,3], g_size{1,1});% selects gaussian and size,
J = imfilter(image_slice, myfilter, 'replicate');% filters image

% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);title('Original Image')
% Set figure size, Positon
set(figure_1,'Position',[50 50 800 600]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);

% Displays subplot 2
[h,~] = max(J(:));        
SP2=subplot(1,2,2);imshow(J,[0 h]);title('New Image')
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
uiwait()
User_Error=1;
Print_Text=['Gaussian blur, sigma(radius): ',num2str(g_size{1,1}),' '];
%==========================================================================

    otherwise % minimize errors from user
        msgbpx('Unknown input!!! please enter a or g: ','Icon','warn');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        User_Error=0;
        
end

 prompt = {'Please enter Y if you are happy with image, enter N to restart smoothing on original image, enter REDO to apply Smoothing again to same image: '} ;
dlg_title = 'Input for user happy with smoothing';
num_lines = 1;
def = {'N'};
User_happy = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(User_happy);
if X==0
    User_happy{1,1}='K';
else
end

if User_Error==0
    User_happy=N;
else
end
switch User_happy{1,1}
    case 'Y'
        
        count=count+1;
        C=1;
        image_text=['Applied ', Print_Text,num2str(count),' times'];
        fig_to_file=figure;imshow(J, [0 h]);
        set(fig_to_file,'visible','off');
        TXT=text(20,20,image_text);
        set(TXT,'color',[1 0 0]);
        print(fig_to_file, '-dtiffn',name_array{stack,Z});    
    case 'N'
        msgbox('Restarting smoothing on image')
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        C=0;
        image_slice=image_stack_b(:,:,Z);
        count=1;
    case 'REDO'
        C=0;
        image_slice=J;
        count=count+1;
    otherwise
        msgbox('Unknown input beginning Smoothing for image slice again','Icon','warn')
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        C=0;
end

clc

end
image_stack_s(:,:,Z)=J;

end


end