% automatisering af placering af nummerplade
function nummerplade = FindNummerplade(Im,Threshold,TempScale)
%Im: billede
%Threshold: fast threshold eller 0 for automatisk
%TempScale: fast scale eller 0 for default (2.2)

%% Preprocessing
%Im = imread('numplate_red1.jpg'); %indlæser billede
% numplate, 2, _red1, _red2, _tyr1, _tyr2, _white1, _white2, _grey1,
% _grey2, _black1, _black2, _black3

% DEM DER VIRKER
% _red1, 1, 2, _grey3
Im = rgb2gray(Im); %laver billede til grayscale
Im = im2double(Im); %laver billede til double

%I = imresize(I,[500*2 800*2]); %template1

if (Threshold == 0)
    I_mean = mean(Im,'all'); %  1=0.3059  |  2=0.4350
    I_med = median(Im,'all'); % 1=0.2431  |  2=0.4157
    I_max = max(Im,[],'all'); % 1=0.8706  |  2=0.8863
    th = I_max/3; %automatiseret threshold
else
    th = Threshold;
end

%th = 2-(I_mean+I_med+I_max)
%th = I_max-I_mean;
%th = 0.68;
Im = Im > th; 
%                          | max/2.5 | max-mean | max-med*2 | 2-alt
%I = I > 0.50; %numplate 1 -- 0.3482 | 0.5646   | 0.3843    | 0.5803
%I = I > 0.34; %numplate 2 -- 0.3545 | 0.4512   | 0.0549    | 0.2630
% figure
% imshow(Im);
% title('Efter thresholding')
I2 = Im;
%% Laver templates

% Y = ones(100,500);
% Y(1:5,1:500)=0;
% Y(end-4:end,1:500)=0;
% Y(1:100,1:5)=0;
% Y(1:100,end-4:end)=0;
% figure
% imshow(Y);

temp = imread("temp2.jpg");
temp = rgb2gray(temp); %laver billede til grayscale
%temp = imresize(temp,1.8); %template2
%temp = imresize(temp,2); %template1
if TempScale == 0
    temp = imresize(temp,2.2); %automatiseret template størrelse
else
    temp = imresize(temp,TempScale); %automatiseret template størrelse
end

temp = im2double(temp); %laver billede til double
border = 7;
temp(1:end,1:border)=0; %temp2
temp(1:8,1:border)=1; %temp2
temp(end-4:end,1:border)=1; %temp2
temp = temp > 0.5; 
% 
% figure
% imshow(Im); hold on
% imshow(temp);
% title('Generisk dansk nummerplade, resized');

%% Tester 
% figure
% imshow(out)

%%

temp = temp;
im = Im;
out=normxcorr2(temp,im);
th = max(out,[],'all')-0.001;

% figure
% imshow(out);
% title('Analyse af korrelation');

bw2 = out>th;

[m,n] = size(temp);
out = out(m+1:end,n+1:end);
bw = out>th;
r=regionprops(bwlabel(bw), 'BoundingBox');
im(1:m , 1:n)=temp;

r2 =regionprops(bwlabel(bw2), 'BoundingBox');

%figure
%imshow(im,[])
%hold on

% for i=1:length(r)
%     thisBB = r(i).BoundingBox;
%     rectangle('position',  thisBB', 'edgecolor', 'g', 'linewidth',2);
% 
% end

% hold on
% 
% for i=1:length(r2)
%     thisBB = r2(i).BoundingBox;
%     rectangle('position',  thisBB', 'edgecolor', 'g', 'linewidth',2);
% 
% end

%% Cutting out the numplate
segments = bwlabel(bw);
point = segments==1;

% figure
% imshow(bw);
% title('Det sted med højest korrelation');

Tmax = max(point,[],'all');
[row,col] = find(point == Tmax);
col=floor(mean(col));
row=floor(mean(row));
realpoint = [col row];


segments2 = bwlabel(bw2);
point2 = segments2==1;

Tmax2 = max(point2,[],'all');
[row2,col2] = find(point2 == Tmax2);
col2=floor(mean(col2));
row2=floor(mean(row2));
realpoint2 = [col2 row2];


I_num = imcrop(I2, [col row col2-col row2-row]);
% figure
% imshow(I_num);hold on
% title('"Automatisk" udskæring')
% imwrite(I_num,'testplate2.jpg');

I2 = I_num;
%% Noise Reduction 

% der laves et structuring element 
SE = strel('square',5);

Ic = imclose(I2,SE); %closing, erosion derefter dilation
% figure
% imshow(Ic);
% title('Efter imclose')

Ico = imopen(Ic,SE); %opening, dilation derefter erosion
% figure
% imshow(Ico);
% title('Efter imclose og imopen')

%% Negativ, laver mørk baggrund og lys foregrund
Im = Ico < 0.5; %numplate 2
% figure
% imshow(I);
% title('Negativ')

%% Segmentering

L4 = bwlabel(Im,4); %component connectivity med 4
L4rgb = label2rgb(L4); %billedet laves rgb for at se labels

% figure
% imshow(L4rgb);
% title('4-connectivity')

%% Beskærer og printer segmenter ud
%close all;
j = max(L4,[],'all'); %der findes max antal labels i hele matrix
%j = 1; %bruges til at teste første segment

nummerplade = zeros(7,1);

segnr = 1;
for i = 1:j
    I_segment = L4 == i; %der udtages kun element 'i'
%     figure
%     imshow(I_segment);
%     title(['Segment nummer ',num2str(i)])
    k = sum(I_segment,'all');
    if k < 2000
        continue;
    end
    [m,n] = size(I_segment); %giver matrix størrelse
    for i_top = 1:m %tager fra først række til sidste række
        S = sum(I_segment(i_top,:)); %finder sum
        if S > 0 %er summen over 1, har vi fundet karakteret
            top = i_top; %aflæser hvor første række med sum er  
            break;
        end
    end
    for i_left = 1:n %tager fra første kolonne til sidste
        S = sum(I_segment(:,i_left)); %finder sum
        if S > 0 %er summen over 1, har vi fundet karakteret
            left = i_left; %aflæser hvor første kolonne med sum er  
            break;
        end
    end
    for i_bot = m:-1:1 %tager fra sidste række til første
        S = sum(I_segment(i_bot,:));
        if S > 0
            bot = i_bot;  
            break;
        end
    end
    for i_right = n:-1:1 %tager fra sidste kolonne til første
        S = sum(I_segment(:,i_right));
        if S > 0
            right = i_right;  
            break;
        end
    end
  ch = imcrop(I_segment,[left top right-left bot-top]); %beskærer
  k = numel(ch);
  if k > 20000
    continue;
  end
  [m,n] = size(ch);
  if m < n
      continue;
  end
  nummerplade(segnr,1) = FindTegnPLOT(ch);

%   figure('color',[1 1 1])
%   imshow(ch);
%   title(['Tolkes som ',nummerplade(segnr,1)])
  
  segnr = segnr + 1;
end

end

