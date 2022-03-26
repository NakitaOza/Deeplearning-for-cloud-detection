function [index] = Patch_to_num(patch,inputimage,Outputimagedir,index)
% Slice the data image in .tif format and the label image with the specified size

%   Author: Cheng Xin, Ocean University of China, Email: chengxin@stu.ouc.edu.cn

%    patch: slice size
%    inputimage: input image path
%    inputlabel: input mask label path
%    Outputimagedir: output image path
%    Outputlabeldir: Output mask label path
%    index: The index of the starting output image

%    loadtiff() function, please download it with matlab additional functions
A=loadtiff(inputimage);
% B=loadtiff(inputlabel);
C=size(A);
C2=size(A);
% D=size(size(B));
D = [1 2];
if(C(3)==4 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
% UNnecessary conversion as this will be done in the input file
%     A = uint8 ( A );
%     B=uint8(B);
    row=C(1);
    col = C ( 2 );
    if(mod(row,patch))
        row=ceil(row/patch)*patch;
    end
    if(mod(col,patch))
        col=ceil(col/patch)*patch;
    end
    rgbn=uint8(zeros([row,col,4]));
    rgbn(1:C(1),1:C(2),:)=A;
    rgb=rgbn(:,:,[3,2,1]);
    ngb = rgbn ( : , : , [ 4 , 2 , 1 ]);
%     mask=uint8(zeros([row,col]));
%     mask(1:C(1),1:C(2))=B;
    for i=1:(row/patch)
        for j=1:(col/patch)
            Outputrgb=rgb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
            Outputngb=ngb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
%             Outputlabel=mask(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch);
            imwrite(Outputrgb,[Outputimagedir,num2str(index),'.jpg']);
%             imwrite(Outputlabel,[Outputlabeldir,num2str(index),'.jpg']);
            imwrite(Outputngb,[Outputimagedir,num2str(index),'_ngb','.jpg']);
%             imwrite(Outputlabel,[Outputlabeldir,num2str(index),'_ngb','.jpg']);
            index = index + 1;
        end
    end
    disp('SUCCESSFUL!&&Channel=4')
else if(C(3)==3 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
        A = uint8 ( A ); %check if input image has values between 0 and 255. Only then this will work.
%         B=uint8(B);
        row=C(1);
        disp(row);
        col = C ( 2 );
        disp(col);
        disp(patch)
        if(mod(row,patch))
            disp('mod is for row')
            row=ceil(row/patch)*patch;
        end
        if(mod(col,patch))
            disp('mod is for col')
            col=ceil(col/patch)*patch;
        end
        X = sprintf('Row %d will be Col %d this year.',row,col);
        disp(X)
        rgb=uint8(zeros([row,col,3]));
        rgb(1:C(1),1:C(2),:)=A;
%         mask=uint8(zeros([row,col]));
%         mask(1:C(1),1:C(2))=B;
        disp(size(rgb));
%         disp(size(mask));
        Z = sprintf('row/patch %d will be Col/patch %d this year.',row/patch,col/patch);
        disp(Z);
        for i=1:(row/patch)
            for j=1:(col/patch)
                Outputrgb=rgb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
%                 Outputlabel=mask(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch);
                disp(num2str(index))
                imwrite(Outputrgb,[Outputimagedir,num2str(index),'.jpg']);
%                 imwrite(Outputlabel,[Outputlabeldir,num2str(index),'.jpg']);
                index = index + 1;
            end
        end
        disp('SUCCESSFUL!&&Channel=3')
    else
        disp('ERROR FORMAT!!!')
    end
    
end
end