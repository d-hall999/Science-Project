function [image_stack_roi_n,image_stack_w_n]=normalize(image_stack_roi,image_stack_s)
[~,~,Z]=size(image_stack_roi);

for Z=1:Z; % selects image from its z value

% ROI
image_slice=double(image_stack_roi(:,:,Z));
[MX,~] = max(image_slice(:));
[MN,~] = min(image_slice(:));
image_slice=(image_slice-MN)/(MX-MN);
image_stack_roi_n(:,:,Z)=image_slice;

% Whole Image

image_slice_whole=double(image_stack_s(:,:,Z));
[MX,~] = max(image_slice_whole(:));
[MN,~] = min(image_slice_whole(:));
image_slice_whole=(image_slice_whole-MN)/(MX-MN);
image_stack_w_n(:,:,Z)=image_slice_whole;

end
end


