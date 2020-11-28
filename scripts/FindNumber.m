function nummer = FindNumber(I)

load('karakteristika03.mat');

params = 4;
signs = 10;

%analyse af input
I_def = zeros(1,params);
I_def(1,1) = sum(I(1:floor(end/2),1:end),'all') / sum(I(floor(end/2):end,1:end),'all');
I_fyld = sum(I,'all');
I_omkreds = sum(bwperim(I),'all');
I_def(1,2) = sum(I,'all')/I_omkreds^2;
I_def(1,3) = bweuler(I);
I_def(1,4) = sum(I > 0.5,'all')/sum(I < 0.5,'all');

%% skalering af parametre

for i = 1:params
    offset = min(def(1:signs,i));
    scale = 1/(max(def(1:signs,i))-min(def(1:signs,i)));
    def(1:signs,i) = (def(1:signs,i)-offset) * scale;
    I_def(1,i) = (I_def(1,i)-offset) * scale;
end

% %% vægtning
% % top/bund, fyld/omkreds, euler, fyld

TB_strength = 1;
FO_strength = 1;
EU_strength = 1;
IO_strength = 1;

def(1:signs,1) = def(1:signs,1) * TB_strength;
I_def(1,1) = I_def(1,1) * TB_strength;
def(1:signs,2) = def(1:signs,2) * FO_strength;
I_def(1,2) = I_def(1,2) * FO_strength;
def(1:signs,3) = def(1:signs,3) * EU_strength;
I_def(1,3) = I_def(1,3) * EU_strength;
def(1:signs,4) = def(1:signs,4) * IO_strength;
I_def(1,4) = I_def(1,4) * IO_strength;


%%

%sammenligning tegn
I_LS = zeros(10,2);
I_LS (1:end,2) = ['0','1','2','3','4','5','6','7','8','9'];

for i = 1:signs
    error = 0;
    for p = 1:params
        error = error + (I_def(1,p) - def(i,p))^2;
    end
    I_LS (i,1) = error;
    %I_LS (i,1) = (I_def(1,1) - def(i,1))^2 + (I_def(1,2) - def(i,2))^2 + (I_def(1,3) - def(i,3))^2;
    
end
[quality,pointer] = min(I_LS(1:end,1));
disp(['nummeret tolkes som: ',I_LS(pointer,2),'      fejl: ',num2str(quality)]);

nummer = I_LS(pointer,2);

%til fejlhåndtering
%disp(['fejl 1: ',num2str((I_def(1,1) - def(pointer,1))^2)]);
%disp(['fejl 2: ',num2str((I_def(1,2) - def(pointer,2))^2)]);
%disp(['fejl 3: ',num2str((I_def(1,3) - def(pointer,3))^2)]);
%disp(['fejl 4: ',num2str((I_def(1,4) - def(pointer,4))^2)]);

end