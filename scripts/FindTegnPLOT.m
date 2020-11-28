function tegn = FindTegnPLOT(I)

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

%% euclidean error
errors = zeros(Nsigns,Nparams+1);
for i = 1:Nsigns
    for p = 1:Nparams
        errors(i,p) = abs(I_params(1,p) - params(i,p+1));
    end
    errors (i,end) = sqrt(sum((errors(i,1:end-1)).^2 ,'all'));
end

%% Manhattan
% errors = zeros(Nsigns,Nparams+1);
% for i = 1:Nsigns
%     %error = 0;
%     for p = 1:Nparams
%         errors(i,p) = abs(I_params(1,p) - params(i,p+1));
%     end
%     errors (i,end) = sum(errors(i,1:end-1),'all');
% end

%% Minkowski
% r = 4;
% errors = zeros(Nsigns,Nparams+1);
% for i = 1:Nsigns
%     for p = 1:Nparams
%         errors(i,p) = abs(I_params(1,p) - params(i,p+1));
%     end
%     errors (i,end) = nthroot( sum( (errors(i,1:end-1)).^r,'all') ,r);
% end

%% simplere udgave af euclidean uden kvadratrod

% errors = zeros(Nsigns,Nparams+1);
% for i = 1:Nsigns
%     for p = 1:Nparams
%         errors(i,p) = abs(I_params(1,p) - params(i,p+1));
%     end
%     errors (i,end) = sqrt(sum((errors(i,1:end-1)).^2 ,'all'));
% end

%%

[quality,pointer] = min(errors(1:end,end));
tegn = params(pointer,1);

nxt_errors = errors(1:end,end);
nxt_errors(pointer,1) = 5;
[nxt_q,nxt_pointer] = min(nxt_errors(1:end,1));

%% plot sammenligning

parmN = 2:7;

figure('color',[1 1 1])
subplot(211)
semilogy(errors(1:end,end))
xline(pointer,'g','LineWidth',2)
xline(nxt_pointer,'r','LineWidth',2)
yline(quality,'--','LineWidth',1)
yline(nxt_q,'--','LineWidth',1)
title(['Mindste fejl ',params(pointer,1), ...
    ' - kan forveksles med ',params(nxt_pointer,1)])
%title(['Mindste fejl ',params(pointer,1)])
ylabel('fejl (logaritmisk)')
xlabel('Tegn fra 0 til Z')


subplot(212)
plot(parmN,I_params(1,1:end),'b'); hold on;
plot(parmN,params(pointer,2:end),'g')
plot(parmN,params(nxt_pointer,2:end),'r')
%plot(parmN,(errors(pointer,1:end-1)),'.','r','LineWidth',1)
%plot(parmN,errors(pointer,1:end-1),'.-','r','LineWidth',1)

for i = 1:Nsigns
stem(parmN,params(i,2:end))
end
ylabel('Parameter værdi')
xlabel('Parameter nummer')
legend('Objekt','Template','nærmeste')
%legend('Objekt','Template','E euclidean','E manhattan','E minkowski')


end