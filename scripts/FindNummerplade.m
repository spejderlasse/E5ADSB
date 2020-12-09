% automatisering af placering af nummerplade
function nummerplade = FindNummerplade(Im,Threshold,TempScale)
%Im: billede
%Threshold: fast threshold eller 0 for automatisk
%TempScale: fast scale eller 0 for default (2.2)

%% Preprocessing

Im = rgb2gray(Im); %laver billede til grayscale
Im = im2double(Im); %laver billede til double

if (Threshold == 0)
    I_max = max(Im,[],'all'); % max th værdi
    th = I_max/3; %automatiseret threshold
else
    th = Threshold;
end

Im = Im > th; 

I2 = Im;
%% Laver template

temp = imread("temp2.jpg");
temp = rgb2gray(temp); %laver billede til grayscale

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

%%

im = Im;
out=normxcorr2(temp,im);
th = max(out,[],'all')-0.001;

bw2 = out>th;

[m,n] = size(temp);
out = out(m+1:end,n+1:end);
bw = out>th;
r=regionprops(bwlabel(bw), 'BoundingBox');
im(1:m , 1:n)=temp;

r2 =regionprops(bwlabel(bw2), 'BoundingBox');


%% Cutting out the numplate
segments = bwlabel(bw);
point = segments==1;

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

I2 = I_num;
%% Noise Reduction 

% der laves et structuring element 
SE = strel('square',5);

Ic = imclose(I2,SE); %closing, erosion derefter dilation

Ico = imopen(Ic,SE); %opening, dilation derefter erosion


%% Negativ, laver mørk baggrund og lys foregrund
Im = Ico < 0.5; %numplate 2


%% Segmentering

L4 = bwlabel(Im,4); %component connectivity med 4
%L4rgb = label2rgb(L4); %billedet laves rgb for at se labels

%% Beskærer og printer segmenter ud
%close all;
j = max(L4,[],'all'); %der findes max antal labels i hele matrix

nummerplade = zeros(7,1);

segnr = 1;
for i = 1:j
    I_segment = L4 == i; %der udtages kun element 'i'
    k = sum(I_segment,'all');
    if k < 2000
        continue;
    end
    [m,n] = size(I_segment); %giver matrix størrelse
    for i_top = 1:m %tager fra først række til sidste række
        S = sum(I_segment(i_top,:)); %finder sum
        if S > 0 %er summen over 1, har vi fundet karakteren
            top = i_top; %aflæser hvor første række med sum er  
            break;
        end
    end
    for i_left = 1:n %tager fra første kolonne til sidste
        S = sum(I_segment(:,i_left)); %finder sum
        if S > 0 %er summen over 1, har vi fundet karakteren
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
  nummerplade(segnr,1) = FindTegn(ch);  
  segnr = segnr + 1;
end

end

