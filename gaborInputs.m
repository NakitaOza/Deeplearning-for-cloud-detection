%% CONCAT RGB IMAGES AND GABOR NIR INTO ONE IMAGE

raw_data_dir = 'data\gaborInputs\';
output_dir = 'data\inputRGBN\'


img_rgb = imread([raw_data_dir 'input1_RGB.jpeg']);
img_nir = imread([raw_data_dir 'input1_NIR.jpeg']);

img_gnir = getGaborImage(img_nir);
img_in = cat(3,img_rgb,img_gnir);
 
imwrite(img_in, 'gaborImageOutput.tiff', 'tiff');

%% TEST OUT NEW GABOR FIlter basics

function [gaborFImage] = getGaborImage(inputImage)
wavelength = [7];
orientation = [(2/4)*pi];
gamma = [0.5];
g = gabor(wavelength,orientation,'SpatialAspectRatio', gamma);
outMag = imgaborfilt(inputImage,g);
gaborFImage = uint8(outMag);
end


