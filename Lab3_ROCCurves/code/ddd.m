%Medical Image Analysis
%Lab Report 2
%Author: Raabid Hussain

%This file calculates the three parameters for 3D volume case provided
%takes roughly 2.5 seconds to complete

tic

clear;
close all;
clc;
%load 3D volume data
load('3DSegmentation.mat.mat');
%check size of the volume
[m,n,o]=size(mask);

%calclate TP,TN,FP,FN for entire volume combined
%initialize to zero
TP=0;
TN=0;
FP=0;
FN=0;
%loop to increment appropriate counter according to the voxel value
for cs=1:o
    for i=1:m
        for j=1:n
            if segmentation(i,j,cs)==mask(i,j,cs)
                if mask(i,j,cs)==0
                    TN=TN+1;
                else
                    TP=TP+1;
                end
            else
                if mask(i,j,cs)==0
                    FP=FP+1;
                else
                    FN=FN+1;
                end
            end
        end
    end
end

%calculate Jacard Index
JI=TP/(FN+FP+TP);
%calculate Dice Coefficient Similarity
DC=2*TP/(2*TP+FN+FP);

%calculating Hausdorf Distance
%boundary extraction from the ground truth volume
I1=[];
I2=I1;
I=mask;
p=0;
for k=2:o-1
    for i=2:m-1
        for j=2:n-1
            if(I(i,j,k)==1)
                %checking all 26 neighbours to determine if it is a
                %boundary or not
                if (I(i+1,j,k)==0 || I(i-1,j,k)==0 || I(i,j+1,k)==0 || I(i,j-1,k)==0 || I(i+1,j+1,k)==0 || I(i+1,j-1,k)==0 || I(i-1,j-1,k)==0 || I(i-1,j+1,k)==0 || ...
                    I(i+1,j,k-1)==0 || I(i-1,j,k-1)==0 || I(i,j+1,k-1)==0 || I(i,j-1,k-1)==0 || I(i+1,j+1,k-1)==0 || I(i+1,j-1,k-1)==0 || I(i-1,j-1,k-1)==0 || I(i-1,j+1,k-1)==0 || I(i,j,k-1)==0 || ...
                    I(i+1,j,k+1)==0 || I(i-1,j,k+1)==0 || I(i,j+1,k+1)==0 || I(i,j-1,k+1)==0 || I(i+1,j+1,k+1)==0 || I(i+1,j-1,k+1)==0 || I(i-1,j-1,k+1)==0 || I(i-1,j+1,k+1)==0 || I(i,j,k+1)==0 )
                    p=p+1;
                    %saving position of boundaries
                    I1(p,:)=[i,j,k];
                end
            end
        end
    end
end

%boundary extraction from the segmentation result volume
q=0;
I=segmentation;
for k=2:o-1
    for i=2:m-1
        for j=2:n-1
            if(I(i,j,k)==1)
                %checking all 26 neighbours to determine if it is a
                %boundary or not
                if (I(i+1,j,k)==0 || I(i-1,j,k)==0 || I(i,j+1,k)==0 || I(i,j-1,k)==0 || I(i+1,j+1,k)==0 || I(i+1,j-1,k)==0 || I(i-1,j-1,k)==0 || I(i-1,j+1,k)==0 || ...
                    I(i+1,j,k-1)==0 || I(i-1,j,k-1)==0 || I(i,j+1,k-1)==0 || I(i,j-1,k-1)==0 || I(i+1,j+1,k-1)==0 || I(i+1,j-1,k-1)==0 || I(i-1,j-1,k-1)==0 || I(i-1,j+1,k-1)==0 || I(i,j,k-1)==0 || ...
                    I(i+1,j,k+1)==0 || I(i-1,j,k+1)==0 || I(i,j+1,k+1)==0 || I(i,j-1,k+1)==0 || I(i+1,j+1,k+1)==0 || I(i+1,j-1,k+1)==0 || I(i-1,j-1,k+1)==0 || I(i-1,j+1,k+1)==0 || I(i,j,k+1)==0 )
                    q=q+1;
                    %saving position of boundaries
                    I2(q,:)=[i,j,k];
                end
            end
        end
    end
end

%initializations of distance
sm1=ones(p,1)*m*n*o;
sm2=ones(q,1)*m*n*o;

%calculating minimum disance for every point for V1 against V2
%minimum distance for all boundary points
for i=1:p
    for j=1:q
        dist=sqrt((I1(i,1)-I2(j,1)).^2+(I1(i,2)-I2(j,2)).^2+(I1(i,3)-I2(j,3)).^2);
        if dist<sm1(i)
            sm1(i)=dist;
        end
    end
end

%calculating minimum disance for every point for V2 against V1
%initializations
for i=1:q
    for j=1:p
        dist=sqrt((I2(i,1)-I1(j,1)).^2+(I2(i,2)-I1(j,2)).^2+(I2(i,3)-I1(j,3)).^2);
        if dist<sm2(i)
            sm2(i)=dist;
        end
    end
end

%calculating maximum distance for both volumes
HD1=[max(sm1) max(sm2)];
HD=max(HD1);

%displaying the three parameters
JI
DC
HD

toc
