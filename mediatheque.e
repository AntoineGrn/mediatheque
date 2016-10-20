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
			ligne, champ, nom_lu, prenom_lu, id_lu: STRING
			mot, nb_mot, debut_champ, fin_champ: INTEGER
			admin_lu: BOOLEAN
		do
			create lecteur.connect_to("utilisateurs.txt")
			from until lecteur.end_of_input loop
				lecteur.read_line
				ligne := lecteur.last_string
				io.put_string(ligne + "%N")
				nb_mot := ligne.occurrences(';')
				debut_champ := 1
				fin_champ := 0
				champ := ""
				nom_lu := ""
				prenom_lu := ""
				id_lu := ""
				admin_lu := False
				from mot:= 0 until mot > nb_mot loop
					fin_champ := ligne.index_of(';',debut_champ)
					if fin_champ = 0 then
						fin_champ := ligne.count
					end
					champ := ligne.substring(debut_champ, fin_champ)
					mot := mot+1
					debut_champ := fin_champ + 1
					io.put_string(champ + "%N")
				end
				
			end
			lecteur.disconnect
		--	Result:= TRUE
		end	

end -- class MEDIATHEQUE
