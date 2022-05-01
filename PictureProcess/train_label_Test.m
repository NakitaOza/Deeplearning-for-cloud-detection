function [] = train_label_Test(Pathrgbn,testFileName, Outputimagedir,patch)


Filergbn = dir(fullfile(Pathrgbn, strcat(testFileName, '.tiff')));
FileNamesrgbn = {Filergbn.name};
filenum=size(FileNamesrgbn);
disp('job done 1');
if ~exist(Outputimagedir,'file')
    mkdir(Outputimagedir);
end
disp('job done 2');
index=1;
disp(filenum)
for i=1:filenum(2)
    disp('job done 3');
    inputimage=[Pathrgbn,FileNamesrgbn{i}];
    disp(['Processing ','No.',num2str(i),'/',num2str(filenum(2)),' Picture:',FileNamesrgbn{i}])
    disp(inputimage);
    index=Patch_to_num_Test(patch,inputimage,Outputimagedir,index);
end
disp('job done 4');
end