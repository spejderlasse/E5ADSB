function tegn = FindTegn(I)

load('params01.mat');
[Nsigns, Nparams] = size(params);
Nparams = Nparams-1; %første kolonne i params er indeksering

%% analyse af input
I_params = zeros(1,Nparams);

for p = 1:Nparams
    I_params(1,p) = FindParameter(I,p+1);
end

%% skalering af parametre
% alle parametre skaleres så værdierne går fra 0 til 1

for i = 1:Nparams
    offset = min(params(1:Nsigns,i+1));
    scale = 1/(max(params(1:Nsigns,i+1))-min(params(1:Nsigns,i+1)));
    params(1:Nsigns,i+1) = (params(1:Nsigns,i+1)-offset) * scale;
    I_params(1,i) = (I_params(1,i)-offset) * scale;
end

%% vægtning af parametre
%dette giver mulighed for at gøre nogle parametre stærkere eller svagere
scalar = [1 1 1 1 1 1];

for i = 1 : Nparams
    params(1:Nsigns,i+1) = params(1:Nsigns,i+1) * scalar(1,i);
    I_params(1,i) = I_params(1,i) * scalar(1,i);
end

%% sammenligning tegn
% der udregnes et middel af det kvadratet af fejlne 
% for objektet i forhold til værdierne i params
% den mindste middelfejl afgører hvilket tegn der tolkes
% Denne fejl kan tolkes som en kvalitet for sammenligningen
% Jo lavere tallet er, jo sikrere er tolkningen

errors = zeros(Nsigns,Nparams+1);
for i = 1:Nsigns
    for p = 1:Nparams
        errors(i,p) = abs(I_params(1,p) - params(i,p+1));
    end
    errors (i,end) = sqrt(sum((errors(i,1:end-1)).^2 ,'all'));
end

[quality,pointer] = min(errors(1:end,end));
tegn = params(pointer,1);

end