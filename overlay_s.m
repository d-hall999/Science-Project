function [mask]=overlay_s(log_ratio_img_roi_array,file_names_ratio_roi,file_names_ratio_whole,log_ratio_img_whole_array);

%% Prints limits 10 to 0.1
[X,Y,~]=size(log_ratio_img_whole_array);
mkdir 'Color_bar_limits_10_to_0.1';
cd  'Color_bar_limits_10_to_0.1';
for rows=2:X              
% Have to add +1 because of column and row headers 
    for columns=2:Y
    % Print ROI
    load('MyColormaps','mycmap');
    ratio1=log_ratio_img_roi_array{rows,columns};
    gr2 = mat2gray(ratio1,[-1 1]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    roi_name=[file_names_ratio_roi{rows,columns},'_10-0.1.tif'];
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',roi_name);
    
    % Print ROI
    load('MyColormaps','mycmap');
    ratio2=log_ratio_img_whole_array{rows,columns};
    gr2 = mat2gray(ratio2,[-1 1]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    whole_name=[file_names_ratio_whole{rows,columns},'_10-0.1.tif'];
    mask = isnan(ratio2);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',whole_name);
    
    end
end
cd ..

%% Prints limits 5 to 0.2
[X,Y,~]=size(log_ratio_img_whole_array);
mkdir 'Color_bar_limits_5_to_0.2';
cd  'Color_bar_limits_5_to_0.2';
limit=log10(5);
for rows=2:X              
% Have to add +1 because of column and row headers 
    for columns=2:Y
    % Print ROI
    load('MyColormaps','mycmap');
    ratio1=log_ratio_img_roi_array{rows,columns};
    gr2 = mat2gray(ratio1,[-limit limit]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    roi_name=[file_names_ratio_roi{rows,columns},'_5-0.2.tif'];
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',roi_name);
    
    % Print ROI
    load('MyColormaps','mycmap');
    ratio2=log_ratio_img_whole_array{rows,columns};
    gr2 = mat2gray(ratio2,[-limit limit]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    whole_name=[file_names_ratio_whole{rows,columns},'_5-0.2.tif'];
    mask = isnan(ratio2);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',whole_name);
    
    end
end
cd ..

%% Prints limits 2 to 0.5
[X,Y,~]=size(log_ratio_img_whole_array);
mkdir 'Color_bar_limits_2_to_0.5';
cd  'Color_bar_limits_2_to_0.5';
limit=log10(2);
for rows=2:X              
% Have to add +1 because of column and row headers 
    for columns=2:Y
    % Print ROI
    load('MyColormaps','mycmap');
    ratio1=log_ratio_img_roi_array{rows,columns};
    gr2 = mat2gray(ratio1,[-limit limit]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    roi_name=[file_names_ratio_roi{rows,columns},'_2-0.5.tif'];
    mask = isnan(ratio1);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',roi_name);
    
    % Print ROI
    load('MyColormaps','mycmap');
    ratio2=log_ratio_img_whole_array{rows,columns};
    gr2 = mat2gray(ratio2,[-limit limit]);% Scales image
    [u,~] = gray2ind(gr2, 256);% Indexes image
    rgb = ind2rgb(u, mycmap);% Displays RGB using custom colormap
    whole_name=[file_names_ratio_whole{rows,columns},'_2-0.5.tif'];
    mask = isnan(ratio2);
    black = [0 0 0];
    overlay = imoverlay(rgb, mask, black);
    imshow(overlay);set(gcf,'Colormap',mycmap);colorbar
    print(gcf, '-dtiffn','-r300',whole_name);
    
    end
end
cd ..
end