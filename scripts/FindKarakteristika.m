clc; clear all; close all;

%% hent binære billeder
Nparams = 6;
Nsigns = 33;
signs = ['0','1','2','3','4','5','6','7','8','9', ...
    'A','B','C','D','E','F','G','H','J','K','L','M','N', ...
    'P','R','S','T','U','V','W','X','Y','Z'];
params = zeros(Nsigns,Nparams+1);

%figure('color',[0.1 0.6 0.5])
for i = 1:Nsigns
    filename = ['NP',signs(1,i),'_BIN.png'];
    I_array{i} = imread(filename);
    %subplot(5,7,i)
    %imshow(I_array{i})
    %title([signs(i)])
end

%% indsæt karakterer i første kolonne af params
for i = 1:Nsigns
    params(i,1) = signs(1,i);
end

%% indsæt parametre i params
for i = 1:Nsigns
    I = I_array{i};
    for p = 1:Nparams
        params(i,p+1) = FindParameter(I,p+1);
    end
end
        
%% Gem som matrice
save('params01.mat','params');

%% sammenlign

PlotFordeling(params,Nsigns)

ch = open('test01.mat');
I_test = ch.ch;
FindTegn(I_test);
disp(['test: ',FindTegn(I_test)]);
