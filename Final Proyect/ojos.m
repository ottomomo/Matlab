clear all;
clear variables;
close all;

I=imread('azules4.jpg');

% Eyes Detection
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);
figure,imshow(I);
rectangle('Position',BB(1:4),'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');
Eyes =imcrop(I,BB(1:4));
figure,imshow(Eyes);

Igray = rgb2gray(Eyes);
[centers,radii] = imfindcircles (Eyes, [fix(size(Igray,1)/8) fix(size(Igray,1)/3)],'ObjectPolarity','dark','Sensitivity',0.9);
viscircles(centers,radii);
Icrop = imcrop(Eyes,[centers(1,1)-radii(1) centers(1,2)-radii(1) radii(1)*2 radii(1)*2]);
figure();
imshow(Icrop);

% color=recogniseColor(Icrop,centers(1),radii(1));


