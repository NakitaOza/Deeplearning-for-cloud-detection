% https://www.sciencebase.gov/catalog/item/60536863d34e7eb1cb3ebfb1  - FOR
% VALIDAITON DATASET FOR LANSAT 8
% https://se.mathworks.com/matlabcentral/answers/48171-how-to-fuse-r-g-b-components#answer_58856
%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

raw_data_dir = 'data\RGBN_raw\';
inputRGBNPath = 'data\inputRGBN\';
inputLabelPath = 'data\inputLabel\';
TrainPatchPath = 'data\trainPatch\';
LabelPatchPath = 'data\labelPatch\';
validationTrainInput = 'data\validationInput\';
validationLabelInput = 'data\validationLabel\';
validationTrainPatch = 'data\validationInputPatch\';
validationLabelPatch = 'data\validationLabelPatch\';
patch = 128

%% CONCAT RGB IMAGES INTO ONE IMAGE

imDir = fullfile(raw_data_dir,'a_*.TIF');
imds = imageDatastore(imDir);
img_in_uint16 = cat(3, readimage(imds,1), readimage(imds,2), readimage(imds,3));
if isa(img_in_uint16,'uint16')
    disp('image is in uint16');
    img_in = im2uint8(img_in_uint16);
else
    img_in = img_in_uint16;
end
imshow(img_in);

% img_b = imread(fullfile(raw_data_dir, "a_B.TIF"));
% img_g =  imread(fullfile(raw_data_dir, "a_G.TIF"));
% img_r =  imread(fullfile(raw_data_dir, "a_R.TIF"));
% img_in = cat(3, img_b, img_g, img_r);
% 
imshow(img_in);
imwrite(img_in, [inputRGBNPath 'a.TIF'], 'tif');

%imwrite(img_in, [validationTrainInput 'b.TIF'], 'tif')

%% GENERATE PATCHES

%train_label(inputRGBNPath,inputLabelPath,TrainPatchPath,LabelPatchPath,patch);
train_label(validationTrainInput,validationLabelInput,validationTrainPatch,validationLabelPatch,patch);

%% DELETE EMPTY TRAINING DATA (ALL BLACK)

Delete_All_0_Pic(TrainPatchPath,LabelPatchPath);
%Delete_All_0_Pic(validationTrainPatch,validationLabelPatch);

%% TEST STUFF
% img_patch_file_list = dir(fullfile(TrainPatchPath,'*.png'));
% img_patch_file_list_names = { img_patch_file_list . name };
% img_patch = imread(img_patch_file_list_names{1});
% size(img_patch) % PATCH SIZE  = 128 * 128 * 3

%% MSCFF
% imagesize: The size of the imageinput,which format is a vector of 1X3
% imageDir: Training data set folder path : TrainPatchPath
% labelDir: Label data set folder path : LabelPatchPath
% imageDirV: Validation data set folder path
% labelDirV: Validation-label data set folder path

imagesize = [128 128 3];

[mscff_net_u8, log] = MSCFF_V2(imagesize,TrainPatchPath,LabelPatchPath,validationTrainPatch,validationLabelPatch);

save mscff_net_u8

%% TEST - INPUT IMAGES
testOGImage = imread('202.jpg');   %THIS IS A TRAIN PATCH
disp(size(testOGImage));
%targetSize = [128 128];
%testImage = imresize(testOGImage,targetSize);

imshow(testOGImage)

%% PREDICT - INPUT IMAGES

C = semanticseg(testOGImage,mscff_net_u8);
B = labeloverlay(testOGImage,C);
imshow(B)

% cloudMask = C == 'cloud';
% 
% figure
% imshowpair(testOGImage, cloudMask,'montage')