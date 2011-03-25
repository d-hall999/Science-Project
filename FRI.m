function [ratio1,ratio2,ratio3]=FRI(image_stack_n)
[~,~,Z]=size(image_stack_n);


 for Z=1:Z; % selects image from its z value

double_array_{Z}=image_stack_n(:,:,Z); %creates array with an image in each cell


 end


%image division 1st channel/2nd Channel


ratio1=double_array_{1}./double_array_{2};

%finds where denominator image is present but no value in numerator
[Y,X]=find(ratio1==0);
zeroidx=sub2ind(size(ratio1),Y',X');
ratio1(zeroidx)=0.1;

%h=find(ratio1>0 & ratio1<0.1);
% zeroidx=sub2ind(size(ratio1),Y',X');
%ratio1(h)=0.1;

%finds where numerator image is present but no value in numerator
[Y,X]=find(ratio1>10);
infidx=sub2ind(size(ratio1),Y',X');
ratio1(infidx)=10;

ratio1=log10(ratio1);

%image division 1st channel/3rd channel
ratio2=double_array_{1}./double_array_{3};

[Y,X]=find(ratio2==0);
zeroidx=sub2ind(size(ratio2),Y',X');
ratio2(zeroidx)=0.1;

%h=find(ratio2>0 & ratio2<0.1);
% zeroidx=sub2ind(size(ratio2),Y',X');
%ratio2(h)=0.1;

[Y,X]=find(ratio2>10);
infidx=sub2ind(size(ratio2),Y',X');
ratio2(infidx)=10;

ratio2=log10(ratio2);

%image division 2nd channel/3rd channel

ratio3=double_array_{2}./double_array_{3};

[Y,X]=find(ratio3==0);
zeroidx=sub2ind(size(ratio3),Y',X');
ratio3(zeroidx)=0.1;

%h=find(ratio3>0 && ratio3<0.1);
% zeroidx=sub2ind(size(ratio3),Y',X');
%ratio2(h)=0.1;

[Y,X]=find(ratio3>10);
infidx=sub2ind(size(ratio3),Y',X');
ratio3(infidx)=10;

ratio3=log10(ratio3);

end