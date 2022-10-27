%% SELECT THE NETWORK

net = MSCFF_NIR_NewWin_e8_noRepeat;
netName = 'MSCFF_NIR_NewWin_e8_noRepeat'

testInput = 'Final Results\INPUTS\RGBNIR\';

testInputPatch = 'Final Results\PROCESSING\testInputPatch\';

testLabel = 'Final Results\LABELS\';

testLabelPatch = 'Final Results\PROCESSING\testLabelPatch\';

testFileName = 'scene3'

predictionDir = 'Final Results\PROCESSING\predictTest\';

imageResultDir = 'Final Results\PROCESSING\results\';

jpgDir = 'Final Results\JPEGS\';

patch = 512;

%% GENERATE PATCHES OF TEST INPUT

%empty the folder
delete([testInputPatch '*']);
delete([testLabelPatch '*']);
%train_label_Test(testInput,testFileName,testPatch,patch);
train_label(testInput,testFileName,testLabel,testInputPatch,testLabelPatch, patch);

%% DELETE EMPTY TEST PATCHES (ALL BLACK)

%Delete_All_0_Pic_Test(testPatch);
%Delete_All_0_Pic(testInputPatch,testLabelPatch);

%% PREDICT - DATA STORE FOR ONE IMAGE

%empty the folder
delete([predictionDir '*']);

% first create patches using section 1,2(KTH images are already 3 channel),3 and 4

imds_test = imageDatastore(testInputPatch);

tic
[pxdsResults] = semanticseg(imds_test, net,'MiniBatchSize',1,'ExecutionEnvironment','gpu','WriteLocation',predictionDir,'NamePrefix','');
toc
%% SHOW FINAL RESULTS

% convert predicted pacthes to complete image, show in pair and store the result.

% testFileName = 'winterKTH'; % IF LABEL3

output = patch_to_image([jpgDir testFileName '.jpg'], predictionDir, patch, true);

imwrite(output, [imageResultDir 'result_' testFileName '_' netName '.jpg']);

% montage({[imageResultDir 'result_winterKTH_uc_net_kth_8epochs_3inps.jpeg'],[imageResultDir 'result_winterKTH_uc_net_kth_NIR_83_Full.jpeg'],[imageResultDir 'result_' testFileName '_' netName '.jpeg'});


%% TEST

classNames = ["cloud" "background"];

labelIDs = [255 0];

pxdsTruth = pixelLabelDatastore(testLabelPatch,classNames,labelIDs);

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);

% %options: control the learning of the new algorithm
% options = trainingOptions('key', 'value', ...
%             );
% % Model training
% [trainedNetwork,log] = trainNetwork(trainingData,layers,options);
% 

