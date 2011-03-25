function [image_stack_reg]=Istack(image_stack)
image_stack1=image_stack;
C=0;
while C==0
image_stack1=image_stack;
    
stack_q=input('Do you wish to auto align images. Y for Yes, N for No: ','s');

switch stack_q;
    
    case 'Y'
% Function runs StackReg macro so user doesn't have to use ImageJ interface

MIJ.createImage(image_stack1); % exports stack to Image J 
MIJ.run('StackReg ', 'transformation=[Translation]'); % Runs StackReg
image_stack1=MIJ.getCurrentImage(); %imports aligned stack to image J
image_stack_reg=uint16(image_stack1); %converts i age stack back to uint16

    case 'N'
        image_stack_reg=image_stack1;
        
    otherwise
        C=0;
end
%=========================================================================        
% Plots stacked images Images

%finds max for subplots
[h,~] = max(image_stack_reg(:));
[~,~,Z]=size(image_stack_reg);
% Image_Presentation
 for Z=1:Z; % selects image from its z value

image_{Z}=image_stack_reg(:,:,Z);
subplot(2,2,Z);imshow(image_{Z},[0 h]);

 end
 disp('Please check image stack is correctly aligned in ImageJ!!!!!');
 stack_happy=input('Are you happy with stack. Y for Yes. N for No: ','s');
 
 switch stack_happy
    case 'Y'
        C=1;
    case 'N'
        C=0;
    otherwise
        disp('Unknown input beginning Smoothing for image slice again')
        C=0;
 end
 end
end
