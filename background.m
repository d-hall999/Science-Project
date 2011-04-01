function [image_stack_b]=background(image_stack_reg,name_array);

cd 'Background';

[~,~,Z]=size(image_stack_reg);

% User Input-Decide which background removal method

for Z=1:Z; % selects image from its z value
image_slice=image_stack_reg(:,:,Z);
% This starts loop as if user was unhappy about image change
C=0;
% Used later for printing text on images
BPF_Print=0;

count=1;
while C==0 || User_Error==0 %this loop allows user to change filter if unhappy about analysed image 
% If input incorrect starts loop regardless wether user inputs 1 or 0
clc

%Display key & User selects background
string_image=['Processing background for image',num2str(Z),];
disp(string_image);
disp('Please ensure that if you are using BPF image to now apply  OUT, RB or N');
string=sprintf('Please enter method of background removal."RB"=rolling ball, "BPF" for bandpass filter, \n "OUT" to select an ROI outside of cell to remove background, "N"=no background removal: \n');
background_switch=input(string,'s');
    
% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));

%%
switch(background_switch)
%========================================================================   
% User selects rolling ball 
    case 'RB'
count=1;
size1=input('Please enter radius of rolling ball: ');% User defines rb radius
se = strel('ball',size1,size1,8);% Creates ball
J = imtophat(image_slice,se);% Opens,dilates and subtracts background

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h])
% Set figure size, Positon
set(figure_1,'Position',[50 10 800 800]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
SP2=subplot(1,2,2);imshow(J,[0 h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96])
User_Error=1;
Print_Text=1;
BPF_Used=0;
%=========================================================================
%User selects region outside cell
    case'OUT'
count=1;        
disp('Please select area outside area to draw Region of Interest in upcoming figure. Press any key to continue')
pause
figure;imshow(image_slice,[0 h]);
J=image_slice;
%Plots ROI
roi=impoly;
% Creates mask based on freehand ROI above shown image
BW=createMask(roi);
% Uses maximum value outside cell
Max_Bground=regionprops(BW,J,'MaxIntensity');
Max_Bground=Max_Bground.MaxIntensity;
J=J-Max_Bground;

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h])
% Set figure size, Positon
set(figure_1,'Position',[50 10 1120 840]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
SP2=subplot(1,2,2);imshow(J,[0 h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
clc
disp('Due to error you will have to manually maximise figure');
User_Error=1;
Print_Text=2;
BPF_Used=0;
%==========================================================================
%User selects BP filter
    case 'BPF'

if count==2
    warning('Only use BPF once on an image,starting from original');
    User_Error=0;
    image_slice=image_stack_reg(:,:,Z);
    BPF_Print=2;
    pause(3);
    Print_Text=0;
    BPF_Used=0;
    
else
% User inputs variables just like they would in ImageJ   
large_struct=input('Size of large structure: ');
small_struct=input('Size of small structure: ');
% Export Image to ImageJ
MIJ.createImage(image_slice);
% String defining variables in macro
strng2=['filter_large=',num2str(large_struct),' filter_small=',num2str(small_struct),' suppress=None tolerance=5'];
% Macro FFT Bandpass filter 
MIJ.run('Bandpass Filter...', strng2);
J=MIJ.getCurrentImage();
J=uint16(J);

% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h])
% Set figure size, Position
set(figure_1,'Position',[50 10 1120 840]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
[mi,~] = min(J(:));
SP2=subplot(1,2,2);imshow(J,[mi h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96])

clc

BPF_2=input('Are you happy with BPF_Image? .\n Type N to start different Background removal on original image. \n Type BPF to apply another background removal to BPF image. \n L to leave BPF Image and stack it for image analysis: \n','s');
switch BPF_2
    case 'N'
        User_Error=0;   
    case 'BPF'
        disp('Processing BPF Image')
        image_slice=J;
        User_Error=1;
        BPF_Print=1;
        BPF_Used=1;
        count=count+1;
        Print_Text=0;
        
    case 'L'
        disp('BPF Image now being stacked you will still need to state you are happy on next prompt');
        User_Error=1;
        Print_Text=3;
    otherwise
        clc
        warning('Unknown input starting background removal on Original image');
        pause(2)
        User_Error=0;
end
end
%==========================================================================
% User stated no background to be applied
    case 'N'
 disp('No background applied');
 J=image_slice;
 User_Error=1;
 Print_Text=4;
 BPF_Used=0;
%==========================================================================
 % Error loop started again 
 
    otherwise
        
        warning(Unknown_Input,'Unknown input');
        pause(2)
        User_Error=0;
        BPF_Used=0;
        Print_Text=0;
end

%==========================================================================
% This ask user if they are happy with input, if BPF has been used it skips
if BPF_Used==1
    
elseif User_Error==0;%Starts loop if any errors found
     image_slice=image_stack_reg(:,:,Z);
     C=0;
     BPF_Print=0;
elseif BPF_Used==0;
 % If last method used is RB, OUT, N   
User_happy=input('Please enter Y if you are happy with image, \n enter N to restart background removal on original image: ','s');
switch User_happy
    case 'Y'
        C=1;
    case 'N'
        image_slice=image_stack_reg(:,:,Z);
        C=0;
        BPF_Print=0;
    otherwise
        warning('Unknown input beginning background for image slice again');
        pause(3)
        BPF_Print=0;
        C=0;
end

clc
end
close all

%Once user is happy with image this then produces text
if Print_Text==1 && BPF_Print==1;
    image_text=['BPF image,L Structures:',num2str(large_struct),' S structures: ',num2str(small_struct), ', followed by RB radius= ',num2str(size1)];
elseif Print_Text==2 && BPF_Print==1
    image_text=['BPF image,L Structures:',num2str(large_struct),' S structures: ',num2str(small_struct), ', followed by Region Outside Cell'];
elseif Print_Text==4 && BPF_Print==1
    image_text=['BPF image,L Structures:',num2str(large_struct),' S structures: ',num2str(small_struct), ', followed by None'];
elseif Print_Text==1;
    image_text=['RB radius= ',num2str(size1)];
elseif Print_Text==2;
    image_text='Region outside cell';
elseif Print_Text==3;
    image_text=['BPF image,L Structures:',num2str(large_struct),' S structures: ',num2str(small_struct)];
elseif Print_Text==4
    image_text='No background';
else  
end

if BPF_Used==1
elseif User_Error==0;
    count=1;
else
%Printing of figure with text, array for next function is sorted
fig_to_file=figure;imshow(J, [0 h]);
set(fig_to_file,'visible','off') 
TXT=text(20,20,image_text);
set(TXT,'color',[1 0 0]);
print(fig_to_file, '-dtiffn',name_array{Z});
image_stack_b(:,:,Z)=J;
end
end


clc

cd ..
end