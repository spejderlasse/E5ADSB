clear all; close all; clc;
Im = imread('numplate_red1.jpg');
output = FindNummerplade(Im,0,0);
figure('color',[1 1 1])
imshow(Im);
title(['Resultat: ',output(1,1),output(2,1),' ',output(3,1),output(4,1),' ',output(5,1),output(6,1),output(7,1)]);