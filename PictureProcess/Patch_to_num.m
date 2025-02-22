function [index] = Patch_to_num(patch,inputimage,inputlabel,Outputimagedir,Outputlabeldir,index)
% Slice the data image in .tif format and the label image with the specified size

%   Author: Cheng Xin, Ocean University of China, Email: chengxin@stu.ouc.edu.cn

%    patch: slice size
%    inputimage: input image path
%    inputlabel: input mask label path
%    Outputimagedir: output image path
%    Outputlabeldir: Output mask label path
%    index: The index of the starting output image

%    loadtiff() function please download it with the matlab additional function
A=loadtiff(inputimage);
B=loadtiff(inputlabel);
C=size(A);
C2=size(B);
D=size(size(B));
E = size(size(A))
if(E(2) == 3 && C(3)==4 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
    A = uint8 ( A );
    B=uint8(B);
    row=C(1)
    col = C ( 2 )
    if(mod(row,patch))
        row=ceil(row/patch)*patch;
    end
    if(mod(col,patch))
        col=ceil(col/patch)*patch;
    end
    disp(row);
    disp(col);
    disp(patch);
    rgbn=uint8(zeros([row,col,4]));
    size(rgbn)
    rgbn(1:C(1),1:C(2),:)=A;
%     rgb=rgbn(:,:,[3,2,1]);
%     ngb = rgbn ( : , : , [ 4 , 2 , 1 ]);
    mask=uint8(zeros([row,col]));
    mask(1:C(1),1:C(2))=B;
    size(mask)
    for i=1:(row/patch)
        for j=1:(col/patch)
            Outputrgbn=rgbn(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
%             Outputrgb=rgb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
%             Outputngb=ngb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
            Outputlabel=mask(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch);
            disp(num2str(index))
            filename = sprintf('%03d', index);
            imwrite(Outputrgbn,[Outputimagedir,filename,'.tiff']);
%             imwrite(Outputrgb,[Outputimagedir,filename,'.jpg']);
            imwrite(Outputlabel,[Outputlabeldir,filename,'.jpg']);
%             imwrite(Outputngb,[Outputimagedir,filename,'_ngb','.jpg']);
%             imwrite(Outputlabel,[Outputlabeldir,filename,'_ngb','.jpg']);
            index = index + 1;
        end
    end
    disp('SUCCESSFUL!&&Channel=4')
else if(E(2) == 3 && C(3)==3 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
        A = uint8 ( A );
        B=uint8(B);
        row=C(1);
        col = C ( 2 );
        if(mod(row,patch))
            row=ceil(row/patch)*patch;
        end
        if(mod(col,patch))
            col=ceil(col/patch)*patch;
        end
        rgb=uint8(zeros([row,col,3]));
        rgb(1:C(1),1:C(2),:)=A;
        mask=uint8(zeros([row,col]));
        mask(1:C(1),1:C(2))=B;
        for i=1:(row/patch)
            for j=1:(col/patch)
                Outputrgb=rgb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
                Outputlabel=mask(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch);
                disp(num2str(index))
                filename = sprintf('%03d.jpg', index);
                imwrite(Outputrgb,[Outputimagedir,filename]);
                imwrite(Outputlabel,[Outputlabeldir,filename]);
                index = index + 1;
            end
        end
        disp('SUCCESSFUL!&&Channel=3')
 else if(E(2) == 2 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
        A = uint8 ( A );
        B=uint8(B);
        row=C(1);
        col = C ( 2 );
        if(mod(row,patch))
            row=ceil(row/patch)*patch;
        end
        if(mod(col,patch))
            col=ceil(col/patch)*patch;
        end
        nir=uint8(zeros([row,col]));
        size(nir)
        nir(1:C(1),1:C(2),:)=A;
        mask=uint8(zeros([row,col]));
        mask(1:C(1),1:C(2))=B;
        size(mask)
        for i=1:(row/patch)
            for j=1:(col/patch)
                Outputnir=nir(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
                Outputlabel=mask(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch);
                disp(num2str(index))
                filename = sprintf('%03d', index);
                imwrite(Outputnir,[Outputimagedir,filename,'.tiff']);
                imwrite(Outputlabel,[Outputlabeldir,filename,'.jpg']);
                index = index + 1;
            end
        end
        disp('SUCCESSFUL!&&Channel=1')
    else
        disp('ERROR FORMAT!!!')
    end
    
end
end