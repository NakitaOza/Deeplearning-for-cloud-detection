% https://www.sciencebase.gov/catalog/item/60536863d34e7eb1cb3ebfb1  - FOR
% VALIDAITON DATASET FOR LANSAT 8
% https://se.mathworks.com/matlabcentral/answers/48171-how-to-fuse-r-g-b-components#answer_58856
%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

raw_data_dir = 'data\RGBN_raw\';

inputRGBNPath = 'data\winter\inputRGBN\';
inputLabelPath = 'data\winter\inputLabel\';
UTrainPatchPath = 'data\trainPatchU\';
ULabelPatchPath = 'data\labelPatchU\';

validationTrainInput = 'data\validationInput\';
validationLabelInput = 'data\validationLabel\';
UvalidationTrainPatch = 'data\validationInputPatchU\';
UvalidationLabelPatch = 'data\validationLabelPatchU\';

testInput = 'data\testInput\';
testLabel = 'data\testInput\';
testPatch = 'data\testPatch\';
predcitTestBinary = 'data\predictTestBinary\';
testLabelPatch = 'data\testPatch\';
patch = 512


%% GENERATE PATCHES - UCDNet

Utrain_label(inputRGBNPath,inputLabelPath,UTrainPatchPath,ULabelPatchPath,patch);
Utrain_label(validationTrainInput,validationLabelInput,UvalidationTrainPatch,UvalidationLabelPatch,patch);


%% DELETE EMPTY TRAINING DATA (ALL BLACK)

UDelete_All_0_Pic(UTrainPatchPath,ULabelPatchPath);
UDelete_All_0_Pic(UvalidationTrainPatch,UvalidationLabelPatch);

%% TEST STUFF
img_patch_file_list = dir(fullfile(UTrainPatchPath,'*.jpg'));
img_patch_file_list_names = { img_patch_file_list . name };
img_patch = imread(img_patch_file_list_names{1});
size(img_patch); % PATCH SIZE  = 512 * 512

%% UCD-NET

%function [net,log] = UCDNet(imagesize,imageDir,labelDir,imageDirV,labelDirV)

% imagesize: The size of the imageinput,which format is a vector of 1X3
% imageDir: Training data set folder path
% labelDir: Label data set folder path
% imageDirV: Validation data set folder path
% labelDirV: Validation-label data set folder path

imagesize = [512 512 4];

[mscff_kth_NIR_83_Full, log4] = MSCFF_V2(imagesize,UTrainPatchPath,ULabelPatchPath,UvalidationTrainPatch,UvalidationLabelPatch);

save mscff_kth_NIR_83_Full

%% TEST - INPUT IMAGES
testOGImage = imread('winterKTH.jpeg');   %THIS IS A TRAIN PATCH
disp(size(testOGImage));
targetSize = [512 512];
testImage = imresize(testOGImage,targetSize);

imshow(testImage)

%% PREDICT - INPUT IMAGES
testImage = imread("winterKTH.jpeg");
disp(size(testImage));
% C = semanticseg(testImage,uc_net);
% B = labeloverlay(testImage,C);
% %max(testImage, [], 'all');
% 
% cloudMask = C == 'cloud';
% % 
% figure
% imshowpair(testImage, cloudMask,'montage')

%% PREDICT - DATA STORE FOR ONE IMAGE - PATCH AND PREDICT

% first create patches using section 1,2(KTH images are already 3 channel),3 and 4

imds_test = imageDatastore(testPatch);
tempdir = 'data\predictTest\';

% testLabelDir = fullfile(dataDir,'testLabels');
% classNames = ["triangle" "background"];
% pixelLabelID = [255 0];
% pxdsTruth = pixelLabelDatastore(testLabelDir,classNames,pixelLabelID);

pxdsResults = semanticseg(imds_test,uc_net_kth_8epochs_3inps,'MiniBatchSize',1,'ExecutionEnvironment','gpu','WriteLocation',tempdir);

%% TRY TO VISUALIZE THIS - CONVERT PERDICTION TO MASK - OR DO USING PATCH_TO_IMAGE.M

% I = read(imds_test);
% C = read(pxdsResults);
% categories(C{1})
% B = labeloverlay(I,C{1});
% figure
% imshow(B)

PredictionList = readall(pxdsResults);

%The images in temp dir are correct. But they are categorical (1-cloud, 2-background)so they cant
%be seen. We need to imwrite it with 0 and 255 so that they are seen
%correctly. All the files need to be processed.
count=1
for i = 1:length(PredictionList) % loop through all your images to get the mask
    disp(['processing : ',i]);
    %mask image
    cloudMask = PredictionList{i} == 'cloud';
    %save new image
    imwrite(cloudMask,[predcitTestBinary num2str(count) '.jpg']);
    count = count + 1;
end

%% SHOW FINAL RESULTS
output = patch_to_image([testInput 'test.tif'], testPatch, 512, true);


%% TEST STUFF

%analyzeNetwork(mscff_net_u8);

% layer = 2;
% name = mscff_net_u8.Layers(layer).Name

channels = 1:3;
I = deepDreamImage(mscff_net_u8,'conv_1',channels, ...
    'PyramidLevels',1);

figure
I = imtile(I,'ThumbnailSize',[64 64]);
imshow(I)
title(['Layer ',name,' Features'],'Interpreter','none')

%act1 = activations(uc_net,testImage,'conv1');

%% TEST OUT NEW GABOR FIlter basics

testImageGray = rgb2gray(testImage);

wavelength = [5 pi 7];
orientation = [(1/4)*pi (2/4)*pi];
gamma = [0.5];
% sigma?? - gaussian säker
g = gabor(wavelength,orientation,'SpatialAspectRatio', gamma);
imshow(testImageGray);
outMag = imgaborfilt(testImageGray,g);

outSize = size(outMag);
outMag = reshape(outMag,[outSize(1:2),1,outSize(3)]);
figure, montage(outMag,'DisplayRange',[]);
title('Montage of gabor magnitude output images.');
