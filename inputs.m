%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

inputRGBNPath = 'data\inputRGBN\';
inputLabelPath = 'data\inputLabel\';

TrainPatchPath = 'data\trainPatch\';
LabelPatchPath = 'data\labelPatch\';

validationTrainInput = 'data\validationInput\';
validationLabelInput = 'data\validationLabel\';

validationTrainPatch = 'data\validationInputPatch\';
validationLabelPatch = 'data\validationLabelPatch\';

testInput = 'data\testInput\';
testPatch = 'data\testPatch\';

patch = 512

%% GENERATE PATCHES - TRAINING DATA AND VALIDATION DATA

train_label(inputRGBNPath,inputLabelPath,TrainPatchPath,LabelPatchPath,patch);
train_label(validationTrainInput,validationLabelInput,validationTrainPatch,validationLabelPatch,patch);


%% DELETE EMPTY TRAINING AND VALIDATION DATA (ALL BLACK)

Delete_All_0_Pic(TrainPatchPath,LabelPatchPath);
Delete_All_0_Pic(validationTrainPatch,validationLabelPatch);

%% NETWORK

networkVarSaveDir = 'trained Networks\';

imagesize = [patch patch 4];

[mscff_net_u8, log] = MSCFF_V2(imagesize,TrainPatchPath,LabelPatchPath,validationTrainPatch,validationLabelPatch);
netName = getVarName(mscff_net_u8)

save ([networkVarSaveDir netName],netName);










%% GET NAME OF VARIABLE

function name = getVarName(var)
    name = inputname(1);
end