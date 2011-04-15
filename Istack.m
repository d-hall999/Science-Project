function [image_stack_reg]=Istack(image_stack)
image_stack1=image_stack;
C=0;
while C==0
image_stack1=image_stack;

prompt = {'Do you wish to auto align images. Y for Yes, N for No:'} ;% Text for prompt
dlg_title = 'Input for auto align';%Title of dialog box
num_lines = 1;% How many lines in input box
def = {'Y'};%Default
stack_q = inputdlg(prompt,dlg_title,num_lines,def);
% If cancel is hit stack_q is 0x0 array this makes sure it is readable by
% switch
[X,~]=size(stack_q);
if X==0
    stack_q{1,1}='K';
else
end

switch stack_q{1,1};
    
    case 'Y'
    % Function runs StackReg macro so user doesn't have to use ImageJ interface
    MIJ.createImage(image_stack1); % exports stack to Image J 
    MIJ.run('StackReg ', 'transformation=[Translation]'); % Runs StackReg
    image_stack1=MIJ.getCurrentImage(); %imports aligned stack to image J
    MIJ.run('Close');
    image_stack_reg=uint16(image_stack1); %converts image stack back to uint16
    C=1;
    case 'N'% GUI call function
     manual_alignment(image_stack1);% GUI allowing manual
     uiwait()% all matlab code is no longer executed until GUI function complete
     image_stack_reg=evalin('base','image_stack_man(:,:,:)');
     C=1;   
    otherwise
        C=0;
        h = errordlg('Unknown input please select Y or N');
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        pause(3)
    end
%=========================================================================        

% Plots stacked images Images

if C~=0
% Image_Presentation
msgbox('Please check image stack is correctly aligned in stack_viewer!!!!!');
pause(3)
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
 
displayIm3d(image_stack_reg);% Show stack as slices controlled by slider
uiwait()
 
prompt = {'Are you happy with stack. Y for Yes. N for No: '} ;
dlg_title = 'Input for user happy stack';
num_lines = 1;
def = {'Y'};
stack_happy{1,1}=[];
stack_happy = inputdlg(prompt,dlg_title,num_lines,def);
[X,~]=size(stack_happy);
if X==0
    stack_happy{1,1}='K';
else
end


switch stack_happy{1,1}
    case 'Y'
        C=1;
    case 'N'
        C=0;
        clear image_stack_reg
    otherwise
        h = errordlg('Unknown input please select Y or N, Starting registration again');
        pause(3)
        delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));
        C=0;
        clear image_stack_reg
end
else % Does nothing error from 1st input
 end
 end
end
