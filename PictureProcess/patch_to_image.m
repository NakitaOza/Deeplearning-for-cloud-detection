function [stack] = patch_to_image(OGImagePath,PatchDir,patch, categorical)

% TEST PATCH CONCAT

inputFullImage = imread(OGImagePath);
sizeI = size(inputFullImage);
disp(sizeI)
cols = sizeI(2);
rows = sizeI(1);
numberOfPatchesInRow = ceil(cols/patch)
numberOfPatchesInCol = ceil(rows/patch)
disp(numberOfPatchesInCol);
disp(numberOfPatchesInRow);
imds_test = imageDatastore(PatchDir);

stack=[];
row= [];
count = numberOfPatchesInCol * numberOfPatchesInRow;
disp(count);

for i = 1: count
    if categorical
        numberOfDigitsInStr = num2str(numel(num2str(count)));
        format = ['%0' numberOfDigitsInStr '.f'];
        filePath = [PatchDir '_' num2str(i,format) '.png'];
    else
        filename = sprintf('%03d.jpg', i);
        filePath = [PatchDir filename];
    end

    disp(filePath);

    if(isfile(filePath))
        img_to_read = imread(filePath);
        if categorical
            img_to_read = img_to_read == 1;
        end

    else
        disp('deleted patch');
        checkImageProprties = readimage(imds_test, 1);
        dimensions = ndims(checkImageProprties);
        if dimensions > 2
            size_of_patch = size(checkImageProprties);
            img_to_read = zeros(patch, patch, size_of_patch(3));
        else
            img_to_read = zeros(patch, patch);
        end
    end
    size(row);
    size(img_to_read);
    row = [row  img_to_read];
    if(rem(i,numberOfPatchesInRow)==0)
        disp(i);
        stack = [stack; row];
        row = [];
    end
end


figure
imshowpair(inputFullImage, stack,'montage')
%imwrite([inputFullImage stack], [PatchDir 'result.TIF'], 'tif');
