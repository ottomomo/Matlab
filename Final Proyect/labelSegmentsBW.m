% Connected Component Labelling Algorithm V1.0 September 2017. Israel Cayetano 
function [img_label,elements_list,number_elements]=labelSegmentsBW(img_bwfilt, up_margin)
img_label=img_bwfilt(up_margin:end,:);
label_count=1;
for i=2:size(img_label,1)-1
    for j=2:size(img_label,2)-1
        if img_label(i,j)>=1
            if img_label(i,j)==1
                label_count=label_count+1;
            end
            A=img_label(i-1:i+1,j-1:j+1);
            min_label=min(min(A(A>1))); 
            if min_label>1
                img_label(i,j)=min_label;
            else
                img_label(i,j)=label_count;
            end
        end
    end
end
 
label_count=1;
for i=size(img_label,1)-1:-1:2
    for j=size(img_label,2)-1:-1:2
        if img_label(i,j)>=1
            if img_label(i,j)==1
                label_count=label_count+1;
            end
            A=img_label(i-1:i+1,j-1:j+1);
            min_label=min(min(A(A>1))); 
            if min_label>1
                img_label(i,j)=min_label;
            else
                img_label(i,j)=label_count;
            end
        end
    end
end
 
elements_list=unique(img_label);
elements_list=elements_list(2:end);
number_elements=length(elements_list);
 
for u=1:number_elements
    for i=2:size(img_label,1)-1
        for j=2:size(img_label,2)-1
            if img_label(i,j)==elements_list(u)
                img_label(i,j)=u;
            end
        end
    end
end
 
elements_list=unique(img_label);
elements_list=elements_list(2:end);