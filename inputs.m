%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

inputRGBNPath = 'data\inputRGBN\gaborrgb\';
inputLabelPath = 'data\inputLabel\';

TrainPatchPath = 'data\trainPatch\';
LabelPatchPath = 'data\labelPatch\';

validationTrainInput = 'data\validationInput\gaborrgb\';
validationLabelInput = 'data\validationLabel\';

validationTrainPatch = 'data\validationInputPatch\';
validationLabelPatch = 'data\validationLabelPatch\';

testInput = 'data\testInput\';
testPatch = 'data\testPatch\';

patch = 512

%% GENERATE PATCHES - TRAINING DATA AND VALIDATION DATA
delete([TrainPatchPath '*']);
delete([LabelPatchPath '*']);

train_label(inputRGBNPath,inputLabelPath,TrainPatchPath,LabelPatchPath,patch);

delete([validationTrainPatch '*']);
delete([validationLabelPatch '*']);

train_label(validationTrainInput,validationLabelInput,validationTrainPatch,validationLabelPatch,patch);


%% DELETE EMPTY TRAINING AND VALIDATION DATA (ALL BLACK)

Delete_All_0_Pic(TrainPatchPath,LabelPatchPath);
Delete_All_0_Pic(validationTrainPatch,validationLabelPatch);

%% NETWORK

networkVarSaveDir = 'trainedNetworks\';

imagesize = [patch patch];

[UCDNET_Gabor_RGB_ONLY, log] = UCDNet(imagesize,TrainPatchPath,LabelPatchPath,validationTrainPatch,validationLabelPatch);

netName = getVarName(UCDNET_Gabor_RGB_ONLY)

save ([networkVarSaveDir netName],netName);
   



%% GET NAME OF VARIABLE

function name = getVarName(var)
    name = inputname(1);
end