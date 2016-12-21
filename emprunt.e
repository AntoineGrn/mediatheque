class EMPRUNT

creation {ANY}
    make_emprunt

feature {ANY}
	media: MEDIA
	user : UTILISATEUR
   date_emprunt: TIME
	date_retour: TIME
	date_rendu: TIME

feature {ANY}
    make_emprunt (media_e : MEDIA; user_e : UTILISATEUR; date_e : TIME; date_r : TIME) is
    do
		media := media_e
		user := user_e
		date_emprunt := date_e
		date_retour := date_r
		date_rendu := date_r
    end
	
	    ------------------------
       -- AFFICHER UN EMPRUNT--
       ------------------------
	afficher : STRING is
	do
		Result := media.get_titre + " emprunté par " + user.get_identifiant
	end
    ---------------------
    ----- SETTERS -------
    ---------------------
	set_date_rendu is
	do
		date_rendu.update
	end
	
    ---------------------
    ----- GETTERS -------
    ---------------------
	get_date_rendu : TIME is
	do
		Result := date_rendu
	end
end -- classe REMPRUNT
