%% SELECT THE NETWORK

net = uc_net_kth_8epochs_3inps;
netName = 'uc_net_kth_8epochs_3inps'

testInput = 'data\testInput\';

testPatch = 'data\testPatch\';

testFileName = 'winterKTH';

predictionDir = 'data\predictTest\';

imageResultDir = 'data\results\';

patch = 512;

%% GENERATE PATCHES OF TEST INPUT

%empty the folder
delete([testPatch '*']);

train_label_Test(testInput,testFileName,testPatch,patch);

%% DELETE EMPTY TEST PATCHES (ALL BLACK)

Delete_All_0_Pic_Test(testPatch);

%% PREDICT - DATA STORE FOR ONE IMAGE

%empty the folder
delete([predictionDir '*']);

% first create patches using section 1,2(KTH images are already 3 channel),3 and 4

imds_test = imageDatastore(testPatch);

pxdsResults = semanticseg(imds_test, net,'MiniBatchSize',1,'ExecutionEnvironment','gpu','WriteLocation',predictionDir,'NamePrefix','');

%% SHOW FINAL RESULTS

% convert predicted pacthes to complete image, show in pair and store the result.

output = patch_to_image([testInput testFileName '.jpeg'], predictionDir, 512, true);

imwrite(output, [imageResultDir 'result_' testFileName '_' netName '.jpeg']);
