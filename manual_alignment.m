function manual_alignment(image_stack1);
im=image_stack1;
[~,~,size_stack]=size(im);


hfig = figure('ToolBar','figure',... % allows user to use standard figure toolbar
'Menubar', 'none',... %Turns off menu bar
'Name','Manual Realignment of Image',... %Title of figure
'NumberTitle','off',... 
'IntegerHandle','off','Resize','off');% Resize is turned off to maintain shape of GUI


% Figure in relation to computer screen, change if needed
set(hfig,'Position',[40 40 1000 600]);

%=========================================================================
%Button placement on gui and call back function
button_y_up=uicontrol('Style','pushbutton','Callback',@button_y_up_Callback,'Tag','button_y_up','Position',[800 300 45 45],'String','↑');
set(button_y_up,'Max',1);
set(button_y_up,'Min',0);
set(button_y_up,'Value',0);

button_down_up=uicontrol('Style','pushbutton','Callback',@button_y_down_Callback,'Tag','button_y_down','Position',[800 250 45 45],'String','↓');
set(button_down_up,'Max',1);
set(button_down_up,'Min',0);
set(button_down_up,'Value',0);

button_x_left=uicontrol('Style','pushbutton','Callback',@button_x_left_Callback,'Tag','button_y_up','Position',[750 275 45 45],'String','←');
set(button_x_left,'Max',1);
set(button_x_left,'Min',0);
set(button_x_left,'Value',0);

button_x_right=uicontrol('Style','pushbutton','Callback',@button_x_right_Callback,'Tag','button_y_up','Position',[850 275 45 45],'String','→');
set(button_x_right,'Max',1);
set(button_x_right,'Min',0);
set(button_x_right,'Value',0);

apply_trans=uicontrol('Style','pushbutton','Callback',@apply_trans_Callback,'Tag','button_y_up','Position',[790 400 70 45],'String','Apply');
set(apply_trans,'Max',1);
set(apply_trans,'Min',0);
set(apply_trans,'Value',0);

%==========================================================================

image_slice=1;% Sets base image
%Find size of image
[Y,X]=size(im(:,:,image_slice));
Scale=X/Y; % This ensures axis to be plotted are to scale ie no stretching


himage=imshow(im(:,:,image_slice),'XData',[0+X/100*5 X+X/100*5],'YData',[0+Y/100*5 Y+Y/100*5],'DisplayRange',[]);
axis on % Creates axis for image translation
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);% axis limits are 110 % of image as chromatic aborations
% pixel shifts are no larger than 5% 
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])% Removes ticks

hold on

I3=im(:,:,image_slice+1);
h = imshow(I3, gray);% Plots next image on stack 
set(h, 'AlphaData', 0.4); %Overlays with transparency

axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])

Y_translation=0;%Starting points for functions
X_translation=0;



%=========================================================================
%Comments made on first button function as each function very similar
function button_y_up_Callback(button_y_up,eventdata,handles) 
% update the displayed image when the slider is adjusted 
button_y_up = get(button_y_up,'Value');

Y_translation=Y_translation-button_y_up;% Uses value from button to calculate translation in Y axis
hold off 
cla %Clears current axis

T = [1 0 0; 0 1 0; X_translation Y_translation 1];%Transformation matrix with X and Y translations stored
tform = maketform('affine', T);% Rigid manual transformation

[I3,xdata,ydata] = imtransform(im(:,:,image_slice+1),tform);%Gets data to plot translated image on axis
if ydata(1,1)<0%Ensures image stay with in boundarys
    ydata=[1 Y];
    Y_translation=0;
    
else
end
[Y,X]=size(im(:,:,2));

%Replots data
himage=imshow(im(:,:,image_slice),'XData',[0+X/100*5 X+X/100*5],'YData',[0+Y/100*5 Y+Y/100*5],'DisplayRange',[]);
axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])

hold on

h=imshow(I3,gray(256),'XData',xdata,'YData',ydata);%Plots transformed image
set(h, 'AlphaData', 0.4);

axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[]);

 end

function button_y_down_Callback(button_y_down,eventdata,handles) 
% update the displayed image when the slider is adjusted 
button_y_down = get(button_y_down,'Value');

Y_translation=Y_translation+button_y_down;
hold off

cla

T = [1 0 0; 0 1 0; X_translation Y_translation 1];
tform = maketform('affine', T);

[I3,xdata,ydata] = imtransform(im(:,:,image_slice+1),tform);
[Y,X]=size(im(:,:,2));

if ydata(1,2)>=Y+Y/100*10;
    ydata=[(Y/100*10)+1 (Y+Y/100*10)];
    Y_translation=(Y/100*10);
else
end


himage=imshow(im(:,:,image_slice),'XData',[0+X/100*5 X+X/100*5],'YData',[0+Y/100*5 Y+Y/100*5],'DisplayRange',[]);
axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])

hold on

h=imshow(I3,gray(256),'XData',xdata,'YData',ydata);
set(h, 'AlphaData', 0.4);

axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[]);

end 

function button_x_left_Callback(button_x_left,eventdata,handles)
% update the displayed image when the slider is adjusted 
button_x_left= get(button_x_left,'Value');

X_translation=X_translation-button_x_left;
hold off

cla

T = [1 0 0; 0 1 0; X_translation Y_translation 1];
tform = maketform('affine', T);

[I3,xdata,ydata] = imtransform(im(:,:,image_slice+1),tform);
[Y,X]=size(im(:,:,image_slice+1));
if xdata(1,1)<0
    xdata=[0 X];
    X_translation=0;
else
end
himage=imshow(im(:,:,image_slice),'XData',[0+X/100*5 X+X/100*5],'YData',[0+Y/100*5 Y+Y/100*5],'DisplayRange',[]);
axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])

hold on

h=imshow(I3,gray(256),'XData',xdata,'YData',ydata);
set(h, 'AlphaData', 0.4);

axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[]);

end 

function button_x_right_Callback(button_x_right,eventdata,handles) 
% update the displayed image when the slider is adjusted 
button_x_right = get(button_x_right,'Value');

X_translation=X_translation+button_x_right;
hold off

cla

T = [1 0 0; 0 1 0; X_translation Y_translation 1];
tform = maketform('affine', T);

[I3,xdata,ydata] = imtransform(im(:,:,image_slice+1),tform);
[Y,X]=size(im(:,:,image_slice));

if xdata(1,2)>=X+X/100*10;
    xdata=[(X/100*10)+1 (X+X/100*10)];
    X_translation=(X/100*10);
else
end

himage=imshow(im(:,:,image_slice),'XData',[0+X/100*5 X+X/100*5],'YData',[0+Y/100*5 Y+Y/100*5],'DisplayRange',[]);
axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[])

hold on

h=imshow(I3,gray(256),'XData',xdata,'YData',ydata);
set(h, 'AlphaData', 0.4);

axis on
axis('manual');
axis([0 X+(X/100*10) 0 Y+(Y/100*10)]);
set(gca,'Position',[0.05 0.1 0.6 0.6*Scale]);
set(gca, 'XTick',[],'YTick',[]);
end 
%=====================================================================

function apply_trans_Callback(apply_trans,eventdata,handles) 
% update the displayed image when the slider is adjusted 
apply_trans = get(apply_trans,'Value');


%Performs tanslation on image and exports variables
T = [1 0 0; 0 1 0; X_translation Y_translation 1];
tform = maketform('affine', T);

I4 = imtransform(im(:,:,image_slice+1),tform,'XData',[1+X/100*5 X+X/100*5],'YData',[1+Y/100*5 Y+Y/100*5]);
assignin('base','im',im);
assignin('base','I4',I4);
assignin('base','image_slice',image_slice);


im(:,:,1);
evalin('base','image_stack_man(:,:,1)=im(:,:,1);');
string=['image_stack_man(:,:,',num2str(image_slice+1),')=I4;'];
evalin('base',string);
image_slice=image_slice+apply_trans;
if image_slice==size_stack;
    
   
   close all

else

end
    

end

end