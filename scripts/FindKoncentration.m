function resultat = FindKoncentration(I)

resultat = sum(I > 0.5,'all')/sum(I>=0,'all');

end