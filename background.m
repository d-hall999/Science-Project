function [image_stack_b]=background(image_stack_reg,files)

cd 'Background';

[~,~,Z]=size(image_stack_reg);

% User Input-Decide which background removal method

for Z=1:Z; % selects image from its z value
image_slice=image_stack_reg(:,:,Z);


% This starts loop as if user was unhappy about image change
C=0;
% Used later for printing text on images
BPF_Print=0;

while C==0 || User_Error==0 %this loop allows user to change filter if unhappy about analysed image 
% If input incorrect starts loop regardless wether user inputs 1 or 0
clc
%Display key & User selects background
disp('Close last instance of ImageJ if this program is being run again!!');
string_image=['Processing background for image',num2str(Z),];
disp(string_image);
string=sprintf('Please enter method of background removal."RB"=rolling ball, "BPF" for bandpass filter, \n "OUT" to select an ROI outside of cell to remove background, "N"=no background removal: \n');
background_switch=input(string,'s');

% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));

switch(background_switch)

%========================================================================   
% User selects rolling ball 
    case 'RB'

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
%=========================================================================
%User selects region outside cell
    case'OUT'
        
disp('Please select area outside area to draw Region of Interest in upcoming figure. Press any key to continue')
pause

figure;imshow(image_slice,[0 h]);
J=image_slice;
%This creates a freehand drawing on image, Parameters Closed and Value True
%ensure freehand area is closed
roi=impoly;

% Creates mask based on freehand ROI above shown image
BW=createMask(roi);

Max_Bground=regionprops(BW,J,'MaxIntensity');
Max_Bground=Max_Bground.MaxIntensity;
J=J-Max_Bground;

close all
% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h])
% Set figure size, Positon
set(figure_1,'Position',[50 10 1120 840]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
SP2=subplot(1,2,2);imshow(J,[0 h]);
set(SP2,'Position',[0.53 0.05 0.45 0.96]);

disp('Due to error you will have to manually maximise figure');
User_Error=1;

Print_Text=2;
%==========================================================================
%User selects BP filter
    case 'BPF'

% User inputs variables just like they would in ImageH        
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

BPF_2=input('Are you happy with BPF_Image? Type N to select different Background removal. \n If you are happy, Do you wish to apply background removal to BPF Image? \n Y to apply background to BPF, L to leave BPF Image as it is: \n','s');
switch BPF_2
    case 'N'
        User_Error=0;
        
    case 'Y'
        disp('Processing BPF Image')
        image_slice=J;
        User_Error=0;
        BPF_Print=1;
    case 'L'
        disp('BPF Image now being stacked you will still need to state you are happy on next prompt');
        User_Error=1;
        Print_Text=3;
    otherwise
        disp('Unknown input starting background removal on Original image');
        User_Error=0;
end

%==========================================================================
% User stated no background to be applied
    case 'N'
 disp('No background applied');
 J=image_slice;
 User_Error=1;
 Print_Text=4;
%==========================================================================
 % Error loop started again 
 
    otherwise
        disp('Unknown input');
        User_Error=0;
end

%==========================================================================
% This ask user if they are happy with input
User_happy=input('Please enter Y if you are happy with image,Enter BPF if applying background methods to BPF image, \n enter N to restart background removal: ','s');

switch User_happy
    case 'Y'
        C=1;
    case 'BPF'
        C=1;
    case 'N'
        image_slice=image_stack_reg(:,:,Z);
        C=0;
        BPF_Print=0;
    otherwise
        disp('Unknown input beginning background for image slice again')
        BPF_Print=0;
        C=0;
end


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
    
    
end


fig_to_file=figure;imshow(J, [0 h]);
TXT=text(20,20,image_text);
set(TXT,'color',[1 0 0]);

print(fig_to_file, '-dtiffn',files{Z});

image_stack_b(:,:,Z)=J;


end

clear size1
clear h
clear location
clear figure_handle
clear SP1
clear large_struct
clear Print_Text

clc
end