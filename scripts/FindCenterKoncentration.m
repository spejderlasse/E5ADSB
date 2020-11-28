    function koncentration = FindCenterKoncentration(I)

[R,C] = size(I);%,[1 2]);

s1 = 1;
s2 = 4;

temp = 0;

for r = floor(s1*R/s2):floor((s2-s1)*R/s2)
    for c = floor(s1*C/s2):floor((s2-s1)*C/s2)
        if I(r,c) == 1
            temp = temp+1;
        end
    end
end

koncentration = temp/sum(I,'all');

end