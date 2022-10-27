function [] = train_label(Pathrgbn,testFileName, Pathmask,Outputimagedir,Outputlabeldir,patch,index)
% is used to batch process the training images and label images in the folder as image slices of the specified size, and the Patch_to_num function needs to be called

%Author: Cheng Xin, Ocean University of China, Email: chengxin@stu.ouc.edu.cn

% Pathrgbn: training image folder path
% Pathmask: Label image folder path
% Outputimagedir: output training image folder path
% Outputlabeldir: Output label image folder path
% patch: tile size
% index: The starting index of the output image name, which is an optional parameter, the default is 1
% Note: To avoid mistakes, please name the training image and the corresponding label image with the same name


Filergbn = dir(fullfile(Pathrgbn, strcat(testFileName, '.tiff')));
Filermask =  dir ( fullfile (Pathmask, strcat(testFileName, '.tiff')));
FileNamesrgbn = {Filergbn.name};
FileNamesmask = {Filermask.name};
filenum=size(FileNamesrgbn);
disp('job done 1');

if ~exist(Outputimagedir,'file')
    mkdir(Outputimagedir);
end
if ~exist(Outputlabeldir,'file')
    disp('NOT FOUND MKDIR')
    mkdir(Outputlabeldir);
end



if(nargin==6)
    disp('job done 3');
    index=1;
    disp(filenum)
    for i=1:filenum(2)
        if(strcmp(FileNamesmask{i},FileNamesrgbn{i}))
            inputimage=[Pathrgbn,FileNamesrgbn{i}];
            inputlabel=[Pathmask,FileNamesmask{i}];
            disp(['Processing ','No.',num2str(i),'/',num2str(filenum(2)),' Picture:',FileNamesrgbn{i}])
            index=Patch_to_num(patch,inputimage,inputlabel,Outputimagedir,Outputlabeldir,index);
        else
            disp ([ ' The system will ' ,FileNamesrgbn{ i }, ' corresponds to ' ,FileNamesmask{ i }, ' . ' ])
            disp ( ' The image does not correspond to the label, it is recommended to unify the naming. ' )
            break;
        end
    end
elseif ( nargin == 7 )
    disp('job done 5');
    for i=1:filenum(2)
        if(strcmp(FileNamesmask{i},FileNamesrgbn{i}))
            inputimage=[Pathrgbn,FileNamesrgbn{i}];
            inputlabel=[Pathmask,FileNamesmask{i}];
            disp(['Processing ','No.',num2str(i),'/',num2str(filenum(2)),' Picture:',FileNamesrgbn{i}])
            index=Patch_to_num(patch,inputimage,inputlabel,Outputimagedir,Outputlabeldir,index);
            
        else
            disp ([ ' The system will ' ,FileNamesrgbn{ i }, ' corresponds to ' ,FileNamesmask{ i }, ' . ' ])
            disp ( ' The image does not correspond to the label, it is recommended to unify the naming. ' )
            break;
        end
    end
else
    disp ( ' The input parameter is incorrect. ' )
end
end