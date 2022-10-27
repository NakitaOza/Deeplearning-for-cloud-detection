# 基于深度学习的遥感影像云区检测模型

The MSCFF_V2 model is a fully convolutional neural network model, referring to the paper "Li, Z., Shen, H., Cheng, Q., Liu, Y., You, S., He, Z., 2019. 
Deep learning based cloud detection for medium and high resolution remote sensing images of different sensors. ISPRS Journal of Photogrammetry and Remote Sensing.
 150, 197–212”. MSCFF_V2 modifies the expansion rate of the convolution kernel in the atrous convolution in the MSCFF model of the paper, and rebuilds the model based on Matlab Deep Learning Toolbox 14.0.
![MSCFF_V2](https://gitee.com/CHENGXIN0219/Deeplearning-for-cloud-detection/raw/master/imgs/MSCFF_V2.png)

The UCD-Net model is a fully convolutional neural network model, referring to the paper "Ronneberger, O., P. Fischer and T. Brox, U-Net: Convolutional Networks 
for Biomedical Image Segmentation. 2015". The UCD-Net model modifies the U-Net model of the paper, adding a Batch Normalization layer, modifying the convolution 
mode to the same, and modifying the bilinear interpolation upsampling layer to a transposed convolution layer for upsampling.
![UCD-Net](https://gitee.com/CHENGXIN0219/Deeplearning-for-cloud-detection/raw/master/imgs/UCD-Net%20.png)

The PictureProcess folder gives the batch program for data set production, which can produce remote sensing images into input images of specified size for model 
training. The train_label function can batch all images in the folder by calling the Patch_to_num function.
