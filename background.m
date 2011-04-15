function [image_stack_b]=background(image_stack_reg,name_array,stack);


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

string_image=['Processing background for image:',num2str(Z)];
msgbox(string_image);
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));

msgbox('Please ensure that if you are using a BPF image to now apply  OUT, RB or N','Icon','warn');
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
pause(0.5)


prompt = {'Please enter method of background removal."RB"=rolling ball, "BPF" for bandpass filter, "OUT" to select an ROI outside of cell to remove background, "N"=no background removal:'};
dlg_title = 'Input for background removal';
num_lines = 1;
def = {'N'};
background = inputdlg(prompt,dlg_title,num_lines,def);
% If cancel is hit background is 0x0 array this makes sure it is readable by switch
[X,~]=size(background);
if X==0
    background_switch='K';
else
    background_switch=background{1,1};
end
% Selects Max intensity value of uint16 image
[h,~] = max(image_slice(:));



%%
switch(background_switch)
%========================================================================   
% User selects rolling ball 
    case 'RB'
count=1;

prompt = {'Please enter radius of rolling ball: '};
dlg_title = 'Input for rolling ball';
num_lines = 1;
def = {'10'};
size_r = inputdlg(prompt,dlg_title,num_lines,def);
% If cancel is hit size_r is 0x0 array this makes sure it is readable by switch
[X,~]=size(size_r);
if X==0
    size1=10; % if cancel hit default used
else
    size1=size_r{1,1};
    size1=str2num(size1);
end

se = strel('ball',size1,size1,0);% Creates ball
J = imtophat(image_slice,se);% Opens,dilates and subtracts background


% Allows manipulation of figure and Subplot
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);title('Original Image')
% Set figure size, Positon
set(figure_1,'Position',[50 50 800 600]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
SP2=subplot(1,2,2);imshow(J,[0 h]);title('New Image')
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
uiwait()
User_Error=1;
Print_Text=1;
BPF_Used=0;


prompt = {'Do you wish to apply 5% threshold to remove low level background not removed by RB? Type Y to apply, N to continue, If previously applied BPF to this image please type N'} ;
dlg_title = 'Input for user threshold';
num_lines = 1;
def = {'N'};
thresh = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(thresh);
if X==0
    thresh{1,1}='K';
else
end

switch thresh{1,1}
    case 'Y'
    K=J
    percent_threshold=(max(J(:))/100)*5;
    [Y,X]=find(J<percent_threshold);
    thresh_idx=sub2ind(size(J),Y',X');
    J(thresh_idx)=0;
    
    figure_1=figure;SP1=subplot(1,2,1);imshow(K,[0 h]);title('Original Image')
    % Set figure size, Positon
    set(figure_1,'Position',[50 50 800 600]);
    set(SP1,'Position',[0.05 0.05 0.45 0.96]);
    SP2=subplot(1,2,2);imshow(J,[0 h]);title('New Image')
        set(SP2,'Position',[0.53 0.05 0.45 0.96]);
    uiwait()
    case'N'
        
    otherwise
        clc
        h = errordlg('Unknown input starting background removal on Original image');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        User_Error=0;

end
%=========================================================================
%User selects region outside cell
    case'OUT'
count=1;        
msgbox('Please select area outside area to draw Region of Interest in upcoming figure')
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
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
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);title('Original Image')
% Set figure size, Positon
set(figure_1,'Position',[50 50 800 600]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
SP2=subplot(1,2,2);imshow(J,[0 h]);title('New Image')
set(SP2,'Position',[0.53 0.05 0.45 0.96]);
uiwait()
clc

User_Error=1;
Print_Text=2;
BPF_Used=0;
%==========================================================================
%User selects BP filter
    case 'BPF'

if count==2
    msgbox('Only use BPF once on an image,starting from original unmodified image','Icon','warn');
    pause(3)
    delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
    User_Error=0;
    image_slice=image_stack_reg(:,:,Z);
    BPF_Print=2;
    Print_Text=0;
    BPF_Used=0;
    
else
% User inputs variables just like they would in ImageJ   
prompt = {'Filter large structures down to:','Filter small structures down to:'};
dlg_title = 'Input for BPF function';
num_lines = 1;
def = {'40','2'};
BPF_Size = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(BPF_Size);
if X==0
   large_struct=40;
   small_struct=2;
else
    large_struct=str2double(BPF_Size{1,1});
    small_struct=str2double(BPF_Size{2,1});
end

% Export Image to ImageJ
MIJ.createImage(image_slice);
% String defining variables in macro
strng2=['filter_large=',num2str(large_struct),' filter_small=',num2str(small_struct),' suppress=None tolerance=5'];
% Macro FFT Bandpass filter 
MIJ.run('Bandpass Filter...', strng2);
J=MIJ.getCurrentImage();
MIJ.run('Close');
J=uint16(J);

% Allows manipulation of figure and Subplot 
figure_1=figure;SP1=subplot(1,2,1);imshow(image_slice,[0 h]);title('Original Image')

% Set figure size, Position
set(figure_1,'Position',[50 50 800 600]);
set(SP1,'Position',[0.05 0.05 0.45 0.96]);
[mi,~] = min(J(:));
SP2=subplot(1,2,2);imshow(J,[mi h]);title('New Image')
set(SP2,'Position',[0.53 0.05 0.45 0.96])
uiwait()
clc

 
prompt = {'Are you happy with BPF_Image? . Type N to start different Background removal on original image. Type BPF to apply another background removal to BPF image. Type L to leave BPF Image and stack it for image analysis:'} ;
dlg_title = 'Input for user BPF processing';
num_lines = 1;
def = {'N'};
BPF_2 = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(BPF_2);
if X==0
    BPF_2{1,1}='K';
else
end

switch BPF_2{1,1}
    case 'N'
        msgbox('Restarting backgorund removal')
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        User_Error=0;
        BPF_Print=0;
    case 'BPF'
        image_slice=J;
        User_Error=1;
        BPF_Print=1;
        BPF_Used=1;
        count=count+1;
        Print_Text=0;
        
    case 'L'
        User_Error=1;
        Print_Text=3;
        BPF_Used=1;
    otherwise
        clc
        h = errordlg('Unknown input starting background removal on Original image');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        User_Error=0;

end
end
%==========================================================================
% User stated no background to be applied
 case 'N'
 msgbox('No background applied');
 pause(3)
 delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
 pause(0.1)
 J=image_slice;
 User_Error=1;
 Print_Text=4;
 BPF_Used=0;
%==========================================================================
 % Error loop started again 
  otherwise
        h = errordlg('Unknown input starting background removal on Original image');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
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
 % If last method used is RB, OUT or N asks user if they are happy with
 % image
 
 prompt = {'Please enter Y if you are happy with image, enter N to restart background removal on original image: '} ;
dlg_title = 'Input for user happy with background';
num_lines = 1;
def = {'N'};
User_happy = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(User_happy);
if X==0
    User_happy{1,1}='K';
else
end


switch User_happy{1,1}
    case 'Y'
        C=1;
        User_Error=1;
    case 'N'
        image_slice=image_stack_reg(:,:,Z);
        C=0;
        BPF_Print=0;
        User_Error=0;
    otherwise
        h = errordlg('Unknown input starting background removal on Original image');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(0.1)
        C=0;
        BPF_Print=0;
        User_Error=0;
end

clc
end
close all

%Once user is happy with image this then produces text to overlay images
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

if BPF_Used==1 || User_Error==0;
    count=1;
else
%Printing of figure with text, array for next function is sorted
fig_to_file=figure;imshow(J, [0 h]);
set(fig_to_file,'visible','off') 
TXT=text(20,20,image_text);
set(TXT,'color',[1 0 0]);
print(fig_to_file, '-dtiffn',name_array{stack,Z});
image_stack_b(:,:,Z)=J;
end
end
clc

end