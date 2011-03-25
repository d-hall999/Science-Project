function [image_stack_n]=normalize(image_stack_roi)
[~,~,Z]=size(image_stack_roi);

for Z=1:Z; % selects image from its z value
    
image_slice=double(image_stack_roi(:,:,Z));

[MX,~] = max(image_slice(:));
[MN,~] = min(image_slice(:));
image_slice=(image_slice-MN)/(MX-MN);


image_stack_n(:,:,Z)=image_slice;
end
end


