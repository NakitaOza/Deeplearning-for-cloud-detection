function [index] = Delete_All_0_Pic(Trainpath,Labelpath)
% This function is used to delete pictures whose pixels are all 0 due to cropping to improve training efficiency
%   Author: Cheng Xin, Ocean University of China, Email: chengxin@stu.ouc.edu.cn
%    TrainPath: training image path
%    LabelPath: Label path
%    index: record deleted file name

Traindata=dir(fullfile(Trainpath,'*.jpg'));
TraindataName = { Traindata . name };
Labeldata = dir(fullfile(Labelpath, '*.jpg'));
LabeldataName = { Labeldata . name };
num=size(TraindataName);
num = num ( 2 );
index={};
for i=1:num
    Picturename=[Trainpath,TraindataName{i}];
    LabelName = [Labelpath,LabeldataName{i}];
    img=imread(Picturename);
    if(~sum(sum(sum(img))))
        index=[index,TraindataName{i}];
        delete(Picturename);
        delete(LabelName);
    end
    if(~mod(i,100))
        disp(['Processing ',num2str(i),'/',num2str(num)]);
    end
end
disp('Finished!');
end