% is used to batch process the training images and label images in the folder as image slices of the specified size, and the Patch_to_num function needs to be called

%Author: Cheng Xin, Ocean University of China, Email: chengxin@stu.ouc.edu.cn

% Pathrgbn = 'RGB_Images_IN'
% Pathmask = "labelImages"
% Outputimagedir= "RGB_Images_OUT"
% Outputlabeldir= "labelImagesOUT"
% patch= [128 128]
% index: The starting index of the output image name, which is an optional parameter, the default is 1
% Note: To avoid mistakes, please name the training image and the corresponding label image with the same name
function [] = train_label(Pathrgbn,Outputimagedir,patch,index)


Filergbn = dir(fullfile(Pathrgbn,'winterKTH.jpeg'));
% Filermask =  dir ( fullfile ( Pathmask , '*.tif' ));
FileNamesrgbn = {Filergbn.name};
% FileNamesmask = {Filermask.name};
filenum=size(FileNamesrgbn);
disp('job done 1');
if ~exist(Outputimagedir,'file')
    mkdir(Outputimagedir);
end
% if ~exist(Outputlabeldir,'file')
%     mkdir(Outputlabeldir);
% end

disp('job done 2');

if(nargin==5 || nargin == 3)
    disp('job done 3');
    index=1;
    disp(filenum)
    for i=1:filenum(2)
        disp('job done 4');
%         if(strcmp(FileNamesmask{i},FileNamesrgbn{i}))
        inputimage=[Pathrgbn,FileNamesrgbn{i}];
%             inputlabel=r[Pathmask,FileNamesmask{i}];
        disp(['Processing ','No.',num2str(i),'/',num2str(filenum(2)),' Picture:',FileNamesrgbn{i}])
        index=Patch_to_num(patch,inputimage,Outputimagedir,index);
%         else
% %             disp ([ ' The system will ' ,FileNamesrgbn{ i }, ' corresponds to ' ,FileNamesmask{ i }, ' . ' ])
%             disp ( ' The image does not correspond to the label, it is recommended to unify the naming. ' )
%             break;
%         end
    end
elseif ( nargin == 6 )
    disp('job done 5');
    for i=1:filenum(2)
        disp('job done 6');
%         if(strcmp(FileNamesmask{i},FileNamesrgbn{i}))
        inputimage=[Pathrgbn,FileNamesrgbn{i}];
%             inputlabel=[Pathmask,FileNamesmask{i}];
        disp(['Processing ','No.',num2str(i),'/',num2str(filenum(2)),' Picture:',FileNamesrgbn{i}])
        index=Patch_to_num(patch,inputimage,Outputimagedir,index);
%             
%         else
%             disp ([ ' The system will ' ,FileNamesrgbn{ i }, ' corresponds to ' ,FileNamesmask{ i }, ' . ' ])
%             disp ( ' The image does not correspond to the label, it is recommended to unify the naming. ' )
%             break;
%         end
    end
else
    disp('job done 7');
    disp ( ' The input parameter is incorrect. ' )
end
end