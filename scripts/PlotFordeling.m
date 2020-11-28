function PlotFordeling(params,Nsigns)

figure('color',[1,1,1])
title('fordeling')

for i = 1:Nsigns
    scatter3(params(i,2),params(i,3),params(i,5)); hold on;
end

legend('0','1','2','3','4','5','6','7','8','9')
xlabel('forhold mellem fyld i top og bund')
ylabel('relation mellem fyld og omkreds')
zlabel('forhold mellem fyld og ikke fyld')

end