%Medical Image Analysis
%Lab Report 2
%Author: Raabid Hussain

%This file calculates the ROCs for all the 24 images
%and Area under Curve and best threshold for each algorithm
%(4 images x 6 algorithms)
%takes roughly 5 minutes 10 seconds to complete
%roughly 12 seconds per ROC

tic
%%rocs
close all;
clear;
clc;

%reading all images separately
Imgnd=imread('examples\manual\rdb005ll.tif');
%size of images
[m,n]=size(Imgnd);

%normalizing ground truth images
Imgnd(:,:,1)=im2bw(imread('examples\manual\rdb005ll.tif'),0.5);
Imgnd(:,:,2)=im2bw(imread('examples\manual\rdb023ll.tif'),0.5);
Imgnd(:,:,3)=im2bw(imread('examples\manual\rdb025ll.tif'),0.5);
Imgnd(:,:,4)=im2bw(imread('examples\manual\rdb028rl.tif'),0.5);
%Algo1 images
Im1(:,:,1)=imread('examples\alg1\rdb005ll.tif');
Im1(:,:,2)=imread('examples\alg1\rdb023ll.tif');
Im1(:,:,3)=imread('examples\alg1\rdb025ll.tif');
Im1(:,:,4)=imread('examples\alg1\rdb028rl.tif');
%Algo2 images
Im2(:,:,1)=imread('examples\alg2\rdb005ll.tif');
Im2(:,:,2)=imread('examples\alg2\rdb023ll.tif');
Im2(:,:,3)=imread('examples\alg2\rdb025ll.tif');
Im2(:,:,4)=imread('examples\alg2\rdb028rl.tif');
%Algo3 images
Im3(:,:,1)=imread('examples\alg3\rdb005ll.tif');
Im3(:,:,2)=imread('examples\alg3\rdb023ll.tif');
Im3(:,:,3)=imread('examples\alg3\rdb025ll.tif');
Im3(:,:,4)=imread('examples\alg3\rdb028rl.tif');
%Algo4 images
Im4(:,:,1)=imread('examples\alg4\rdb005ll.tif');
Im4(:,:,2)=imread('examples\alg4\rdb023ll.tif');
Im4(:,:,3)=imread('examples\alg4\rdb025ll.tif');
Im4(:,:,4)=imread('examples\alg4\rdb028rl.tif');
%Algo5 images
Im5(:,:,1)=imread('examples\alg5\rdb005ll.tif');
Im5(:,:,2)=imread('examples\alg5\rdb023ll.tif');
Im5(:,:,3)=imread('examples\alg5\rdb025ll.tif');
Im5(:,:,4)=imread('examples\alg5\rdb028rl.tif');
%Algo6 images
Im6(:,:,1)=imread('examples\alg6\rdb005ll.tif');
Im6(:,:,2)=imread('examples\alg6\rdb023ll.tif');
Im6(:,:,3)=imread('examples\alg6\rdb025ll.tif');
Im6(:,:,4)=imread('examples\alg6\rdb028rl.tif');

%calculating ROCS seperately for all algorithms

%Algorithm 1
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im1(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR1(cs,thres)=TP/(TP+FN);
        FPR1(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR1(cs,thres)).^2+(FPR1(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 1 for each image
figure;
plot(FPR1(1,:),TPR1(1,:),'r');
hold on;
plot(FPR1(2,:),TPR1(2,:),'k');
hold on;
plot(FPR1(3,:),TPR1(3,:),'g');
hold on;
plot(FPR1(4,:),TPR1(4,:));
title('Algorithm 1');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC1=trapz(FPR1(1,:),TPR1(1,:))+ trapz(FPR1(2,:),TPR1(2,:))+ trapz(FPR1(3,:),TPR1(3,:))+trapz(FPR1(4,:),TPR1(4,:));
AUC1=abs(AUC1/4);
%determining best threshold for algorithm by mean of all best thresholds
best1=sum(bthresh)/4;


%Algorithm 2
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im2(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR2(cs,thres)=TP/(TP+FN);
        FPR2(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR2(cs,thres)).^2+(FPR2(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 2 for each image
figure;
plot(FPR2(1,:),TPR2(1,:),'r');
hold on;
plot(FPR2(2,:),TPR2(2,:),'k');
hold on;
plot(FPR2(3,:),TPR2(3,:),'g');
hold on;
plot(FPR2(4,:),TPR2(4,:));
title('Algorithm 2');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC2=trapz(FPR2(1,:),TPR2(1,:))+ trapz(FPR2(2,:),TPR2(2,:))+ trapz(FPR2(3,:),TPR2(3,:))+trapz(FPR2(4,:),TPR2(4,:));
AUC2=abs(AUC2/4);
%determining best threshold for algorithm by mean of all best thresholds
best2=sum(bthresh)/4;


%Algorithm 3
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im3(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR3(cs,thres)=TP/(TP+FN);
        FPR3(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR3(cs,thres)).^2+(FPR3(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 3 for each image
figure;
plot(FPR3(1,:),TPR3(1,:),'r');
hold on;
plot(FPR3(2,:),TPR3(2,:),'k');
hold on;
plot(FPR3(3,:),TPR3(3,:),'g');
hold on;
plot(FPR3(4,:),TPR3(4,:));
title('Algorithm 3');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC3=trapz(FPR3(1,:),TPR3(1,:))+ trapz(FPR3(2,:),TPR3(2,:))+ trapz(FPR3(3,:),TPR3(3,:))+trapz(FPR3(4,:),TPR3(4,:));
AUC3=abs(AUC3/4);
%determining best threshold for algorithm by mean of all best thresholds
best3=sum(bthresh)/4;


%Algorithm 4
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im4(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR4(cs,thres)=TP/(TP+FN);
        FPR4(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR4(cs,thres)).^2+(FPR4(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 4 for each image
figure;
plot(FPR4(1,:),TPR4(1,:),'r');
hold on;
plot(FPR4(2,:),TPR4(2,:),'k');
hold on;
plot(FPR4(3,:),TPR4(3,:),'g');
hold on;
plot(FPR4(4,:),TPR4(4,:));
title('Algorithm 4');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC4=trapz(FPR4(1,:),TPR4(1,:))+ trapz(FPR4(2,:),TPR4(2,:))+ trapz(FPR4(3,:),TPR4(3,:))+trapz(FPR4(4,:),TPR4(4,:));
AUC4=abs(AUC4/4);
%determining best threshold for algorithm by mean of all best thresholds
best4=sum(bthresh)/4;


%Algorithm 5
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im5(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR5(cs,thres)=TP/(TP+FN);
        FPR5(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR5(cs,thres)).^2+(FPR5(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 5 for each image
figure;
plot(FPR5(1,:),TPR5(1,:),'r');
hold on;
plot(FPR5(2,:),TPR5(2,:),'k');
hold on;
plot(FPR5(3,:),TPR5(3,:),'g');
hold on;
plot(FPR5(4,:),TPR5(4,:));
title('Algorithm 5');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC5=trapz(FPR5(1,:),TPR5(1,:))+ trapz(FPR5(2,:),TPR5(2,:))+ trapz(FPR5(3,:),TPR5(3,:))+trapz(FPR5(4,:),TPR5(4,:));
AUC5=abs(AUC5/4);
%determining best threshold for algorithm by mean of all best thresholds
best5=sum(bthresh)/4;


%Algorithm 6
for cs=1:4
    best=10;
    %thresholding segmentation result to build ROCs
    for thres=1:255
        for k=1:m
            for l=1:n
                if (Im6(k,l,cs)<thres-1)
                    Im1t(k,l)=0;
                else
                    Im1t(k,l)=1;
                end
            end
        end
        %calculating TP,TN,FP,FN for each image per threshold
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for i=1:m
            for j=1:n
                if Im1t(i,j)==Imgnd(i,j,cs)
                    if Imgnd(i,j,cs)==0
                        TN=TN+1;
                    else
                        TP=TP+1;
                    end
                else
                    if Imgnd(i,j,cs)==0
                        FP=FP+1;
                    else
                        FN=FN+1;
                    end
                end
            end
        end
        %calculating TP and FP rates for each image for each threshold
        TPR6(cs,thres)=TP/(TP+FN);
        FPR6(cs,thres)=FP/(FP+TN);
        %calculating minimum distance from optimal point (0,1)
        dist=sqrt((1-TPR6(cs,thres)).^2+(FPR6(cs,thres)).^2);
        if dist<best
            best=dist;
            bthresh(cs)=thres;
        end
    end
end
%Plotting ROC for Algorithm 6 for each image
figure;
plot(FPR6(1,:),TPR6(1,:),'r');
hold on;
plot(FPR6(2,:),TPR6(2,:),'k');
hold on;
plot(FPR6(3,:),TPR6(3,:),'g');
hold on;
plot(FPR6(4,:),TPR6(4,:));
title('Algorithm 6');
legend('Image 1', 'Image 2', 'Image 3', 'Image 4');
%calculating average Area under curve
AUC6=trapz(FPR6(1,:),TPR6(1,:))+ trapz(FPR6(2,:),TPR6(2,:))+ trapz(FPR6(3,:),TPR6(3,:))+trapz(FPR6(4,:),TPR6(4,:));
AUC6=abs(AUC6/4);
%determining best threshold for algorithm by mean of all best thresholds
best6=sum(bthresh)/4;

%displaying best thresholds for each algorithm
best_threshold=[best1 best2 best3 best4 best5 best6]
%printing average area under curves for each algorithm
AUC=[AUC1 AUC2 AUC3 AUC4 AUC5 AUC6]

%plotting ROC for each image provided with all algorithm results for that
%image
%Image 1
figure;
plot(FPR1(1,:),TPR1(1,:),'r');
hold on;
plot(FPR2(1,:),TPR2(1,:),'k');
hold on;
plot(FPR3(1,:),TPR3(1,:),'y');
hold on;
plot(FPR4(1,:),TPR4(1,:),'b');
hold on;
plot(FPR5(1,:),TPR5(1,:),'g');
hold on;
plot(FPR6(1,:),TPR6(1,:),'m');
hold on;
title('Image 1');
legend('Algo1','Algo2','Algo3','Algo4','Algo5','Algo6');

%Image 2
figure;
plot(FPR1(2,:),TPR1(2,:),'r');
hold on;
plot(FPR2(2,:),TPR2(2,:),'k');
hold on;
plot(FPR3(2,:),TPR3(2,:),'y');
hold on;
plot(FPR4(2,:),TPR4(2,:),'b');
hold on;
plot(FPR5(2,:),TPR5(2,:),'g');
hold on;
plot(FPR6(2,:),TPR6(2,:),'m');
hold on;
title('Image 2');
legend('Algo1','Algo2','Algo3','Algo4','Algo5','Algo6');

%Image 3
figure;
plot(FPR1(3,:),TPR1(3,:),'r');
hold on;
plot(FPR2(3,:),TPR2(3,:),'k');
hold on;
plot(FPR3(3,:),TPR3(3,:),'y');
hold on;
plot(FPR4(3,:),TPR4(3,:),'b');
hold on;
plot(FPR5(3,:),TPR5(3,:),'g');
hold on;
plot(FPR6(3,:),TPR6(3,:),'m');
hold on;
title('Image 3');
legend('Algo1','Algo2','Algo3','Algo4','Algo5','Algo6');

%Image 4
figure;
plot(FPR1(4,:),TPR1(4,:),'r');
hold on;
plot(FPR2(4,:),TPR2(4,:),'k');
hold on;
plot(FPR3(4,:),TPR3(4,:),'y');
hold on;
plot(FPR4(4,:),TPR4(4,:),'b');
hold on;
plot(FPR5(4,:),TPR5(4,:),'g');
hold on;
plot(FPR6(4,:),TPR6(4,:),'m');
hold on;
title('Image 4');
legend('Algo1','Algo2','Algo3','Algo4','Algo5','Algo6');

toc