function displayIm3d(image_stack_reg) 

im=image_stack_reg;
[~,~,max] = size(im);
maxSlice=max;
minSlice = 1;  
startSlice = 1; 
slider_step_size=1/(maxSlice-1);


% Create a figure without toolbar and menubar. 
hfig = figure('Menubar', 'figure','ToolBar','figure',... 
'Name','Image Stack Viewer',... 
'NumberTitle','off',... 
'IntegerHandle','off','Resize','off'); 

set(hfig,'Position',[40 40 1000 600]);

slider1 = uicontrol(hfig,'Style','slider','Callback',@slider1_Callback,'SliderStep',[slider_step_size maxSlice/2],'Position',[20 20 180 30]); 
set(slider1,'Value',startSlice); % 
set(slider1,'Max',max); % 
set(slider1,'Min',minSlice); 

close_button=uicontrol('Style','pushbutton','Callback',@close_button_Callback,'Tag','button_y_up','String','Close','Position',[750 20 70 30]);


slice = get(slider1,'Value'); % returns position of slider 

% Display the image in a figure with imshow. 
himage = imshow(im(:,:,slice),'DisplayRange',[ ]); 
  


function slider1_Callback(slider1,eventdata,handles) 
% update the displayed image when the slider is adjusted 
slice = round(get(slider1,'Value')); 
imshow(im(:,:,slice),'DisplayRange',[]); 

end 
function close_button_Callback(apply_trans,eventdata,handles) 
% update the displayed image when the slider is adjusted 

close all

end

end