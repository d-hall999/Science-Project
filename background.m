%% Image Upload


image_1=('Image_1.tif');

% Reads image data
h=imread(image_1);
%figure; imshow(image_1);
h2=h;

%
%size1=diameter
se = strel('ball',5,5);
J = imtophat(h2,se);
figure, imshow(J);