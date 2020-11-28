function Midtpunkt = FindMidtpunktHorz(I)
% For at finde objektets massemidtpunkt laves en løkke der for hver kolonne 
% tager produktet mellem kolonnenummeret og summen af kolonnens indhold. 
% Summen af alle disse produkter midles med antallet af gange der har 
% været en værdi af en pixel.

[R,C] = size(I);
i = 0;
sum = 0;

for c = 1:C
    for r = 1:R
        if I(r,c) == 1
        i = i + 1;
        sum = sum + c;
        end
    end
end

sum = sum/i; %midling
sum = sum/C; %skalering for at tilpasse til bredden
Midtpunkt = sum;

end