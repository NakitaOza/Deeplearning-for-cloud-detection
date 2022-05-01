%% CONCAT RGB IMAGES AND GABOR NIR INTO ONE IMAGE

% raw_data_dir = 'data\gaborInputs\';
% output_dir = 'data\inputRGBN\'
% 
% 
% img_rgb = imread([raw_data_dir 'label3_RGB.jpeg']);
% img_nir = imread([raw_data_dir 'label3_NIR.jpeg']);
% 
% img_gnir = getGaborImage(img_nir);
% % 
% % imshow(img_gnir);
% 
% % img_gnir_BW = imbinarize(img_gnir,0.5);
% % 
% % SE = strel("square",4); 
% % img_nir_filtered = imdilate(img_gnir_BW,SE);
% % img_nir_filtered = 255 - img_nir_filtered;
% img_in = cat(3,img_rgb,img_nir);
% 
% imwrite(img_in,[output_dir 'label3.tiff'], 'tiff');

img_patch_16 = imread('data\testInput\label2_or.tif');
img_patch = im2uint8(img_patch_16);
img_patch_b = img_patch(:,:,1); 
img_patch_g =img_patch(:,:,2);
img_patch_r =img_patch(:,:,3);
img_patch_nir =img_patch(:,:,4);
figure, montage(img_patch, []);

img_patch_b_g = getGaborImage(img_patch_b); 
img_patch_g_g =getGaborImage(img_patch_g);
img_patch_r_g =getGaborImage(img_patch_r);
img_patch_nir_g =getGaborImage(img_patch_nir);
figure, montage({img_patch_b_g, img_patch_g_g, img_patch_r_g img_patch_nir_g}, []);

%% TEST
testImage1 = imread([output_dir 'label1_test.tiff']);
testImage = testImage1(:,:,4);
%imshow(testImage);
BW = imbinarize(testImage,0.5);
imshowpair(testImage,BW,'montage');

SE = strel("square",4); 
Kmedian = imdilate(BW,SE);
imshowpair(BW,Kmedian,'montage')

%% TEST GABOR FILTER BANK


testImage1 = imread([output_dir 'label1_test.tiff']);
testImage = testImage1(:,:,4);
imshow(testImage);

wavelength = [8.5];
orientation = [45];
g = gabor(wavelength,orientation);

outMag = imgaborfilt(testImage,g);

outSize = size(outMag);
outMag = reshape(outMag,[outSize(1:2),1,outSize(3)]);
figure, montage(outMag,'DisplayRange',[]);
title('Montage of gabor magnitude output images.');

%% TEST OUT NEW GABOR FIlter basics

testImage1 = imread([output_dir 'label1_test.tiff']);
testImage = testImage1(:,:,4);
%imshow(testImage);
%testImage = rgb2gray(testImageRGB);
gaborOuput = getGaborImage(testImage,8.5,(1/4)*pi);
figure
montage({testImage,gaborOuput});
% % C = imfuse(testImage, gaborOuput, 'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % imshow(C);
% % 
function [gaborFImage] = getGaborImage(inputImage,wavelength,orientation)
wavelength = 7;
orientation = (2/4)*pi;
gamma = 0.5;
g = gabor(wavelength,orientation,'SpatialAspectRatio', gamma);
outMag = imgaborfilt(inputImage,g);
gaborFImage = uint8(outMag);
end