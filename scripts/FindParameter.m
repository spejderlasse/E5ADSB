function Param_value = FindParameter(I,param)

    % massemidtpunkt vertikalt
    if param == 2
        Param_value = FindMidtpunktVert(I);

    % relation mellem højde og omkreds af objekter og huller
    elseif param == 3
        Param_value = size(I,1)/sum(FindOmkreds(I),'all');

    % euler forhold
    elseif param == 4
        Param_value = bweuler(I);

    % Mætning i billedet. (Andel af pixels der har værdien '1')
    elseif param == 5 
        Param_value = FindKoncentration(I);

    % massemidtpunkt horisontalt
    elseif param == 6
        Param_value = FindMidtpunktHorz(I);

    % koncentration omkring midten af billedet
    elseif param == 7
        Param_value = FindCenterKoncentration(I);

    else
        disp('Fejl i FindParameter');
    end

end