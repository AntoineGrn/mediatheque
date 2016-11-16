class EMPRUNT

creation {ANY}
    make

feature {ANY}
	media: MEDIA
	user : UTILISATEUR
   date_emprunt: TIME
	date_retour: TIME

feature {ANY}
    make (media_param: MEDIA; user_param : UTILISATEUR; date_emprunt : TIME; date_retour : TIME) is
    do
		media := media_param
		user := user_param
		date_emprunt.update
    end
	
	   ---------------------------------
       ------- AFFICHER EMPRUNT
       -- On retourne une cdc qui contient le titre de l'objet emprunté et l'identifiant de l'emprunteur
       ---------------------------------
	afficher : STRING is
	do
		Result := media.get_titre + " emprunté par " + user.get_identifiant
	end
    ---------------------
    ----- SETTERS -------
    ---------------------
	set_date_retour is
	do
		date_retour.update
	end
	
    ---------------------
    ----- GETTERS -------
    ---------------------
	get_date_retour : TIME is
	do
		Result := date_retour
	end

end -- classe REMPRUNT

