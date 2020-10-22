coins=importdata('coins2.jpeg');
height= size(coins,1);
width= size(coins,2);
subplot 231

imshow(coins);

img_gray=zeros(height,width);

for i=1:height
    for j=1: width
        img_gray(i,j)=mean(coins(i,j,:))/255;
    end
end
subplot 232
imshow (img_gray)
subplot 233
histogram (img_gray)

img_bw=zeros(height, width);
bw_thres=0.4;


for i=1:height
    for j=1: width
        if img_gray(i,j)<bw_thres
        img_bw(i,j)=1;
        end
    end
end

subplot 234
imshow(img_bw)
%% Filter image
img_bwfilt=zeros(height,width);
wsize=31;
window=ones(wsize);
hwsize=floor(wsize/2);
scale=sum(sum(window));
%window=window/scale;
for i=hwsize+1:height-hwsize
    for j=hwsize+1:width-hwsize
        img_bwfilt(i,j)=median(median(img_bw(i-hwsize:i+hwsize,j-hwsize:j+hwsize).*window));
    end
end
subplot 235
imshow(img_bwfilt)

%% Detect edges
img_edgev=abs(diff(img_bwfilt,1,1));
img_edgeh=abs(diff(img_bwfilt,1,2));

eheight=size(img_edgev,1);
ewidth=size(img_edgeh,2);

img_edge=img_edgeh(1:eheight,:) | img_edgev(:,1:ewidth);
subplot 236
imshow(img_edge)

%% Detect size
up_margin=90;
bar_size=100;
indexes=[];
for i=1:up_margin
    if size(find(img_edge(i,:)),2)==2
        indexes=[indexes; find(img_edge(i,:))];
    end
end
pixel_size=mean(diff(indexes,1,2));
mm_per_pixel=bar_size/pixel_size;

%% Detect objects (Connected component labeling algorithm)
[img_label,elements_list,number_elements]=labelSegmentsBW(img_bwfilt, up_margin);

%% Obtain coin size (circle assumption)
sizes=zeros(number_elements,3); %Pixels per label, Area, diameter

for u=1:number_elements 
    for i=2:size(img_label,1)-1
        for j=2:size(img_label,2)-1
            if img_label(i,j)==elements_list(u)
                sizes(u,1)=sizes(u)+1;
            end
        end
    end
end

mm2_per_pixel=mm_per_pixel*mm_per_pixel;
for u=1:number_elements
    sizes(u,2)=sizes(u,1)*mm2_per_pixel;
    sizes(u,3)=2*sqrt(sizes(u,2)/pi);
end

%% Coins value count
coins_data=zeros(4,3); % Coins of each denomination, avg size, %error
real_sizes=[1 21;2 23;5 25;10 28];

for i=1:length(real_sizes)
    for j=1:number_elements
        if (sizes(j,3)>0.95*real_sizes(i,2) && sizes(j,3)<1.05*real_sizes(i,2))
            coins_data(i,1)=coins_data(i,1)+1;
            coins_data(i,2)=(sizes(j,3)+(coins_data(i,1)-1)*coins_data(i,2))/coins_data(i,1);
        end
    end
end
for i=1:length(real_sizes)
    coins_data(i,3)=100*abs(real_sizes(i,2)-coins_data(i,2))/real_sizes(i,2);
end

total=0;
for i=1:length(real_sizes)
    total=total+coins_data(i,1)*real_sizes(i,1);
end
fprintf('The total is %d MXN \n', total)

    


