function [index] = Delete_All_0_Pic_Test(Testpatch)

TestData=dir(fullfile(Testpatch,'*.tiff'));
TestdataName = { TestData . name };
num=size(TestdataName);
num = num ( 2 );
index={};
for i=1:num
    Picturename=[Testpatch,TestdataName{i}];
    img=imread(Picturename);
    if(~sum(sum(sum(img))))
        index=[index,TestdataName{i}];
        delete(Picturename);
    end
    if(~mod(i,5))
        disp(['Processing ',num2str(i),'/',num2str(num)]);
    end
end
disp('Finished!');
end