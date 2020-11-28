function Midtpunkt = FindMidtpunktVert(I)

[R,C] = size(I);%,[1 2]);
i = 0;
sum = 0;

% For at finde objektets massemidtpunkt laves en løkke der for hver række 
% tager produktet mellem rækkenummeret og summen af rækkens indhold. 
% Summen af alle disse produkter midles med antallet af gange der har 
% været en værdi af en pixel.

for r = 1:R
    for c = 1:C
        if I(r,c) == 1
        i = i + 1;
        sum = sum + r;
        end
    end
end

sum = sum/i; %midling
sum = sum/R; %skalering for at tilpasse til højden
Midtpunkt = sum;

end