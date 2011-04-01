function [ratio_img_roi_row,ratio_img_roi_lim_row,ratio_img_whole_lim_row,ratio_img_whole_row]=FRI(image_stack_roi_n,image_stack_w_n);
[~,~,h]=size(image_stack_roi_n);


 for Z=1:h; % selects image from its z value

double_array_roi{1,Z}=image_stack_roi_n(:,:,Z); %creates array with an roi image in each cell
double_array_whole{1,Z}=image_stack_w_n(:,:,Z); %

 end

 %If images loaded in pairs
if h==2
    for z=1:h
    ratio_img_array_roi{z}=double_array_roi{1}/double_array_roi{2};
    ratio_img_array_whole{z}=double_array_whole{1}/double_array_whole{2};
    end
elseif h==3 % If images loaded in triplets
    
    ratio_img_roi_row{1,1}=double_array_roi{1}/double_array_roi{2};
    ratio_img_roi_row{1,2}=double_array_roi{1}./double_array_roi{3};
    ratio_img_roi_row{1,3}=double_array_roi{2}./double_array_roi{3};
    
    ratio_img_whole_row{1,1}=double_array_whole{1}./double_array_whole{2};
    ratio_img_whole_row{1,2}=double_array_whole{1}./double_array_whole{3};
    ratio_img_whole_row{1,3}=double_array_whole{2}./double_array_whole{3};
    
   
end

[~,sa]=size(ratio_img_whole_row);

for T=1:sa
    
    % ROI array
    ratio1=ratio_img_roi_row{1,T};% select ratio image in array
    [Y,X]=find(ratio1==0);% find where denominator staining is but no numerator
    zeroidx=sub2ind(size(ratio1),Y',X');
    ratio1(zeroidx)=0.1;
    
    [Y,X]=find(ratio1>10);% find where numerator protein is but no denominator
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=10;
    
    [Y,X]=find(ratio1<0.1);% Thresholds values where very little numerator is present
    infidx=sub2ind(size(ratio1),Y',X');
    ratio1(infidx)=0.1;
    
    ratio_img_roi_lim_row{1,T}=ratio1;% Puts scaled image back into array
   
    
    % Whole array
    
    ratio2=ratio_img_whole_row{1,T};% select ratio image in array
    [Y,X]=find(ratio2==0);% find where denominator staining is but no numerator
    zeroidx=sub2ind(size(ratio2),Y',X');
    ratio2(zeroidx)=0.1;
    
    [Y,X]=find(ratio2>10);% find where numerator protein is but no denominator
    infidx=sub2ind(size(ratio2),Y',X');
    ratio2(infidx)=10;
    
    [Y,X]=find(ratio2<0.1);% Thresholds values where very little numerator is present
    infidx=sub2ind(size(ratio2),Y',X');
    ratio2(infidx)=0.1;
    
    ratio_img_whole_lim_row{1,T}=ratio2;% Puts scaled image back into array
   
     
    
    
    
end

end