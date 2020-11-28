clear all; close all; clc;

N =6;

testbilleder = ["numplate_red1.jpg";
     "numplate2.jpg";
     "numplate_grey3.jpg";
     "numplate1.jpg";
     "numplate_tyr1_2.jpg";
     "numplate_white1.jpg";
     ];
 
thres = [0,0,0,0,0.75,0.60]; %thresholds 0=default
scales = [0,0,0,0,2,1.5]; %scales 0=default

f1 = figure('color',[1 1 1]);

for i = 1:N
    Im = imread(testbilleder(i,1));
    output = FindNummerplade(Im,thres(1,i),scales(1,i));    
    figure(f1)
    subplot(3, 2, i)
    imshow(Im);
    title(['Resultat: ',output(1,1), ...
        output(2,1),' ',output(3,1), ...
        output(4,1),' ',output(5,1), ...
        output(6,1),output(7,1)]);
end
