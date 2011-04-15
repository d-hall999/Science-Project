function [file_names_ratio_roi,file_names_ratio_whole,ratio_array_with_headings]=Ratio_Names(sets,comparisons,name_array)

% This calculates maximum number of possible ratios and preallocates arrays
nCr = nchoosek(comparisons,2);
ratio_array_with_headings{sets+1,nCr+1}=[];

h=comparisons;
image_number=2;

 for K=1:h-1
     for L=K+1:h
         
         numerator_title=sprintf('Image_%d',K);
         denominator_title=sprintf('Image_%d',L);
         concatenate_title=[numerator_title,'/',denominator_title];
         ratio_array_with_headings{1,image_number}=concatenate_title;
         image_number=image_number+1;
         
         
     end
 end
 
file_names_ratio_roi=ratio_array_with_headings;
file_names_ratio_whole=ratio_array_with_headings;

 for stack=1:sets
     image_number=1;
     file_names_ratio_roi{stack+1,1}=name_array{stack,1};
     file_names_ratio_whole{stack+1,1}=name_array{stack,1};
 for K=1:h-1
 for L=K+1:h
         
         file_names_ratio_roi{stack+1,image_number+1}=[name_array{stack,K},'_',name_array{stack,L},'_roi'];
         file_names_ratio_whole{stack+1,image_number+1}=[name_array{stack,K},'_',name_array{stack,L},'_whole'];
         image_number=image_number+1;     
 end
 end
 end
end