class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque 
	--
	
creation {ANY}
	make

feature {}
	--utilisateurs: ARRAY[UTILISATEUR]
	--path_to_user_file: STRING

feature {ANY}
	make is
			-- Initialisation des Médias et des Utilisateurs
		do
			lire_fichier_utilisateurs
		end

	lire_fichier_utilisateurs is
		local
			--lecture_ok= FALSE
			lecteur: TEXT_FILE_READ
			ligne: STRING
		do
			create lecteur.connect_to("/comptes/E134887R/Documents/M1_MIAGE/GLO/Mediatheque/mediatheque/utilisateurs.txt")
			from until lecteur.end_of_input loop
				lecteur.read_line
				ligne := lecteur.last_string
				io.put_string(ligne + "%N")
			end
			lecteur.disconnect
		--	Result:= TRUE
		end	

end -- class MEDIATHEQUE
