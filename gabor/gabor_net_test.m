%% Create Array of Layers
layers_test = [
    imageInputLayer([512 512 3],"Name","imageinput","Normalization","rescale-zero-one")
    convolution2dLayer([3 3],64,"Name","conv_gabor","Padding","same", ....
    'WeightsInitializer', @(sz) gabor_kernel(sz,scale))
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")];

%% Plot Layers
plot(layerGraph(layers_test));


%% Function Handle for Gabor Filter
function weights = gabor_kernel(sz,scale)

% If not specified, then use default scale = 0.1
if nargin < 2
    scale = 0.1;
end

filterSize = [sz(1) sz(2)];
numChannels = sz(3);
numIn = filterSize(1) * filterSize(2) * numChannels;

varWeights = 2 / ((1 + scale^2) * numIn);
weights = randn(sz) * sqrt(varWeights);

end

