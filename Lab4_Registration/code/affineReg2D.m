function [ Iregistered, M] = affineReg2D( Imoving, Ifixed )
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente 

% clean
close all;
clear all; clc;
tic
% Read two imges 
Imoving=im2double(imread('lenag3.png')); 
Ifixed=im2double(imread('lenag2.png'));

% Smooth both images for faster registration
ISmoving=imfilter(Imoving,fspecial('gaussian'));
ISfixed=imfilter(Ifixed,fspecial('gaussian'));

mtype = 'sd'; % metric type: s: ssd m: mutual information e: entropy 
ttype = 'r'; % rigid registration, options: r: rigid, a: affine
multi= 3; %multi resoltuion, options: 1,2,3

%rigid transformation
if ttype=='r'
     % Parameter scaling of the Translation and Rotation
     scale=[1 1 1];

     % Set initial affine parameters
     x=[0 0 0];
%affine registration
else
    % Parameter scaling of the Translation and Rotation
    scale=[100 100 1 100 100 1];
    % Set initial affine parameters
    x=[1 0 0 0 1 0];
end

x=x./scale;

%multi resoltuion
if multi==1
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
elseif multi==2
    %resizing
    Im1=imresize(ISmoving,0.5);
    If1=imresize(ISfixed,0.5);
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,Im1,If1,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    %scaling the translation parameters
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    pause;
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
elseif multi==3
    %resizing
    Im1=imresize(ISmoving,0.5);
    If1=imresize(ISfixed,0.5);
    Im2=imresize(ISmoving,0.25);
    If2=imresize(ISfixed,0.25);
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,Im2,If2,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    %scaling the translation parameters
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,Im1,If1,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
    %scaling the translation parameters
    if ttype=='r'
        x(1)=x(1)*2;
        x(2)=x(2)*2;
    else
        x(3)=x(3)*2;
        x(6)=x(6)*2;
    end
    %optimizer
    [x]=fminsearch(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x), 'PlotFcns',@optimplotfval));
end
        

x=x.*scale;
%transformation
%rigid
if ttype=='r'
    % Make the affine transformation matrix
     M=[ cos(x(3)) sin(x(3)) x(1);
         -sin(x(3)) cos(x(3)) x(2);
        0 0 1]
%affine
else
    % Make the affine transformation matrix
   M=[ x(1) x(2) x(3);
       x(4) x(5) x(6);
       0 0 1];
end

% Transform the image 
Icor=affine_transform_2d_double(double(Imoving),double(M),0); % 3 stands for cubic interpolation

% Show the registration results
figure,
    subplot(2,2,1), imshow(Ifixed);
    subplot(2,2,2), imshow(Imoving);
    subplot(2,2,3), imshow(Icor);
    subplot(2,2,4), imshow(abs(Ifixed-Icor));

    mse=sum(sum((Ifixed-Icor).^2))/(size(Ifixed,1)*size(Ifixed,2))
%displayed time consumed
time=toc
end

