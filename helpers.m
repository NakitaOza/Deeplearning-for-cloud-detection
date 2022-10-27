%% CONCAT RGB IMAGES INTO ONE IMAGE

raw_data_dir = 'data\Final Data Used\inputRGBN\';
output_data_dit = 'data\Final Data Used\inputRGBN\NIR_tiff\'


% imDir = fullfile(raw_data_dir,'label*.tiff');
% imds = imageDatastore(imDir);
% %img_nir = apply gbaor (readimage(imds,4))
% img_in_uint16 = cat(4, readimage(imds,1), readimage(imds,2), readimage(imds,3), img_nir);
% if isa(img_in_uint16,'uint16')
%     disp('image is in uint16');
%     img_in = im2uint8(img_in_uint16);
% else
%     img_in = img_in_uint16;
% end
% imshow(img_in);

% img_b = imread(fullfile(raw_data_dir, "a_B.TIF"));
% img_g =  imread(fullfile(raw_data_dir, "a_G.TIF"));
% img_r =  imread(fullfile(raw_data_dir, "a_R.TIF"));
% img_in = cat(3, img_b, img_g, img_r);
% % 
% imshow(img_in);
% 
% imwrite(img_in, [inputRGBNPath 'c.TIF'], 'tif');

%imwrite(img_in, [validationTrainInput 'b.TIF'], 'tif')

testImage = imread([raw_data_dir 'label11.tiff']);
testNIRImage = testImage(: ,:, 4);
imwrite(testNIRImage, [output_data_dit 'label11.tiff'], 'tiff');

%% Check size of input Image

inputImage = imread([inputRGBNPath 'label2.tif']);
disp(size(inputImage));

%% TEST STUFF
img_patch_file_list = dir(fullfile(TrainPatchPath,'*.jpg'));
img_patch_file_list_names = { img_patch_file_list . name };
img_patch = imread(img_patch_file_list_names{1});
size(img_patch) % PATCH SIZE  = 128 * 128 * 3

%% TEST - INPUT IMAGES
testOGImage = imread('winterKTH.jpeg');   %THIS IS A TRAIN PATCH
disp(size(testOGImage));
targetSize = [128 128];
testImage1 = imresize(testOGImage,targetSize);

imshow(testImage1)

%% PREDICT - INPUT IMAGES
testImage1 = imread("data\trainPatch\202.jpg");
disp(size(testImage1));
C = semanticseg(testImage1,mscff_net_u8);
B = labeloverlay(testImage1,C);
max(testImage1, [], 'all');

% cloudMask = C == 'cloud';
% 
% figure
% imshowpair(testOGImage, cloudMask,'montage')

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

%% HELPERS


% testLabelDir = fullfile(dataDir,'testLabels');
% classNames = ["triangle" "background"];
% pixelLabelID = [255 0];
% pxdsTruth = pixelLabelDatastore(testLabelDir,classNames,pixelLabelID);

% inimg = imread([testInput 'test.tif']);
% imshow(inimg);

%% FILE CONVERIONS


for i = [3,5]
    a = imread(['data\validationInput\label' num2str(i) '.tiff']);
    imwrite(a(:,:,1:3),['data\validationInput\3d_tiff\label' num2str(i) '.tiff'], 'tiff');
end

%% BLOCKPROC FOR STICHING
f=dir('data\testLabelPatch\*.jpg')
files={f.name}
for k=1:numel(files)
  Im(k)=imread(files{k})
end
ImS = reshape(Im,1,1,36);
cell2mat(ImS);
%BI = zeros(1,1,36);
f = @(x) ImS(:,:,x.data);
Binary=blockproc( reshape(1:36,6,6)', [512,512], f );


%% % 
[counts,binLocations] = imhist(A);
imhist(B);

