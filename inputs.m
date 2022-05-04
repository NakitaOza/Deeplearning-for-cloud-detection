%% INPUT AND PATCH DATA DIRECTORIES - DECLARE

inputRGBNPath = 'data\inputRGBN\gaborNIR\';
inputLabelPath = 'data\inputLabel\';

TrainPatchPath = 'data\trainPatch\';
LabelPatchPath = 'data\labelPatch\';

validationTrainInput = 'data\validationInput\gaborNIR\';
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

%% Match intensity of RGB with GbaorNIR, discard if does not match

% matchGaborWithRGB(TrainPatchPath);

%% NETWORK

networkVarSaveDir = 'trainedNetworks\';

imagesize = [patch patch 4];

[MSCFF_GaborNIR_NewWin_e8_noRepeat_noLabel2, log] = MSCFF_V2(imagesize,TrainPatchPath,LabelPatchPath,validationTrainPatch,validationLabelPatch);
netName = getVarName(MSCFF_GaborNIR_NewWin_e8_noRepeat_noLabel2)

save ([networkVarSaveDir netName],netName);




%% GET NAME OF VARIABLE

function name = getVarName(var)
    name = inputname(1);
end