function [ratio_img_roi_row,ratio_img_roi_lim_row,ratio_img_whole_lim_row,ratio_img_whole_row]=Ratio_Calc(image_stack_roi_n,image_stack_w_n);

[~,~,h]=size(image_stack_roi_n);


 for Z=1:h; % selects image from its z value

double_array_roi{1,Z}=image_stack_roi_n(:,:,Z); % creates array with an roi image in each cell
double_array_whole{1,Z}=image_stack_w_n(:,:,Z); % 

 end

% This calculates maximum number of possible ratios and preallocates arrays
nCr = nchoosek(h,2);
ratio_img_roi_row(1,nCr)={[]};
ratio_img_whole_row(1,nCr)={[]};
image_number=1;

 for K=1:h-1
     for L=K+1:h
         
         ratio_img_roi_row{1,image_number}=double_array_roi{K}./double_array_roi{L};
         ratio_img_whole_row{1,image_number}=double_array_whole{K}./double_array_whole{L};
         image_number=image_number+1;
         
         
     end
 end
 [~,sa]=size(ratio_img_whole_row);

 %Preallocate limit arrays
 ratio_img_roi_lim_row(1,sa)={[]};
 ratio_img_whole_lim_row(1,sa)={[]};
 
 
for T=1:sa % Loops which limit Ratios to 0.1 to 10
    
    % ROI array limited
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