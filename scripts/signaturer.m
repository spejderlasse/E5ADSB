%% signaturer
clc; clear all; close all;

% hent binære billeder
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

n = 1;

I = I_array{n};

% lokalisering af massemidtpunkt og koordinater for ydre omkreds
% omkreds starter i første kolonne ved første række der har værdien '1'
% følger omridset startene i retning af uret
stats=regionprops(I,'Centroid');
bound=bwboundaries(I);
c = stats.Centroid;
x = bound{1,1}(:,1);
y = bound{1,1}(:,2);

% find afstand fra midtpunkt til hvert koordinat
distances = sqrt((y-c(1)).^2+(x-c(2)).^2);

% til plot af omridset fra bwboundaries
[R,C] = size(I);
I_b = zeros(R,C);
for i = 1:floor(size(x)*8/8)
    I_b(x(i,1),y(i,1)) = 1;
end

i1 = 1;
i2 = length(distances)*1/5;
i3 = length(distances)*2/5;
i4 = length(distances)*3/5;
i5 = length(distances)*4/5;
%i6 = length(distances)*5/6;

figure('color',[1 1 1]),
subplot(221)
imshow(I)

subplot(222)
imshow(I_b)
line([round(c(1,1)),y(round(i1),1)], [round(c(1,2)),x(round(i1),1)],...
    'color','r', 'LineWidth',2)
line([round(c(1,1)),y(round(i2),1)], [round(c(1,2)),x(round(i2),1)],...
    'color','b', 'LineWidth',2)
line([round(c(1,1)),y(round(i3),1)], [round(c(1,2)),x(round(i3),1)],...
    'color','g', 'LineWidth',2)
line([round(c(1,1)),y(round(i4),1)], [round(c(1,2)),x(round(i4),1)],...
    'color','c', 'LineWidth',2)
line([round(c(1,1)),y(round(i5),1)], [round(c(1,2)),x(round(i5),1)],...
    'color','m', 'LineWidth',2)
%line([round(c(1,1)),y(round(i6),1)], [round(c(1,1)),x(round(i6),1)],...
%    'color','y', 'LineWidth',2)

subplot(212)
plot(distances);
xline(i1,'color','r','LineWidth',2)
xline(i2,'color','b','LineWidth',2)
xline(i3,'color','g','LineWidth',2)
xline(i4,'color','c','LineWidth',2)
xline(i5,'color','m','LineWidth',2)
%xline(i6,'color','y','LineWidth',2)

title(['signatur']);
%title(['Resultat: ',output(1,1),output(2,1),' ',output(3,1),output(4,1),' ',output(5,1),output(6,1),output(7,1)]);

