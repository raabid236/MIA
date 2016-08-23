%Medical Image Analysis
%Lab Report 2
%Author: Raabid Hussain

%This file calculates the 3 parameters for each image and algorithm using
%the results for the best thresholds for each algorithm
%takes roughly 18 seconds to complete

close all;
clear;
clc;

tic

%reading all images separately
Imgnd=imread('examples\manual\rdb005ll.tif');
%size of images
[m,n]=size(Imgnd);
%normalizing ground truth images
Imgnd(:,:,1)=imread('examples\manual\rdb005ll.tif')/255;
Imgnd(:,:,2)=imread('examples\manual\rdb023ll.tif')/255;
Imgnd(:,:,3)=imread('examples\manual\rdb025ll.tif')/255;
Imgnd(:,:,4)=imread('examples\manual\rdb028rl.tif')/255;
%applying best threshold for each algorithm
%Algo1 images
Im(:,:,1)=im2bw(imread('examples\alg1\rdb005ll.tif'),2/255);
Im(:,:,2)=im2bw(imread('examples\alg1\rdb023ll.tif'),2/255);
Im(:,:,3)=im2bw(imread('examples\alg1\rdb025ll.tif'),2/255);
Im(:,:,4)=im2bw(imread('examples\alg1\rdb028rl.tif'),2/255);
%Algo2 images
Im(:,:,5)=im2bw(imread('examples\alg2\rdb005ll.tif'),90/255);
Im(:,:,6)=im2bw(imread('examples\alg2\rdb023ll.tif'),90/255);
Im(:,:,7)=im2bw(imread('examples\alg2\rdb025ll.tif'),90/255);
Im(:,:,8)=im2bw(imread('examples\alg2\rdb028rl.tif'),90/255);
%Algo3 images
Im(:,:,9)=im2bw(imread('examples\alg3\rdb005ll.tif'),4/255);
Im(:,:,10)=im2bw(imread('examples\alg3\rdb023ll.tif'),4/255);
Im(:,:,11)=im2bw(imread('examples\alg3\rdb025ll.tif'),4/255);
Im(:,:,12)=im2bw(imread('examples\alg3\rdb028rl.tif'),4/255);
%Algo4 images
Im(:,:,13)=im2bw(imread('examples\alg4\rdb005ll.tif'),7/255);
Im(:,:,14)=im2bw(imread('examples\alg4\rdb023ll.tif'),7/255);
Im(:,:,15)=im2bw(imread('examples\alg4\rdb025ll.tif'),7/255);
Im(:,:,16)=im2bw(imread('examples\alg4\rdb028rl.tif'),7/255);
%Algo5 images
Im(:,:,17)=im2bw(imread('examples\alg5\rdb005ll.tif'),16/255);
Im(:,:,18)=im2bw(imread('examples\alg5\rdb023ll.tif'),16/255);
Im(:,:,19)=im2bw(imread('examples\alg5\rdb025ll.tif'),16/255);
Im(:,:,20)=im2bw(imread('examples\alg5\rdb028rl.tif'),16/255);
%Algo6 images
Im(:,:,21)=im2bw(imread('examples\alg6\rdb005ll.tif'),7/255);
Im(:,:,22)=im2bw(imread('examples\alg6\rdb023ll.tif'),7/255);
Im(:,:,23)=im2bw(imread('examples\alg6\rdb025ll.tif'),7/255);
Im(:,:,24)=im2bw(imread('examples\alg6\rdb028rl.tif'),7/255);

%calclate TP,TN,FP,FN for all 24 images
for cs=1:24
%initialize to zero
    TP=0;
    TN=0;
    FP=0;
    FN=0;
    val=mod(cs,4);
    if val==0
        val=4;
    end
    for i=1:m
        for j=1:n
            if Im(i,j,cs)==Imgnd(i,j,val)
                if Imgnd(i,j,val)==0
                    TN=TN+1;
                else
                    TP=TP+1;
                end
            else
                if Imgnd(i,j,val)==0
                    FP=FP+1;
                else
                    FN=FN+1;
                end
            end
        end
    end
    %calculating Jacard Index for each image separately
    JI(floor((cs/4)-0.1)+1,val)=TP/(FN+FP+TP);
    %calculating Dice Coefficient Similarity for each image separately
    DC(floor((cs/4)-0.1)+1,val)=2*TP/(2*TP+FN+FP);
    
    %calculating Hausdorf Distance
    %boundary extraction from the segmentation result volume
    I= Im(:,:,cs);
    I1=[];
    I2=I1;
    p=0;
    for i=2:m-1
        for j=2:n-1
            if(I(i,j)==1)
                %checking all 8 neighbours to determine if it is a
                %boundary or not
                if (I(i+1,j)==0 || I(i-1,j)==0 || I(i,j+1)==0 || I(i,j-1)==0 || I(i+1,j+1)==0 || I(i+1,j-1)==0 || I(i-1,j-1)==0 || I(i-1,j+1)==0)
                        p=p+1;
                        %saving position of boundaries
                        I1(p,:)=[i,j];
                    end
            end
        end
    end
    
    %boundary extraction from the ground truth volume
    I=Imgnd(:,:,val);
    q=0;
    for i=2:m-1
        for j=2:n-1
            if(I(i,j)==1)
                %checking all 8 neighbours to determine if it is a
                %boundary or not
                if (I(i+1,j)==0 || I(i-1,j)==0 || I(i,j+1)==0 || I(i,j-1)==0 || I(i+1,j+1)==0 || I(i+1,j-1)==0 || I(i-1,j-1)==0 || I(i-1,j+1)==0)
                    q=q+1;
                    %saving position of boundaries
                    I2(q,:)=[i,j];
                end
            end
        end
    end   
    
    %initializations of distance
    sm1=ones(p,1)*m*n;
    sm2=ones(q,1)*m*n;

    %calculating minimum disance for every point for V1 against V2
    %minimum distance for all boundary points
    for i=1:p
        for j=1:q
            dist=sqrt((I1(i,1)-I2(j,1)).^2+(I1(i,2)-I2(j,2)).^2);
            if dist<sm1(i)
                sm1(i)=dist;
            end
        end
    end

    %calculating minimum disance for every point for V2 against V1
    %initializations
    for i=1:q
        for j=1:p
            dist=sqrt((I2(i,1)-I1(j,1)).^2+(I2(i,2)-I1(j,2)).^2);
            if dist<sm2(i)
                sm2(i)=dist;
            end
        end
    end

    %calculating maximum distance for each image and comparisons
    HD1=[max(sm1) max(sm2)];
    HD(floor((cs/4)-0.1)+1,val)=max(HD1);
end
%printing the results for the three parameters for each image
%colums=images
%rows=algorithms
JI
DC
HD

toc