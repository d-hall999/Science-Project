function[mask]=lim_gui(log_ratio_img_roi_array,file_names_ratio_roi,file_names_ratio_whole,log_ratio_img_whole_array,mycmap);


%=========================================================================
% % Puts data in a linear orientation for next button in gui
file_names_ratio_roi=file_names_ratio_roi(2:end,2:end)';
[X,Y]=size(file_names_ratio_roi); no_of_ratios=X*Y;
file_names_ratio_roi=reshape(file_names_ratio_roi,no_of_ratios,1);

log_ratio_img_roi_array=log_ratio_img_roi_array(2:end,2:end)';
log_ratio_img_roi_array=reshape(log_ratio_img_roi_array,no_of_ratios,1);

log_ratio_img_whole_array=log_ratio_img_whole_array(2:end,2:end)';
log_ratio_img_whole_array=reshape(log_ratio_img_whole_array,no_of_ratios,1);

file_names_ratio_whole=file_names_ratio_whole(2:end,2:end)';
[X,Y]=size(file_names_ratio_roi); no_of_ratios=X*Y;
file_names_ratio_whole=reshape(file_names_ratio_whole,no_of_ratios,1);
%========================================================================

hfig = figure('ToolBar','figure',... % allows user to use standard figure toolbar
'Menubar', 'none',... %Turns off menu bar
'Name','Manual Realignment of Image',... %Title of figure
'NumberTitle','off',... 
'IntegerHandle','off','Resize','off');% Resize is turned off to maintain shape of GUI


% Figure in relation to computer screen, change if needed
set(hfig,'Position',[40 40 1000 600]);
% Define first variables for initial plot

up_l_nmbr=1;
low_l_nmbr=-1;
image_number=1;

% Text box for input of higher and lower limits
htext_low = uicontrol('Style','text','String','Low Limit for Color Bar','Position',[800,300,200,45]);
low_limit=uicontrol('Style','edit','Callback',@low_limit_Callback,'Tag','low_limit','Position',[800 250 200 45],'string','0.1');
htext_up = uicontrol('Style','text','String','Upper Limit for Color Bar','Position',[800,400,200,45]);
up_limit=uicontrol('Style','edit','Callback',@up_limit_Callback,'Tag','up_limit','Position',[800 350 200 45],'string','10');
htext_low = uicontrol('Style','text','String','Please select values between 10 and 0.1. Make sure upper limt higher than lower!','Position',[100,500,800,45]);

next_image=uicontrol('Style','pushbutton','Callback',@next_image_Callback,'Tag','next_image','Position',[800 200 200 45],'String','Next Image');
set(next_image,'Max',1);
set(next_image,'Min',0);
set(next_image,'Value',0);


print_image=uicontrol('Style','pushbutton','Callback',@print_image_Callback,'Tag','print_image','Position',[800 150 200 45],'String','Save Image');
set(print_image,'Max',1);
set(print_image,'Min',0);
set(print_image,'Value',0);


    
    ratio1=log_ratio_img_roi_array{image_number,1};%Loads image
    [Y,X]=find(ratio1>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio1<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio1,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
    Middle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Plots data in figure
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(gca,'Position',[0.01 0.05 0.7 0.7]);
 
 

function up_limit_Callback(up_limit,eventdata,handles) 
% update the displayed image when the slider is adjusted 
 up_l_str=get(up_limit, 'String');
 up_l_nmbr = str2num(up_l_str);
 up_l_nmbr=log10(up_l_nmbr);
 
 
 ratio1=log_ratio_img_roi_array{image_number,1};%Loads image
    [Y,X]=find(ratio1>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio1<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio1,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
    Middle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Plots data in figure
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(gca,'Position',[0.01 0.05 0.7 0.7]);

end

function low_limit_Callback(low_limit,eventdata,handles) 
% update the displayed image when the slider is adjusted 
 low_l_str=get(low_limit, 'String');
 low_l_nmbr = str2num(low_l_str);
 low_l_nmbr = log10(low_l_nmbr);
 
 ratio1=log_ratio_img_roi_array{image_number,1};%Loads image
    [Y,X]=find(ratio1>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio1<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio1,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
    MMiddle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Plots data in figure
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(gca,'Position',[0.01 0.05 0.7 0.7]);

end

function next_image_Callback(next_image,eventdata,handles) 
% update the displayed image when the slider is adjusted 
next_image = get(next_image,'Value');
image_number=image_number+next_image;
if image_number>no_of_ratios
    close all
end

ratio1=log_ratio_img_roi_array{image_number,1};%Loads image
    [Y,X]=find(ratio1>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio1<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio1,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
    Middle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Plots data in figure
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(gca,'Position',[0.01 0.05 0.7 0.7]);


end

function print_image_Callback(print_image,eventdata,handles) 
% update the displayed image when the slider is adjusted 
 print_image = get(print_image,'Value');
    if print_image==1
        
        l_str=get(low_limit, 'String');
        u_str=get(up_limit, 'String');
 %=================================================================
       % ROI Data
        
    
    ratio2=log_ratio_img_roi_array{image_number,1};%Loads image
    [Y,X]=find(ratio2>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio2),Y',X');
    ratio2(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio2<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio2),Y',X');
    ratio2(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio2,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    roi_name=[file_names_ratio_roi{image_number,1},'_',u_str,'-',l_str,'.tif'];
    mask = isnan(ratio2);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
    Middle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Print data
    fig_to_file=figure;imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(fig_to_file,'visible','off') 
    print(fig_to_file, '-dtiffn','-r300',roi_name);
 %========================================================================
        % Whole image data
        
     
    ratio3=log_ratio_img_whole_array{image_number,1};%Loads image
    [Y,X]=find(ratio3>up_l_nmbr);% find where numerator protein is bigger than upper limit and sets it at limit value
    infidx=sub2ind(size(ratio3),Y',X');
    ratio3(infidx)=up_l_nmbr;
    
    [Y,X]=find(ratio3<low_l_nmbr);% find where denominator protein is smaller than low limt
    infidx=sub2ind(size(ratio3),Y',X');
    ratio3(infidx)=low_l_nmbr;
    
    %Plots data
    gr2 = mat2gray(ratio3,[low_l_nmbr up_l_nmbr]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    whole_name=[file_names_ratio_whole{image_number,1},'_',u_str,'-',l_str,'.tif'];
    mask = isnan(ratio3);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    % Gets ticks for color bar from user input
    Upper_Tick=get(up_limit, 'String');
   Middle_tick=num2str((round((10^((up_l_nmbr+low_l_nmbr)/2))*100)/100));
    Lower_Tick=get(low_limit, 'String');
    Ticks{1,1}=Upper_Tick;Ticks{1,2}=Middle_tick;Ticks{1,3}=Lower_Tick;
    %Print data
    fig_to_file=figure;imshow(overlay);set(gcf,'Colormap',mycmap);colorbar('YTick',[255 128 1],'YTickLabel',Ticks)
    set(fig_to_file,'visible','off') 
    print(fig_to_file, '-dtiffn','-r300',whole_name);
    
    % Reset value
    set(print_image,'Value',0);
    end
end



end