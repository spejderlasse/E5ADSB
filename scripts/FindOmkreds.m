function omrids = FindOmkreds(I)

[R,C] = size(I);
Area = zeros(R+2,C+2);
Area(2:end-1,2:end-1) = I;
omrids = zeros(R,C);

% hvis punkt(r,c) har værdien '1', og et af de omkringliggende punkter 
% har værdien '0', så sættes tilsvarende punkt i matricen 'omrids' til '1'

for r = 2:R+1
    for c = 2:C+1
        if ((Area(r,c)*9 - sum(Area(r-1:r+1,c-1:c+1),'all'))>0)
            omrids(r-1,c-1)=1;
        end
    end
end

end