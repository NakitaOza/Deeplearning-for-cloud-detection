% https://www.sciencebase.gov/catalog/item/60536863d34e7eb1cb3ebfb1  - FOR
% VALIDAITON DATASET FOR LANSAT 8
% https://se.mathworks.com/matlabcentral/answers/48171-how-to-fuse-r-g-b-components#answer_58856
%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

raw_data_dir = 'data\RGBN_raw\';

inputRGBNPath = 'data\inputRGBN\';
inputLabelPath = 'data\inputLabel\';
TrainPatchPath = 'data\trainPatch\';
LabelPatchPath = 'data\labelPatch\';

UTrainPatchPath = 'data\trainPatchU\';
ULabelPatchPath = 'data\labelPatchU\';

validationTrainInput = 'data\validationInput\';
validationLabelInput = 'data\validationLabel\';
validationTrainPatch = 'data\validationInputPatch\';
validationLabelPatch = 'data\validationLabelPatch\';

UvalidationTrainPatch = 'data\validationInputPatchU\';
UvalidationLabelPatch = 'data\validationLabelPatchU\';

testInput = 'data\testInput\';
testLabel = 'data\testInput\';
testPatch = 'data\testPatch\';
predcitTestBinary = 'data\predictTestBinary\';
testLabelPatch = 'data\testPatch\';
patch = 512

%% CONCAT RGB IMAGES INTO ONE IMAGE

imDir = fullfile(raw_data_dir,'c_*.TIF');
imds = imageDatastore(imDir);
%img_nir = apply gbaor (readimage(imds,4))
img_in_uint16 = cat(4, readimage(imds,1), readimage(imds,2), readimage(imds,3), img_nir);
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
% % 
% imshow(img_in);
% 
imwrite(img_in, [inputRGBNPath 'c.TIF'], 'tif');

%imwrite(img_in, [validationTrainInput 'b.TIF'], 'tif')
% testImage = imread("data\testInput\test_j.jpeg");
% disp(size(testImage))
% imwrite(testImage, [testInput 'test.TIF'], 'tif');

%% GENERATE PATCHES

%train_label(inputRGBNPath,inputLabelPath,TrainPatchPath,LabelPatchPath,patch);
%train_label(validationTrainInput,validationLabelInput,validationTrainPatch,validationLabelPatch,patch);
train_label(testInput,testPatch,patch);

%% DELETE EMPTY TRAINING DATA (ALL BLACK)

%Delete_All_0_Pic(TrainPatchPath,LabelPatchPath);
%Delete_All_0_Pic(validationTrainPatch,validationLabelPatch);
Delete_All_0_Pic(testPatch);

%% TEST STUFF
img_patch_file_list = dir(fullfile(TrainPatchPath,'*.jpg'));
img_patch_file_list_names = { img_patch_file_list . name };
img_patch = imread(img_patch_file_list_names{1});
size(img_patch) % PATCH SIZE  = 128 * 128 * 3

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
testOGImage = imread('winterKTH.jpeg');   %THIS IS A TRAIN PATCH
disp(size(testOGImage));
targetSize = [128 128];
testImage = imresize(testOGImage,targetSize);

imshow(testImage)

%% PREDICT - INPUT IMAGES
testImage = imread("data\trainPatch\202.jpg");
disp(size(testImage));
C = semanticseg(testImage,mscff_net_u8);
B = labeloverlay(testImage,C);
max(testImage, [], 'all');

% cloudMask = C == 'cloud';
% 
% figure
% imshowpair(testOGImage, cloudMask,'montage')

%% PREDICT - DATA STORE FOR ONE IMAGE

% first create patches using section 1,2(KTH images are already 3 channel),3 and 4

imds_test = imageDatastore(testPatch);
tempdir = 'data\predictTest\';

% testLabelDir = fullfile(dataDir,'testLabels');
% classNames = ["triangle" "background"];
% pixelLabelID = [255 0];
% pxdsTruth = pixelLabelDatastore(testLabelDir,classNames,pixelLabelID);

pxdsResults = semanticseg(imds_test,uc_net_kth_8epochs_3inps,'MiniBatchSize',1,'ExecutionEnvironment','gpu', ...
    'WriteLocation',tempdir,'NamePrefix','');

%% SHOW FINAL RESULTS
% inimg = imread([testInput 'test.tif']);
% imshow(inimg);
output = patch_to_image([testInput 'test_j.jpeg'], tempdir, 512, true);
imwrite(output, 'data\result_test_j.jpg');
%% TRY TO VISUALIZE THIS

% I = read(imds_test);
% C = read(pxdsResults);
% categories(C{1})
% B = labeloverlay(I,C{1});
% figure
% imshow(B)
TestImageToPredictList = readall(imds_test);
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
    imwrite(cloudMask,[predcitTestBinary num2str(count) '_p.png']);
    count = count + 1;
end

imout = imtile(TestImageToPredictList);
imout2 = imtile()

%% LETS TRY TRANSFORM
a_old = read(pxdsResults)
new_pxds = transform(pxdsResults,@(x) ismember( x, 'cloud' ));
a_new = read(new_pxds)
