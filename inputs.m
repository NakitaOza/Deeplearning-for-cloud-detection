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

imDir = fullfile(raw_data_dir,'b_*.TIF');
imds = imageDatastore(imDir);
img_in = cat(3, readimage(imds,1), readimage(imds,2), readimage(imds,3));
imshow(img_in);


imwrite(img_in, [inputRGBNPath 'a.TIF'], 'tif')

%imwrite(img_in, [validationTrainInput 'b.TIF'], 'tif')

%% GENERATE PATCHES

train_label(inputRGBNPath,inputLabelPath,TrainPatchPath,LabelPatchPath,patch)
%train_label(validationTrainInput,validationLabelInput,validationTrainPatch,validationLabelPatch,patch)

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

MSCFF_V2(imagesize,TrainPatchPath,LabelPatchPath,validationTrainPatch,validationLabelPatch);
