function [image_stack_roi_n,image_stack_w_n]=normalize(image_stack_roi,image_stack_s)
[~,~,Z]=size(image_stack_roi);

for Z=1:Z; % selects image from its z value

% ROI
image_slice=double(image_stack_roi(:,:,Z));
[MXROI,~] = max(image_slice(:));
[MNROI,~] = min(image_slice(:));
image_slice=(image_slice-MNROI)/(MXROI-MNROI);
image_stack_roi_n(:,:,Z)=image_slice;

% Whole Image

image_slice_whole=double(image_stack_s(:,:,Z));

% usinng MAX value from ROI, this causes bright spots from debris during
% imaging
[Y,X]=find(image_slice>MXROI);% find where denominator staining is but no numerator
zeroidx=sub2ind(size(image_slice),Y',X');
image_slice_whole(zeroidx)=MXROI;


[MX,~] = max(image_slice_whole(:));
[MN,~] = min(image_slice_whole(:));
image_slice_whole=(image_slice_whole-MN)/(MX-MN);
image_stack_w_n(:,:,Z)=image_slice_whole;

end
end


