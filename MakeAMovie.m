MakeMovie  = 0;                 % Value is 1 if one wants to make a movie and 0 otherwise

if MakeMovie == 1
    PetitFilm = VideoWriter(['Images/Film2.avi']);
    PetitFilm.FrameRate = 20;                   % Nombre d'images par seconde
    open(PetitFilm);
    tStart = tic;
    for nt=2:Nt
        FileName = ['Images/Test-' num2str(nt) '.jpg'];
        rawimg = imread(FileName);
        writeVideo(PetitFilm,im2frame(rawimg));  %,CarteCouleurs));
        %disp(['Temps restant (hh:mm:ss) = ', datestr(((N_end-N)*toc(tStart)/(N-N_start+1))/(3600*24), 'HH:MM:SS')]);
    end
    close(PetitFilm);
end