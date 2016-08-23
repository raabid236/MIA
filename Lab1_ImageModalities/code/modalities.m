% Medical Image Analysis Lab 1
% Image Modalities
% Author: Raabid Hussain
%The code is written in order provided in the lab manual
%Note: Paste the images to read in the folder containing this script file
%before running the code
close all;
clc;
clear;

% Reading DICOM images and displaying their information

%Ultrasound Images
img1=dicomread('ultrasound.DCM');
info1=dicominfo('ultrasound.DCM');
pixels1=info1.FileSize
width1=info1.Width
height1=info1.Height
row1=info1.Rows
column1=info1.Columns
name1=info1.PatientName
id1=info1.PatientID
dob1=info1.PatientBirthDate
sex1=info1.PatientSex
age1=info1.PatientAge
dimen1=info1.BitDepth
imshow(img1);
title('Ultrasound Image');

%MRI Images
figure;
img2=dicomread('MRI01.DCM');
info2=dicominfo('MRI01.DCM');
pixels2=info2.FileSize
width2=info2.Width
height2=info2.Height
row2=info2.Rows
column2=info2.Columns
size2=info2.PixelSpacing
slice2=info2.SliceThickness
name2=info2.PatientName
id2=info2.PatientID
dob2=info2.PatientBirthDate
sex2=info2.PatientSex
age2=info2.PatientAge
weight2=info2.PatientWeight
dimen2=info2.BitDepth
imshow(img2);
title('MRI Image');

%Mammography Images
figure;
img3=uint16(dicomread('MAMMOGRAPHY_RAW.DCM'));
info3=dicominfo('MAMMOGRAPHY_RAW.DCM');
pixels3=info3.FileSize
width3=info3.Width
height3=info3.Height
row3=info3.Rows
column3=info3.Columns
size3=info3.PixelSpacing
name3=info2.PatientName
id3=info2.PatientID
dob3=info2.PatientBirthDate
sex2=info2.PatientSex
age2=info2.PatientAge
dimen2=info2.BitDepth
imshow(img3);
title('Mammography Image');

%Working with MRI volume

%Reading the enitre volume (20 images) into a 3D array
MRI=zeros(512,512,20);
MRI(:,:,1)=dicomread('MRI01.DCM');
MRI(:,:,2)=dicomread('MRI02.DCM');
MRI(:,:,3)=dicomread('MRI03.DCM');
MRI(:,:,4)=dicomread('MRI04.DCM');
MRI(:,:,5)=dicomread('MRI05.DCM');
MRI(:,:,6)=dicomread('MRI06.DCM');
MRI(:,:,7)=dicomread('MRI07.DCM');
MRI(:,:,8)=dicomread('MRI08.DCM');
MRI(:,:,9)=dicomread('MRI09.DCM');
MRI(:,:,10)=dicomread('MRI10.DCM');
MRI(:,:,11)=dicomread('MRI11.DCM');
MRI(:,:,12)=dicomread('MRI12.DCM');
MRI(:,:,13)=dicomread('MRI13.DCM');
MRI(:,:,14)=dicomread('MRI14.DCM');
MRI(:,:,15)=dicomread('MRI15.DCM');
MRI(:,:,16)=dicomread('MRI16.DCM');
MRI(:,:,17)=dicomread('MRI17.DCM');
MRI(:,:,18)=dicomread('MRI18.DCM');
MRI(:,:,19)=dicomread('MRI19.DCM');
MRI(:,:,20)=dicomread('MRI20.DCM');

%Displaying the histogram of the entire volume of MRI
figure;
imhist(uint16(MRI(:)));
title('HISTOGRAM of MRI Data Set');

%Displaying different Anatomical Planes for MRI
%The two slices are displayed side by side to each other

%Axial plane
figure;
axial1=MRI(:,:,8);
axial2=MRI(:,:,12);
imshow(uint16([axial1, axial2]));
title('Axial Slices');

%Coronal Plane
figure;
coronal1=imresize(squeeze(MRI(:,200,:)),[512 194]);
coronal2=imresize(squeeze(MRI(:,300,:)),[512 194]);
imshow(uint16([coronal1 coronal2]));
title('Coronal Slices');

%Sagittal Slices
figure;
sagital1=imresize(squeeze(MRI(200,:,:))',[200 512]);
sagital2=imresize(squeeze(MRI(300,:,:))',[200 512]);
imshow(uint16([sagital1; sagital2]));
title('Sagital Slices');

%Image transformation for converting raw mammogram image to presentation
%version
%Reading and dispalying raw and presentation images
%Converting read images to the ones shown in lab manual
raw=2.^16-(double(dicomread('MAMMOGRAPHY_RAW.DCM')).*4);
raw=double(raw/2.^16);
figure;
imshow(raw);
title('Raw Mammography Image');
figure;
psn=im2uint16(dicomread('MAMMOGRAPHY_PRESENTATION.DCM')).*16;
imshow(psn);
title('Presentation Mammography Image');

%Image Transformations
%Unsharp masking
H = 1 - fspecial('gaussian' ,[5 5],2); % create unsharp mask
raw = imfilter(raw,H);  % create a sharpened version of the image using that mask
%Contrast Streching
raw=raw/max(max(raw));
raw=imadjust(raw);
%Gamma transform
raw=raw.^50;
%Sharpening the image
raw=imfilter(raw,fspecial('unsharp',0.5));
%Histogram Equalisation
raw=adapthisteq(raw);
%Displaying the transformed image
figure;
imshow((raw));
title('Transformed Mommography Image');

