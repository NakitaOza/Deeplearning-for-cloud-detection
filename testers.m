%% SELECT THE NETWORK

net = MSCFF_RGB_NewWin_e8_noRepeat;
netName = 'MSCFF_RGB_NewWin_e8_noRepeat'

testInput = 'data\testInput\3d_tiff\';

testPatch = 'data\testPatch\';

testLabel = 'data\testLabel\';

testLabelPatch = 'data\testLabelPatch\';

testFileName = 'label5';

predictionDir = 'data\predictTest\';

imageResultDir = 'data\results\';

patch = 512;

%% GENERATE PATCHES OF TEST INPUT

%empty the folder
delete([testPatch '*']);
delete([testLabelPatch '*']);
%train_label_Test(testInput,testFileName,testPatch,patch);
train_label(testInput,testLabel,testPatch,testLabelPatch,patch);

%% DELETE EMPTY TEST PATCHES (ALL BLACK)

%Delete_All_0_Pic_Test(testPatch);
Delete_All_0_Pic(testPatch,testLabelPatch);

%% PREDICT - DATA STORE FOR ONE IMAGE

%empty the folder
delete([predictionDir '*']);

% first create patches using section 1,2(KTH images are already 3 channel),3 and 4

imds_test = imageDatastore(testPatch);

pxdsResults = semanticseg(imds_test, net,'MiniBatchSize',1,'ExecutionEnvironment','gpu','WriteLocation',predictionDir,'NamePrefix','');

%% SHOW FINAL RESULTS

% convert predicted pacthes to complete image, show in pair and store the result.

% testFileName = 'winterKTH'; % IF LABEL3

output = patch_to_image([testInput testFileName '.jpg'], predictionDir, 512, true);

imwrite(output, [imageResultDir 'result_' testFileName '_' netName '.jpg']);

% montage({[imageResultDir 'result_winterKTH_uc_net_kth_8epochs_3inps.jpeg'],[imageResultDir 'result_winterKTH_uc_net_kth_NIR_83_Full.jpeg'],[imageResultDir 'result_' testFileName '_' netName '.jpeg'});


%% TEST

classNames = ["cloud" "background"];

labelIDs = [255 0];

pxdsTruth = pixelLabelDatastore(testLabelPatch,classNames,labelIDs);

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);
