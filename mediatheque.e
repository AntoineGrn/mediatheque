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
		lister_medias(liste_medias)
	end

	---------------------------------------
	-- LISTER LES MEDIAS
	---------------------------------------
	lister_medias (liste_all_medias : ARRAY[MEDIA]) is
	local
		index : INTEGER
	do
		io.put_string("Nombre de médias listés : " + liste_medias.count.to_string + "%N")
		from index := 0 until index > liste_medias.count-1 loop
			io.put_string("Media n" + (index + 1).to_string + " : " + liste_medias.item(index).titre + " %N")
			index := index +1
		end
	end

	---------------------------------------
	--AJOUTER LIVRE
	---------------------------------------
	ajouter_livre (livre : LIVRE) is
	do
		liste_medias.add_last(livre)
	end

	---------------------------------------
	--AJOUTER DVD
	---------------------------------------
	ajouter_dvd (dvd : DVD) is
	do
		liste_medias.add_last(dvd)
	end

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
		titre_dvd : STRING
		acteurs_dvd : ARRAY[STRING]
		realisateurs_dvd : ARRAY[STRING]
		acteur_dvd : STRING
		realisateur_dvd : STRING
		annee_dvd : STRING
		type_dvd : STRING
		nombre_dvd : INTEGER
		auteur_livre : STRING
		titre_livre : STRING
		nombre_livre : INTEGER
	do
		create file.connect_to("medias.txt")
		from until file.end_of_input
		loop
			file.read_line
			line := file.last_string
			if line.has_substring("Livre") then
				is_book := True
			end
			if line.has_substring("DVD") then
				is_dvd := True
				create realisateurs_dvd.with_capacity(0,0)
				create acteurs_dvd.with_capacity(0,0)
			end
			nbr_separation_inline := line.occurrences(';')

			index_premier_point_virgule := line.index_of(';', 1)
			index_pointvirguleprecedent := index_premier_point_virgule
			premier_terme := line.substring(1, index_premier_point_virgule)

			if premier_terme.is_equal("DVD ;") then
				is_dvd := True
				from i := 1 until i > nbr_separation_inline
				loop
				  index_point_virgule_suivant := line.index_of(';', index_pointvirguleprecedent)
					terme := line.substring(index_pointvirguleprecedent, index_point_virgule_suivant)
					index_pointvirguleprecedent := index_point_virgule_suivant + 1
				  i := i+1
					-- tester chaque attribut de dvd et creer dvd
					if (terme.has_substring("Titre")) then
					  titre_dvd := terme.substring(8, terme.index_of('>', 1) - 1)
					end
					if (terme.has_substring("Annee")) then
					  annee_dvd := terme.substring(8, terme.index_of('>', 1) - 1)
					end
					if (terme.has_substring("Realisateur")) then
					  realisateur_dvd := terme.substring(14, terme.index_of('>', 1) - 1)
						realisateurs_dvd.add_last(realisateur_dvd)
					end
					if (terme.has_substring("Acteur")) then
					  acteur_dvd := terme.substring(9, terme.index_of('>', 1) - 1)
						acteurs_dvd.add_last(acteur_dvd)
					end
					if (terme.has_substring("Type")) then
					  type_dvd := terme.substring(5, terme.index_of('>', 1) - 1)
					end
					if (terme.has_substring("Nombre")) then
					  nombre_dvd := terme.substring(9, terme.index_of('>', 1) - 1).to_integer
					end
				end
				create dvd.make_dvd(titre_dvd, annee_dvd, nombre_dvd, acteurs_dvd, realisateurs_dvd, type_dvd)
				ajouter_dvd(dvd)
			end
			if premier_terme.is_equal("Livre ;") then
				is_book := True
				nombre_livre := 1
				from i := 1 until i > nbr_separation_inline
				loop
				  index_point_virgule_suivant := line.index_of(';', index_pointvirguleprecedent)
					terme := line.substring(index_pointvirguleprecedent, index_point_virgule_suivant)
					index_pointvirguleprecedent := index_point_virgule_suivant + 1
				  i := i+1
					-- tester chaque attribut de livre et creer livre
					if (terme.has_substring("Titre")) then
						titre_livre := terme.substring(8, terme.index_of('>', 1) - 1)
					end
					if (terme.has_substring("Auteur")) then
						auteur_livre := terme.substring(9, terme.index_of('>', 1) - 1)
					end
					if (terme.has_substring("Nombre")) then
					  nombre_livre := terme.substring(9, terme.index_of('>', 1) - 1).to_integer
					end
				end
				create livre.make_livre(titre_livre, auteur_livre, nombre_livre)
				ajouter_livre(livre)
			end

		end -- end loop
	end -- end readfile do

	---------------------------------------
	-- LIRE FICHIER DES UTILISATEURS
	---------------------------------------
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
      create utilisateur.make_utilisateur(nom_lu, prenom_lu, id_lu, admin_oui)
      --AJOUTER utilisateur au tableau des utilisateurs

    end
    lecteur.disconnect
  --	Result:= TRUE
  end

end -- class MEDIATHEQUE
