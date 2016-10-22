class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}

	liste_medias: ARRAY[MEDIA] -- liste des médias
	--liste_utilisateurs: ARRAY[UTILISATEUR] -- liste des utilisateurs
	--utilisateurs: ARRAY[UTILISATEUR]
	--path_to_user_file: STRING

feature {ANY}
	make is
			-- Initialisation des Médias et des Utilisateurs
		do
			-- Initialisations
      create liste_medias.with_capacity(0, 0)
      --create liste_utilisateurs.with_capacity(0,0)
			readfilemedia
			lire_fichier_utilisateurs
		end

	---------------------------------------
	-- LISTER LES MEDIAS
	---------------------------------------

	---------------------------------------
	-- LIRE FICHIER DES MEDIAS
	---------------------------------------
	readfilemedia is
	local
		file : TEXT_FILE_READ
		line : STRING
		nbr_separation_inline : INTEGER
		word : STRING
		i: INTEGER
		dvd: DVD
		livre : LIVRE
		is_book : BOOLEAN
		is_dvd : BOOLEAN
		index_premier_point_virgule : INTEGER
		premier_terme : STRING
		index_pointvirguleprecedent : INTEGER
		index_point_virgule_suivant : INTEGER
		terme :STRING
	do
		create file.connect_to("medias.txt")
		from until file.end_of_input
		loop
			file.read_line
			line := file.last_string
			if line.has_substring("Livre") then
				is_book := True
				--create livre.with_capacity(0,0)
			end
			if line.has_substring("DVD") then
				is_dvd := True
				--create dvd.with_capacity(0,0)
			end
			nbr_separation_inline := line.occurrences(';')

			io.put_string("nombre de points virgules : " + nbr_separation_inline.to_string + "%N")

			index_premier_point_virgule := line.index_of(';', 1)
			index_pointvirguleprecedent := index_premier_point_virgule
			premier_terme := line.substring(1, index_premier_point_virgule)

			if premier_terme.is_equal("DVD") then
				is_dvd := True
				from i := 1 until i > nbr_separation_inline
				loop
				  index_point_virgule_suivant := line.index_of(';', index_pointvirguleprecedent)
					terme := line.substring(index_pointvirguleprecedent, index_point_virgule_suivant)
					index_pointvirguleprecedent := index_point_virgule_suivant + 1
				  i := i+1
					-- tester chaque attribut de dvd et creer dvd
				end
			end
			if premier_terme.is_equal("Livre") then
				is_book := True
				from i := 1 until i > nbr_separation_inline
				loop
				  index_point_virgule_suivant := line.index_of(';', index_pointvirguleprecedent)
					terme := line.substring(index_pointvirguleprecedent, index_point_virgule_suivant)
					index_pointvirguleprecedent := index_point_virgule_suivant + 1
				  i := i+1
					-- tester chaque attribut de livre et creer livre
				end
			end
	end


	lire_fichier_utilisateurs is
		local
			--lecture_ok= FALSE
			lecteur: TEXT_FILE_READ
			ligne, champ, nom_lu, prenom_lu, id_lu, admin_lu, valeur: STRING
			mot, nb_mot, debut_champ, fin_champ: INTEGER
			admin_oui: BOOLEAN
			utilisateur: UTILISATEUR
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
				admin_lu := ""
				from mot:= 0 until mot > nb_mot loop
					fin_champ := ligne.index_of(';',debut_champ)
					if fin_champ = 0 then
						fin_champ := ligne.count
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Nom")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						nom_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end

					if(ligne.substring(debut_champ, fin_champ).has_substring("Prenom")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						prenom_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end

					if(ligne.substring(debut_champ, fin_champ).has_substring("Identifiant")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						id_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end

					if(ligne.substring(debut_champ, fin_champ).has_substring("Admin")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						admin_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
						if admin_lu.is_equal("OUI") then
							admin_oui := True
						end
					end

					champ := ligne.substring(debut_champ, fin_champ)
					mot := mot+1
					debut_champ := fin_champ + 1

				end
				create utilisateur(nom_lu, prenom_lu, id_lu, admin_oui)
				--AJOUTER utilisateur au tableau des utilisateurs

			end
			lecteur.disconnect
		--	Result:= TRUE
		end
	end

end -- class MEDIATHEQUE
