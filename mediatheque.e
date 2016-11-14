class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}

	liste_medias: ARRAY[MEDIA] -- liste des médias
	liste_utilisateurs: ARRAY[UTILISATEUR] -- liste des utilisateurs
	--path_to_user_file: STRING

feature {ANY}
	make is
		-- Initialisation des Médias et des Utilisateurs

		local
			quitter : BOOLEAN
			identifiant, action : STRING
			index : INTEGER
			user_connected : UTILISATEUR
			connection_autorise : BOOLEAN
			-- Initialisation des Médias et des Utilisateurs
		do
			-- Initialisations
      create liste_medias.with_capacity(0, 0)
      create liste_utilisateurs.with_capacity(0,0)
			--readfilemedia
			lire_fichier_utilisateurs
			lister_medias(liste_medias)

		--Programme

		print("--------------------Bienvenue dans le logiciel de gestion de la Médiathèque-----------------%N");
			from until quitter loop
				print("Entrer votre identifiant pour pouvoir vous connecter sur l'application de gestion de la médiathèque : (q : quitter) %N")
				io.flush
				io.read_line
				identifiant := io.last_string
				--Vérification de l'existance de l'utilisateur
				from index := 0 until index > liste_utilisateurs.count-1 or quitter = True loop
					if liste_utilisateurs.item(index).user_connection_ok(identifiant) then
						user_connected:= liste_utilisateurs.item(index)
						connection_autorise := True
					else
						connection_autorise := False
					end
					index := index + 1
				end
				if connection_autorise = False or identifiant.is_equal("q") then
					print("L'utilisateur n'est pas valide, vous aller quitter l'application. %N");
					quitter := True;
				else
					from until quitter loop
						print("Vous êtes connecté à l'application !");
						print("Veuillez Sélectionner une action dans le menu : %N");
						print("q - quitter %N");
						print("1- Importer les utilisateurs du fichier .txt %N");
						print("2- Importer les médias du fichier .txt %N");
						print("3- Lister tous les médias %N");
						print("4- Lister tous les utlisateurs %N");
						--print("5- Créer un utilisateur %N");
						print("------------------------------------------------%N");
						io.flush
						io.read_line
						action := io.last_string
						inspect
							action
						when "q" then
							quitter := True
						when "1" then
							lire_fichier_utilisateurs
						when "2" then
							readfilemedia
						when "3" then
							lister_medias(liste_medias)
						when "4" then
							lister_les_utilisateurs
						when "5" then
							creer_un_utilisateur
						end
					end
				end
			end
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
	local
		index : INTEGER
		livre_liste : LIVRE
		livre_exist : BOOLEAN
	do
		livre_exist := True
		if liste_medias.count.is_equal(0) then
			liste_medias.add_last(livre)
			io.put_string("Livre ajouté avec succès %N")
		else
			from index := 0 until index > liste_medias.count-1 loop
				if {LIVRE}?:= liste_medias.item(index) then
					livre_liste ::= liste_medias.item(index)
					if livre.get_auteur.is_equal("Robert Jordan") then
						io.put_string("Auteur existant : " + livre_liste.get_auteur + "%N%N")
						io.put_string("Auteur a ajoute : " + livre.get_auteur + "%N%N")
					end
					if livre_liste.is_livre_exist(livre) then
						livre_exist := True
						index := liste_medias.count + 1
					else
						livre_exist := False
					end
				end
				index := index +1
			end
			if livre_exist.is_equal(False) then
				liste_medias.add_last(livre)
				io.put_string("Livre ajouté avec succès %N")
			else
				io.put_string("Livre déjà existant %N")
			end
		end
	end

	---------------------------------------
	--AJOUTER DVD
	---------------------------------------
	ajouter_dvd (dvd : DVD) is
	local
		index : INTEGER
		dvd_liste: DVD
		dvd_exist : BOOLEAN
	do
		dvd_exist := False
		if liste_medias.count.is_equal(0) then
			liste_medias.add_last(dvd)
			io.put_string("DVD ajouté avec succès %N")
		else
			from index := 0 until index > liste_medias.count-1 loop
				if {DVD}?:= liste_medias.item(index) then
					dvd_liste ::= liste_medias.item(index)
					if dvd_liste.is_dvd_exist(dvd) then
						dvd_exist := True
						index := liste_medias.count + 1
					end
				end
				index := index +1
			end
			if dvd_exist.is_equal(False) then
				liste_medias.add_last(dvd)
				io.put_string("DVD ajouté avec succès %N")
			else
				io.put_string("DVD déjà existant %N")
			end
		end
	end

	---------------------------------------
	-- LIRE FICHIER DES MEDIAS
	---------------------------------------
	readfilemedia is
	local
		file : TEXT_FILE_READ
		line : STRING
		nbr_separation_inline : INTEGER
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


			----------------------------
	      --FICHIER DES UTILISATEURS--
	      ----------------------------
	lire_fichier_utilisateurs is
  local
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
			 admin_oui := False
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
      ajouter_un_utilisateur(utilisateur)

    end
    lecteur.disconnect
		end

	--------------------------
	--AJOUTER UN UTILISATEUR--
	--------------------------

	ajouter_un_utilisateur(user: UTILISATEUR) is
		local
			index: INTEGER
			user_exist, user_find: BOOLEAN
		do
			user_find:= False
			user_exist := False
			from index := 0 until index > liste_utilisateurs.count-1 or user_find = True loop
				user_exist := liste_utilisateurs.item(index).user_exist(user)
				if (user_exist) then
					user_find := True
				end
				index := index +1
			end
			if user_find = False then
				liste_utilisateurs.add_last(user)
				io.put_string("Utilisateur ajouté.%N")
			else
				io.put_string("L'utilisateur existe déjà")
			end
		end

	---------------------------
	--LISTER LES UTILISATEURS--
	---------------------------

	lister_les_utilisateurs is
	local
		index : INTEGER
	do
		io.put_string("Nombre d'utilisateurs listés : " + liste_utilisateurs.count.to_string + "%N")
		from index := 0 until index > liste_utilisateurs.count-1 loop
			io.put_string(liste_utilisateurs.item(index).display_user + "%N");
			index := index +1
		end
	end

	------------------------
	--CREER UN UTILISATEUR--
	------------------------

	creer_un_utilisateur is
		local
			nom, prenom, id, admini : STRING
			admin : BOOLEAN
			utilisateur : UTILISATEUR
		do
			print("Entrer le nom de l'utilisateur : %N");
			io.flush
			io.read_line
			nom := io.last_string
			print("Entrer le prenom de l'utilisateur : %N");
			io.flush
			io.read_line
			prenom := io.last_string
			print("Entrer l'identifiant de l'utilisateur : %N");
			io.flush
			io.read_line
			id := io.last_string
			print("Un administrateur ? True or False: %N");
			io.flush
			io.read_line
			admini := io.last_string
			if admini.is_equal("True") or admini.is_equal("true") then
				admin := True
			else
				admin := False
			end
			io.put_string(nom);
			create utilisateur.make_utilisateur(nom, prenom, id, admin);
			io.put_string(utilisateur.display_user + "%N");
		end
			
end -- class MEDIATHEQUE
