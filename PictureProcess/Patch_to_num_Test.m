function [index] = Patch_to_num_Test(patch,inputimage,Outputimagedir,index)
A=loadtiff(inputimage);
C=size(A);
C2=size(A);
D = [1 2];
E = size(size(A))
if(E(2) == 3 && C(3)==4 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
% UNnecessary conversion as this will be done in the input file
    A = uint8 ( A );
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
    for i=1:(row/patch)
        for j=1:(col/patch)
            Outputrgbn=rgbn(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
            disp(num2str(index))
            filename = sprintf('%03d', index);
            imwrite(Outputrgbn,[Outputimagedir,filename,'.tiff']);
            index = index + 1;
        end
    end
    disp('SUCCESSFUL!&&Channel=4')
else if(E(2) == 3 && C(3)==3 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
        A = uint8 ( A ); %check if input image has values between 0 and 255. Only then this will work.
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
        for i=1:(row/patch)
            for j=1:(col/patch)
                Outputrgb=rgb(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
                disp(num2str(index))
                filename = sprintf('%03d.jpg', index);
                imwrite(Outputrgb,[Outputimagedir,filename]);
                index = index + 1;
            end
        end
        disp('SUCCESSFUL!&&Channel=3')
 else if(E(2) == 2 && D(2)==2 && C(1)==C2(1) && C(2)==C2(2))
        A = uint8 ( A );
        row=C(1)
        col = C ( 2 )
        if(mod(row,patch))
            row=ceil(row/patch)*patch;
        end
        if(mod(col,patch))
            col=ceil(col/patch)*patch;
        end
        nir=uint8(zeros([row,col]));
        nir(1:C(1),1:C(2),:)=A;
        mask=uint8(zeros([row,col]));
        for i=1:(row/patch)
            for j=1:(col/patch)
                Outputnir=nir(((i-1)*patch+1):i*patch,((j-1)*patch+1):j*patch,:);
                disp(num2str(index))
                filename = sprintf('%03d', index);
                imwrite(Outputnir,[Outputimagedir,filename,'.tiff']);
                index = index + 1;
            end
        end
        disp('SUCCESSFUL!&&Channel=1')
    else
        disp('ERROR FORMAT!!!')
    end
    
end
end