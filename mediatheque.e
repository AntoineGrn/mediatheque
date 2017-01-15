  class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}

	liste_medias: ARRAY[MEDIA] -- liste des médias
	liste_utilisateurs: ARRAY[UTILISATEUR] -- liste des utilisateurs
	liste_emprunts: ARRAY[EMPRUNT] -- liste des emprunts

feature {ANY}
	make is
		-- Initialisation des Médias et des Utilisateurs

		local
			quitter : BOOLEAN
			identifiant, action : STRING
			index, index_media_rechercher : INTEGER
			user_connected : UTILISATEUR
			connection_autorise : BOOLEAN
		do
			-- Initialisations
      create liste_medias.with_capacity(0, 0)
      create liste_utilisateurs.with_capacity(0,0)
		create liste_emprunts.with_capacity(0,0)
		--readfilemedia
		lire_fichier_utilisateurs
		--lister_medias(liste_medias)

		--Programme

		print("--------------------Bienvenue dans le logiciel de gestion de la Mediatheque-----------------%N");
			from until quitter loop
				print("Entrez votre identifiant pour pouvoir vous connecter sur l'application de gestion de la mediatheque : (q : quitter) %N")
				io.flush
				io.read_line
				identifiant := io.last_string
				--Vérification de l'existance de l'utilisateur
				from index := 0 until index > liste_utilisateurs.count-1 or quitter = True or connection_autorise = True loop
					if liste_utilisateurs.item(index).user_connection_ok(identifiant) then
						user_connected:= liste_utilisateurs.item(index)
						connection_autorise := True
					else
						connection_autorise := False
					end
					index := index + 1
				end
				if identifiant.is_equal("q") then
					print("Au revoir !%N")
					quitter := True;
				elseif connection_autorise = False then
					print("L'identifiant saisi est pas valide. Veuillez rééssayer ! %N");
					--quitter := True;
				else
                    --Si l'utilisateur connecté n'est pas un administrateur, nous importons les médias
                    if not user_connected.is_admin then
                        readfilemedia
                    end
					from until quitter loop
						print("======================================================%N")
						print("|Vous etes connecte a l'application !                |%N");
						print("|Veuillez Selectionner une action dans le menu :     |%N");
						print("|q - Quitter                                         |%N");
						if user_connected.is_admin then
							print("|1 - Importer les utilisateurs du fichier .txt       |%N");
							print("|2 - Importer les medias du fichier .txt             |%N");
							print("|4 - Lister tous les utlisateurs                     |%N");
							print("|5 - Creer un utilisateur                            |%N");
							print("|6 - Rechercher un utilisateur                       |%N");
							print("|7 - Ajouter un média                                |%N");
							print("|10 - Lister les emprunts                            |%N");
						end
							print("|3 - Lister tous les medias                          |%N");
							print("|8 - Rechercher un media                             |%N");
							print("|9 - Emprunter un media                              |%N");
							print("|11 - Lister mes emprunts                            |%N");
							print("|12 - Rendre un media                                |%N");
							print("======================================================%N");
						io.flush
						io.read_line
						action := io.last_string
						inspect
							action
						when "q" then
							quitter := True
						when "1" then
							if user_connected.is_admin then
								lire_fichier_utilisateurs
								print("Les utilisateurs ont été ajoutés à la base")
							end
						when "2" then
							if user_connected.is_admin then
								readfilemedia
							end
						when "4" then
							if user_connected.is_admin then
								lister_les_utilisateurs
							end
						when "5" then
							if user_connected.is_admin then
								creer_un_utilisateur
							end
						when "7" then
							if user_connected.is_admin then
								ajouter_media_manuellement
							end
						when "6" then
							if user_connected.is_admin then
								rechercher_utilisateur_main
							end
						when "8" then
							index_media_rechercher := rechercher_media
						when "9" then
							emprunter_media(user_connected)
						when "3" then
							lister_medias(liste_medias)
						when "10" then
							liste_emprunt
						when "11" then
							afficher_medias_emprunter_by_user(user_connected)
						when"12" then
							rendre_un_media(user_connected)
						when "13" then
							enregistrer_les_emprunts_dans_fichier
						else
							io.put_string("Fonction inexistante retour au menu %N")
						end
					end
				end
			end
		end
	-----------------------
	-- LISTER LES MEDIAS --
	-----------------------
	lister_medias (liste_all_medias : ARRAY[MEDIA]) is
	local
		index : INTEGER
		livre_media : LIVRE
		dvd_media : DVD
	do
		io.put_string("Nombre de medias listes : " + liste_medias.count.to_string + "%N")
		from index := 0 until index > liste_medias.count-1 loop
			if {LIVRE}?:= liste_medias.item(index) then
				livre_media ::= liste_medias.item(index)
				io.put_string("Media [LIVRE] n" + (index + 1).to_string + " : " + liste_medias.item(index).titre + " %N")
				io.put_string("Auteur : " + livre_media.auteur + " %N%N")
				io.put_string("Nbr exemplaire : " + livre_media.nombre.to_string + " %N%N")
			end
			if {DVD}?:= liste_medias.item(index) then
				dvd_media ::= liste_medias.item(index)
				io.put_string("Media [DVD] n" + (index + 1).to_string + " : " + liste_medias.item(index).titre + " %N")
				io.put_string("Annee : " + dvd_media.annee + " %N")
				io.put_string("Type : " + dvd_media.type + " %N%N")
				io.put_string("Nbr exemplaire : " + dvd_media.nombre.to_string + " %N%N")
			end
			index := index +1
		end
	end

	---------------------------------------
	-- AJOUTER LIVRE
	---------------------------------------
	ajouter_livre (livre : LIVRE; bool : BOOLEAN) is
	local
		index : INTEGER
		livre_liste : LIVRE
		livre_exist : BOOLEAN
		livre_recherche : LIVRE
		index_livre : INTEGER
	do
		livre_exist := True
		if liste_medias.count.is_equal(0) then
			liste_medias.add_last(livre)
			if bool then
				io.put_string("Livre ajouté avec succès %N")
			end
		else
			from index := 0 until index > liste_medias.count-1 loop
				if {LIVRE}?:= liste_medias.item(index) then
					livre_liste ::= liste_medias.item(index)
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
				if bool then
					io.put_string("Livre ajoute avec succes %N")
				end
			else
				if bool then
					index_livre := recherche_livre(livre.get_titre, livre.get_auteur, "4")
					if index_livre /= -1 then
						livre_recherche ::= liste_medias.item(index_livre)
						livre_recherche.set_nombre(livre_recherche.get_nombre + livre.get_nombre)
						io.put_string("Nous avons ajouté le nombre d'exemplaires %N")
					end
					io.put_string("Livre déjà existant %N")
				end
			end
		end
	end

	---------------------------------------
	--AJOUTER DVD
	---------------------------------------
	ajouter_dvd (dvd : DVD; bool : BOOLEAN) is
	local
		index : INTEGER
		dvd_liste: DVD
		dvd_exist : BOOLEAN
	do
		dvd_exist := False
		if liste_medias.count.is_equal(0) then
			liste_medias.add_last(dvd)
			if bool then
				io.put_string("DVD ajoute avec succes %N")
			end
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
				if bool then
					io.put_string("DVD ajoute avec succes %N")
				end
			else
				if bool then
					io.put_string("DVD deja existant %N")
				end
			end
		end
	end

	---------------------------------------
	-- RECHERCHER UN MEDIA
	---------------------------------------
	rechercher_media : INTEGER is
	local
		action_type_media : STRING
		titre_livre : STRING
		auteur_livre : STRING
		titre_dvd : STRING
		annee_dvd : STRING
		acteur : STRING
		realisateur : STRING
		type : STRING
		mode_recherche : STRING
	do
		print("Choisissez le type de média : %N")
		print("1. Livre %N")
		print("2. DVD %N")
		io.flush
		io.read_line
		action_type_media := io.last_string
		inspect
			action_type_media
		when "1" then
			type := "Livre"
		when "2" then
			type := "DVD"
		else
			io.put_string("Veuillez saisir un des choix proposés %N")
		end
		action_type_media := ""
		if type.is_equal("Livre") then
			print("Voulez-vous rechercher par : %N")
			print("1. Titre%N")
			print("2. Auteur%N")
			print("3. Titre et Auteur (recherche spécifique)%N")
			io.flush
			io.read_line
			action_type_media := io.last_string
			inspect
				action_type_media
			when "1" then
				print("Saisissez le titre du livre : %N")
				io.flush
				io.read_line
				titre_livre := ""
				titre_livre.copy(io.last_string)
				auteur_livre := ""
				mode_recherche := "1"
			when "2" then
				print("Saisissez l'auteur du livre : %N")
				io.flush
				io.read_line
				auteur_livre := ""
				auteur_livre.copy(io.last_string)
				titre_livre := ""
				mode_recherche := "2"
			when "3" then
				print("Saisissez le titre du livre : %N")
				io.flush
				io.read_line
				titre_livre := ""
				titre_livre.copy(io.last_string)
				print("Saisissez l'auteur du livre : %N")
				io.flush
				io.read_line
				auteur_livre := ""
				auteur_livre.copy(io.last_string)
				mode_recherche := "3"
			else
				io.put_string("Veuillez saisir un des choix proposés %N")
			end
			Result := recherche_livre(titre_livre, auteur_livre, mode_recherche)
		elseif type.is_equal("DVD") then
			-- saisie du titre du DVD
			print("Voulez-vous rechercher par : %N")
			print("1. Titre%N")
			print("2. Année%N")
			print("3. Acteur%N")
			print("4. Realisateur%N")
			print("5. Titre et année%N")
			io.flush
			io.read_line
			action_type_media := io.last_string
			inspect
				action_type_media
			when "1" then
				print("Saisissez le titre du DVD : %N")
				io.flush
				io.read_line
				titre_dvd := ""
				titre_dvd.copy(io.last_string)
				mode_recherche := "1"
			when "2" then
				print("Saisissez l'annee du DVD : %N")
				io.flush
				io.read_line
				annee_dvd := ""
				annee_dvd.copy(io.last_string)
				mode_recherche := "2"
			when "3" then
				print("Saisissez le nom d'un acteur : %N")
				io.flush
				io.read_line
				acteur := ""
				acteur.copy(io.last_string)
				mode_recherche := "3"
			when "4" then
				print("Saisissez le nom d'un réalisateur : %N")
				io.flush
				io.read_line
				realisateur := ""
				realisateur.copy(io.last_string)
				mode_recherche := "4"
			when "5" then
				print("Saisissez le titre du DVD : %N")
				io.flush
				io.read_line
				titre_dvd := ""
				titre_dvd.copy(io.last_string)
				-- saisie de l'annee du DVD
				print("Saisissez l'annee du DVD : %N")
				io.flush
				io.read_line
				annee_dvd := ""
				annee_dvd.copy(io.last_string)
				mode_recherche := "5"
			else
				print("Veuillez saisir un des choix proposés %N")
			end
			Result := recherche_dvd(titre_dvd, annee_dvd, acteur, realisateur, mode_recherche)
		else
			print("Veuillez saisir un type de media valide %N")
		end
	end

	---------------------------------------
	-- RECHERCHER LIVRE
	---------------------------------------
	recherche_livre(titre_livre : STRING; auteur_livre : STRING; mode_recherche : STRING) : INTEGER is
	local
		index : INTEGER
		livre_from_liste : LIVRE
		media_trouve : BOOLEAN
        retour : INTEGER
		tab : ARRAY[LIVRE]
		index_tab : STRING
	do
		create tab.with_capacity(0,0)
		media_trouve := False
		from index := 0 until index > liste_medias.count - 1 loop
			if {LIVRE}?:= liste_medias.item(index) then
				livre_from_liste ::= liste_medias.item(index)
				if mode_recherche.is_equal("1") then
					if livre_from_liste.get_titre.as_lower.has_substring(titre_livre.as_lower) then
						tab.add_last(livre_from_liste)
					end
				elseif mode_recherche.is_equal("2") then
					if livre_from_liste.get_auteur.as_lower.has_substring(auteur_livre.as_lower) then
						tab.add_last(livre_from_liste)
					end
				else
					if livre_from_liste.get_titre.as_lower.has_substring(titre_livre.as_lower) and livre_from_liste.get_auteur.as_lower.has_substring(auteur_livre.as_lower) then
						tab.add_last(livre_from_liste)
					end
				end
			end
			index := index +1
		end

		if tab.count > 1 then
			from index := 0 until index > tab.count -1 loop
				io.put_string("%NVoici la liste de(s) Livre(s) trouvé(s) !  %N")
				io.put_string("Livre N°"+index.to_string+" : %N")
				io.put_string("Titre : " + tab.item(index).titre + " %N")
				io.put_string("Auteur : " + tab.item(index).auteur + " %N%N")
				index := index + 1			
			end
			if mode_recherche.is_equal("4") then
				print("Sélectionner le livre que vous voulez ajouter : %N")
			else
				print("Veuillez sélectionner le livre qui vous intéresse %N")
			end
			io.flush
			io.read_line
			index_tab := ""
			index_tab.copy(io.last_string)
			media_trouve := True
			retour := recherche_livre_dans_medias(tab.item(index_tab.to_integer))
			print("Voici les informations détaillées du livre : %N")
			liste_medias.item(retour).to_string
		elseif tab.count = 1 then
			retour := recherche_livre_dans_medias(tab.item(0))
			print("Voici les informations détaillées du livre : %N")
			liste_medias.item(retour).to_string		
			media_trouve := True	
		else
			media_trouve := False
		end
	
		Result := retour
		if media_trouve.is_equal(False) then
			io.put_string("Aucun livre trouvé %N%N")
		end
	end
	
	recherche_livre_dans_medias(livre : LIVRE) : INTEGER is
	local
		index, resultat : INTEGER
		l : LIVRE
		trouve : BOOLEAN
	do
		trouve := False
		from index := 0 until index > liste_medias.count - 1 or trouve loop
			if {LIVRE}?:= liste_medias.item(index) then
				l ::= liste_medias.item(index)
				if l.get_titre.as_lower.is_equal(livre.get_titre.as_lower) and l.get_auteur.as_lower.is_equal(livre.get_auteur.as_lower) then
					trouve := True					
					resultat := index
				else
					resultat := -1
				end	
			end
			index := index + 1
		end
		if trouve then
			Result := resultat
		else
			Result := -1
		end
	end

	recherche_dvd_dans_medias(dvd : DVD) : INTEGER is
	local
		index, resultat : INTEGER
		l : DVD
		trouve : BOOLEAN
	do
		trouve := False
		from index := 0 until index > liste_medias.count - 1 or trouve loop
			if {DVD}?:= liste_medias.item(index) then
				l ::= liste_medias.item(index)
				if l.get_titre.as_lower.is_equal(dvd.get_titre.as_lower) and l.get_annee = dvd.get_annee then
					trouve := True					
					resultat := index
				else
					resultat := -1
				end	
			end
			index := index + 1
		end
		if trouve then
			Result := resultat
		else
			Result := -1
		end
	end

	---------------------------------------
	-- RECHERCHER DVD
	---------------------------------------
	recherche_dvd(titre_dvd : STRING; annee_dvd : STRING; acteur : STRING; realisateur : STRING; mode_recherche : STRING) : INTEGER is
	local
		index, index_realisateur, index_acteur : INTEGER
		dvd_media : DVD
		media_trouve : BOOLEAN
		retour : INTEGER
		tab : ARRAY[DVD]
		index_tab : STRING
	do
		create tab.with_capacity(0,0)
		media_trouve := False
		from index := 0 until index > liste_medias.count - 1 loop
			if {DVD}?:= liste_medias.item(index) then
				dvd_media ::= liste_medias.item(index)
				if mode_recherche.is_equal("1") then
					if dvd_media.get_titre.as_lower.has_substring(titre_dvd.as_lower) then
						tab.add_last(dvd_media)
					end
				elseif mode_recherche.is_equal("2") then
					if dvd_media.get_annee.is_equal(annee_dvd) then
						tab.add_last(dvd_media)
					end
				elseif mode_recherche.is_equal("3") then
					from index_acteur := 0 until index_acteur > dvd_media.get_acteurs.count - 1 loop
						if dvd_media.get_acteurs.item(index_acteur).as_lower.has_substring(acteur) then
							tab.add_last(dvd_media)
						end
						index_acteur := index_acteur + 1
					end
				elseif mode_recherche.is_equal("4") then
					from index_realisateur := 0 until index_realisateur > dvd_media.get_realisateurs.count - 1 loop
						if dvd_media.get_realisateurs.item(index_realisateur).as_lower.has_substring(realisateur) then
							tab.add_last(dvd_media)
						end
						index_realisateur := index_realisateur + 1
					end
				else
					if dvd_media.get_titre.as_lower.has_substring(titre_dvd.as_lower) and dvd_media.get_annee.is_equal(annee_dvd) then
						tab.add_last(dvd_media)
					end
				end
			end
			index := index +1
		end
		
		if tab.count > 1 then
			io.put_string("%NVoici la liste de(s) DVD trouvé(s) !  %N")
			from index := 0 until index > tab.count -1 loop
				io.put_string("DVD N°"+index.to_string+" : %N")
				io.put_string("Titre : " + tab.item(index).titre + " %N")
				io.put_string("Année : " + tab.item(index).annee + " %N%N")
				index := index + 1			
			end
			if mode_recherche.is_equal("6") then
				print("Sélectionner le livre que vous voulez ajouter : %N")
			else
				print("Veuillez sélectionner le livre qui vous intéresse %N")
			end
			io.flush
			io.read_line
			index_tab := ""
			index_tab.copy(io.last_string)
			media_trouve := True
			retour := recherche_dvd_dans_medias(tab.item(index_tab.to_integer))
			print("Voici les informations détaillées du DVD : %N")
			liste_medias.item(retour).to_string
		elseif tab.count = 1 then
			retour := recherche_dvd_dans_medias(tab.item(0))
			print("Voici les informations détaillées du DVD : %N")
			liste_medias.item(retour).to_string		
			media_trouve := True	
		else
			media_trouve := False
		end

		Result := retour
		if media_trouve.is_equal(False) then
			io.put_string("Aucun DVD trouvé %N%N")
		end
	end


	---------------------------------------
	-- AJOUTER UN MEDIA MANUELLEMENT
	---------------------------------------
	ajouter_media_manuellement is
	local
		type : STRING
		new_livre : LIVRE
		new_dvd : DVD
		titre_livre : STRING
		auteur_livre : STRING
		titre_dvd : STRING
		annee_dvd : STRING
		type_dvd : STRING
		realisateur_dvd : STRING
		liste_realisateur_dvd : ARRAY[STRING]
		acteur_dvd : STRING
		liste_acteur_dvd : ARRAY[STRING]
		nombre_exemplaire : STRING
		nb_ex_bis : STRING
		action_type_dvd : STRING
		action_type_media : STRING
		test_sortie_acteur : BOOLEAN
		test_sortie_realisateur : BOOLEAN
	do
		create liste_realisateur_dvd.with_capacity(0, 0)
		create liste_acteur_dvd.with_capacity(0, 0)
		print("Choisissez le type de média que vous voulez ajouter : %N")
		print("1. Livre %N")
		print("2. DVD %N")
		io.flush
		io.read_line
		action_type_media := io.last_string
		inspect
			action_type_media
		when "1" then
			type := "Livre"
		when "2" then
			type := "DVD"
		else
			io.put_string("Veuillez saisir un des choix proposés %N")
		end
		if type.is_equal("Livre") then
			print("Saisissez le titre du livre : %N")
			io.read_line
			titre_livre := ""
			titre_livre.copy(io.last_string)
			print("Saisissez l'auteur du livre : %N")
			io.read_line
			auteur_livre := ""
			auteur_livre.copy(io.last_string)
			print("Saisissez le nombre d'exemplaire ajouté : %N")
			io.read_line
			nb_ex_bis:= io.last_string
			create new_livre.make_livre(titre_livre, auteur_livre, nb_ex_bis.to_integer)
			ajouter_livre(new_livre, True)
		elseif type.is_equal("DVD") then
			-- saisie du titre du DVD
			print("Saisissez le titre du DVD : %N")
			io.flush
			io.read_line
			titre_dvd := ""
			titre_dvd.copy(io.last_string)
			-- saisie de l'annee du DVD
			print("Saisissez l'annee du DVD : %N")
			io.flush
			io.read_line
			annee_dvd := ""
			annee_dvd.copy(io.last_string)
			-- saisie du type de DVD
			print("Est ce un DVD de type coffret ? %N")
			print("1. Oui %N")
			print("2. Non %N")
			io.flush
			io.read_line
			action_type_dvd := io.last_string
			inspect
				action_type_dvd
			when "1" then
				type_dvd := "Coffret"
			when "2" then
				type_dvd := ""
			else
				io.put_string("Veuillez saisir un des choix proposés %N")
			end
			test_sortie_acteur := False
			-- saisie des acteurs du DVD
			from until test_sortie_acteur.is_equal(True) loop
				io.put_string("Veuillez saisir le nom et prenom d'un acteur puis valider une fois que tous les acteurs ont ete saisis 'v' %N")
				io.flush
				io.read_line
				if io.last_string.is_equal("v") then
					test_sortie_acteur := True
				else
					acteur_dvd := ""
					acteur_dvd.copy(io.last_string)
					liste_acteur_dvd.add_last(acteur_dvd)
				end
			end

			-- saisie des realisateurs du DVD
			test_sortie_realisateur := False
			from until test_sortie_realisateur.is_equal(True) loop
				io.put_string("Veuillez saisir le nom et prenom d'un realisateur puis valider une fois que tous les realisateurs ont ete saisis 'v' %N")
				io.flush
				io.read_line
				if io.last_string.is_equal("v") then
					test_sortie_realisateur := True
				else
					realisateur_dvd := ""
					realisateur_dvd.copy(io.last_string)
					liste_realisateur_dvd.add_last(realisateur_dvd)
				end
			end
			-- saisie du nbr de DVD voulu
			print("Saisissez le nombre d'exemplaire ajouté : %N")
			io.flush
			io.read_line
			nombre_exemplaire := io.last_string
			create new_dvd.make_dvd(titre_dvd, annee_dvd, nombre_exemplaire.to_integer, liste_acteur_dvd, liste_realisateur_dvd, type_dvd)
			ajouter_dvd(new_dvd, True)
		else
			print("Veuillez saisir un type de média valide %N")
		end
	end

	----------------------------
	--FICHIER DES MEDIAS--
	----------------------------
	readfilemedia is
  	local
		lecteur: TEXT_FILE_READ
		ligne, champ, titre_lu, nombre_lu, annee_lu, type_lu, auteur_lu, valeur, real, acteur: STRING
		mot, nb_mot, debut_champ, fin_champ: INTEGER
		livre_bool, dvd_bool: BOOLEAN
		acteurs_dvd : ARRAY[STRING]
		realisateurs_dvd : ARRAY[STRING]
		livre : LIVRE
		dvd : DVD
	do
	create lecteur.connect_to("medias.txt")
	
		from until lecteur.end_of_input loop
			lecteur.read_line
			ligne := lecteur.last_string
			nb_mot := ligne.occurrences(';')
			debut_champ := 1
			fin_champ := 0

			if(ligne.has_substring("Livre")) then
				from mot:= 0 until mot > nb_mot loop
					fin_champ := ligne.index_of(';',debut_champ)
					if fin_champ = 0 then
						fin_champ := ligne.count
					end
					nombre_lu:="1"
					if(ligne.substring(debut_champ, fin_champ).has_substring("Livre")) then
						livre_bool := True
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Titre")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						titre_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Auteur")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						auteur_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Nombre")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						nombre_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					champ := ligne.substring(debut_champ, fin_champ)
					mot := mot+1
					debut_champ := fin_champ + 1
				end
				create livre.make_livre(titre_lu, auteur_lu, nombre_lu.to_integer)
				ajouter_livre(livre, False)
			end

			if(ligne.has_substring("DVD")) then
				from mot:= 0 until mot > nb_mot loop
					fin_champ := ligne.index_of(';',debut_champ)
					if fin_champ = 0 then
						fin_champ := ligne.count
					end
					nombre_lu := "1"
					type_lu := ""
					if(ligne.substring(debut_champ, fin_champ).has_substring("DVD")) then
						dvd_bool := True
						create realisateurs_dvd.with_capacity(0,0)
						create acteurs_dvd.with_capacity(0,0)
					end				
					if(ligne.substring(debut_champ, fin_champ).has_substring("Titre")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						titre_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Annee")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						annee_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Realisateur")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						real:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
						realisateurs_dvd.add_last(real)
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Acteur")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						acteur := (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
						acteurs_dvd.add_last(acteur)
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Type")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						type_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					if(ligne.substring(debut_champ, fin_champ).has_substring("Nombre")) then
						valeur:= ligne.substring(debut_champ, fin_champ)
						nombre_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
					end
					champ := ligne.substring(debut_champ, fin_champ)
					mot := mot+1
					debut_champ := fin_champ + 1
				end
				create dvd.make_dvd(titre_lu, annee_lu, nombre_lu.to_integer, acteurs_dvd, realisateurs_dvd, type_lu)
				ajouter_dvd(dvd, False)
			end		
		end
		lecteur.disconnect
	end


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
      ajouter_un_utilisateur(utilisateur, False)
    end
    lecteur.disconnect
	end

	--------------------------
	--AJOUTER UN UTILISATEUR--
	--------------------------

	ajouter_un_utilisateur(user: UTILISATEUR; bool : BOOLEAN) is
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
				if bool then
					io.put_string("Utilisateur ajoute.%N")
				end
			else
				if bool then
					io.put_string("L'utilisateur existe deja%N")
				end
			end
		end

	---------------------------
	--LISTER LES UTILISATEURS--
	---------------------------

	lister_les_utilisateurs is
	local
		index : INTEGER
	do
		io.put_string("Nombre d'utilisateurs listes : " + liste_utilisateurs.count.to_string + "%N")
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
            reponse_ok : BOOLEAN
		do
            reponse_ok := False
			print("Entrer le nom de l'utilisateur : %N");
			io.flush
			io.read_line
			nom := ""
			nom.copy(io.last_string)
			print("Entrer le prenom de l'utilisateur : %N");
			io.flush
			io.read_line
			prenom := ""
			prenom.copy(io.last_string)
			print("Entrer l'identifiant de l'utilisateur : %N");
			io.flush
			io.read_line
			id := ""
			id.copy(io.last_string)
            from until reponse_ok loop
                print("Un administrateur ? True or False: %N");
			    io.flush
			    io.read_line
			    admini := io.last_string
                inspect
                    admini
                when "True" then
                    admin := True
                    reponse_ok := True
                when "False" then
                    admin := False
                    reponse_ok := True
                when "true" then
                    admin := True
                    reponse_ok := True
                when "false" then
                    admin := True
                    reponse_ok := True
                else 
                    print("Veuillez saisir une valeur correcte ! %N")
                end
            end
			create utilisateur.make_utilisateur(nom, prenom, id, admin);
			io.put_string(utilisateur.display_user + "%N");
			ajouter_un_utilisateur(utilisateur, True)
		end

	-----------------------------
	--RECHERCHER UN UTILISATEUR--
	-----------------------------
	rechercher_utilisateur(search: STRING) : INTEGER is
		local
			index, resultat : INTEGER
			find : BOOLEAN
		do
			find := False
			resultat := -1
			from index := 0 until index > liste_utilisateurs.count-1 or find = True loop
				if liste_utilisateurs.item(index).search_user(search) then
					resultat := index
					find := True;
				end
				index := index + 1;
			end
			Result := resultat
		end

	----------------------------------
	--RECHERCHER UN UTILISATEUR (MAIN)
	----------------------------------

	rechercher_utilisateur_main is
		local
			index_user_find : INTEGER
			action, search_user : STRING
		do
			print("Veuillez entrer l'IDENTIFIANT de l'utilisateur à rechercher %N");
			io.flush
			io.read_line
			search_user := ""
			search_user.copy(io.last_string)
			index_user_find := rechercher_utilisateur(search_user);
			if index_user_find /= -1 then
				print("Utilisateur Trouvé ! %N");
				print(liste_utilisateurs.item(index_user_find).display_user);
			else
				print("L'utilisateur n'existe pas, voulez-%
                              %vous le creer ? O/N %N");
				io.flush
				io.read_line
				action := io.last_string
				if action.is_equal("O") then
					creer_un_utilisateur
				end
			end
		end

	----------------------
	--EMPRUNTER UN MEDIA--
	----------------------
	emprunter_media(user_connected : UTILISATEUR) is
		local
			index_media, nombre_media : INTEGER
			emprunt : EMPRUNT
			--date_e, date_r : TIME
			media : MEDIA
		do
			--Rechercher un média & récupération de l'indice dans le 
			--tableau des médias
			index_media := rechercher_media
            if index_media /= -1 then 
			    --trouver le média dans le tableau 
			    media := liste_medias.item(index_media)
                if media.get_nombre > 0 then
			        create emprunt.make_emprunt(media, user_connected)
			        liste_emprunts.add_last(emprunt)
			        --on diminue le nombre d'exemplaire dispo
			        nombre_media := media.get_nombre;
			        media.set_nombre(nombre_media - 1);
			        print("Votre média a été ajouté à la liste des emprunts avec succès !%N")
                else
                    print("Veuillez nous excuser, ce média n'est plus disponnible pour le moment. %N")
                end
            end
		end

	-------------------------------
	--LISTER LES EMPRUNTS EN COURS
	-------------------------------

	liste_emprunt is
	local
		index : INTEGER
		display_msg : BOOLEAN
	do
		display_msg := True
		if liste_emprunts.count = 0 then
			io.put_string("Il n'y a pas d'emprunts en cours actuellement ! %N")
		else
			from index := 0 until index > liste_emprunts.count-1 loop
				if liste_emprunts.item(index).get_date_rendu.hash_code = 0 then
					io.put_string(liste_emprunts.item(index).afficher + "%N");
					display_msg := False
				end
				index := index +1
			end
			if display_msg then
				print("Il n'y a pas d'emprunts en cours actuellement ! %N")
			end
		end
	end

	---------------------------------------------------------
	--LISTER LES EMPRUNTS EN COURS DE L'UTILISATEUR CONNECTE
	---------------------------------------------------------
	media_emprunter_by_user(user: UTILISATEUR) : ARRAY[MEDIA] is
		local
			index : INTEGER
			identifiant_user : STRING
			user_emprunts: ARRAY[MEDIA]
		do
			create user_emprunts.with_capacity(0,0);
			from index := 0 until index > liste_emprunts.count-1 loop
				identifiant_user:= liste_emprunts.item(index).user.get_identifiant
				if identifiant_user.is_equal(user.get_identifiant) and liste_emprunts.item(index).get_date_rendu.hash_code = 0 then
					user_emprunts.add_last(liste_emprunts.item(index).media);
				end
				index := index +1
			end
			if user_emprunts.count = 0 then
				io.put_string("Vous n'avez rien emprunté !%N")
			end
			Result := user_emprunts
		end

	--------------------------------------------------
	--AFFICHER LES EMPRUNTS DE L'UTILISATEUR CONNECTE
	--------------------------------------------------

	afficher_medias_emprunter_by_user(user : UTILISATEUR) is
		local
			index: INTEGER
			user_emprunts: ARRAY[MEDIA]
		do
			create user_emprunts.with_capacity(0,0);
			user_emprunts := media_emprunter_by_user(user)
			if user_emprunts.count > 0 then
				from index := 0 until index > user_emprunts.count -1 loop
					user_emprunts.item(index).to_string;
					index := index +1
				end
			end
		end

	-----------------------------
	--RENDRE UN EMPRUNT DE MEDIA
	-----------------------------
	
	rendre_un_media(user : UTILISATEUR) is
	local
		index : INTEGER
		tab_emprunts : ARRAY[MEDIA]
		action : STRING
		valid : BOOLEAN
	do
		create tab_emprunts.with_capacity(0,0);
		valid := False
		tab_emprunts := media_emprunter_by_user(user)
		if tab_emprunts.count > 0 then
			io.put_string("Entrer le numéro du média que vous voulez rendre : %N")
			from index := 0 until index > tab_emprunts.count -1 loop
				io.put_string(index.to_string+" : ");
				io.put_string(tab_emprunts.item(index).get_titre + "%N");
				index := index +1;
			end
			from until valid loop
				io.flush
				io.read_line
				action := io.last_string
				if action.to_integer <= index then
					tab_emprunts.item(action.to_integer).rendre_media
					mettre_a_jour_date_retour(tab_emprunts.item(action.to_integer))
					valid := True
					print("Media rendu avec succès ! %N")
				else
					print("Veuillez entrer un nombre valide%N")
				end
			end
		end
	end

	-----------------------------------------------
	--METTRE A JOUR LA DATE DE RETOUR DE L'EMPRUNT
	-----------------------------------------------

	mettre_a_jour_date_retour(media:MEDIA) is
		local
			index:INTEGER
		do
			from index := 0 until index > liste_emprunts.count - 1 loop
				if media.get_titre.is_equal(liste_emprunts.item(index).media.get_titre) then
					liste_emprunts.item(index).set_date_rendu
				end
				index := index + 1
			end
		end

	------------------------------------------
	--ENREGISTRER LES EMPRUNTS DANS UN FICHIER
	------------------------------------------

	enregistrer_les_emprunts_dans_fichier is
		local
			index : INTEGER
			file : TEXT_FILE_WRITE
			ligne : STRING
			media : MEDIA
			type : STRING
			dvd : DVD
			livre : LIVRE
		do
			create file.connect_to("emprunts_save.txt")
			from index := 0 until index > liste_emprunts.count - 1 loop
				media := liste_emprunts.item(index).media
				if {LIVRE}?:= media then
					type := "Livre"
					livre ::= media
					ligne := "Type<" + type + "> ; Titre<" + media.get_titre + "> ; Auteur<" + media.get_auteur + "> ; Nombre<"+media.get_nombre+"> ; Utilisateur<" + liste_emprunts.item(index).user.get_identifiant + "> ; Date<" + liste_emprunts.item(index).get_date_emprunt.hash_code.to_string + ">"
					file.put_line(ligne)
				elseif {DVD}?:= media then
					type := "DVD"
					dvd ::= media
				end
				
				--ligne := ""
				index:= index + 1
			end
			file.disconnect
		end

	importer_emprunts is 
  	local
		lecteur: TEXT_FILE_READ
		ligne, champ, type_lu, titre_lu, utilisateur_lu, date_lu, valeur: STRING
		mot, nb_mot, debut_champ, fin_champ: INTEGER
		utilisateur: UTILISATEUR
	do
    create lecteur.connect_to("emprunts_save.txt")
    from until lecteur.end_of_input loop
		 lecteur.read_line
		 ligne := lecteur.last_string
		 nb_mot := ligne.occurrences(';')
		 debut_champ := 1
		 fin_champ := 0
		 champ := ""
		 type_lu := ""
		 titre_lu := ""
		 utilisateur_lu := ""
		 date_lu := ""
		 from mot:= 0 until mot > nb_mot loop
			 fin_champ := ligne.index_of(';',debut_champ)
			 if fin_champ = 0 then
				 fin_champ := ligne.count
			 end
			 if(ligne.substring(debut_champ, fin_champ).has_substring("Type")) then
				 valeur:= ligne.substring(debut_champ, fin_champ)
				 type_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
			 end

			 if(ligne.substring(debut_champ, fin_champ).has_substring("Titre")) then
				 valeur:= ligne.substring(debut_champ, fin_champ)
				 titre_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
			 end

			 if(ligne.substring(debut_champ, fin_champ).has_substring("Utilisateur")) then
				 valeur:= ligne.substring(debut_champ, fin_champ)
				 utilisateur_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
			 end

			 if(ligne.substring(debut_champ, fin_champ).has_substring("Date")) then
				 valeur:= ligne.substring(debut_champ, fin_champ)
				 date_lu:= (valeur.substring(valeur.first_index_of('<')+1, valeur.first_index_of('>')-1))
			 end

			 champ := ligne.substring(debut_champ, fin_champ)
			 mot := mot+1
			 debut_champ := fin_champ + 1

		 end
      --create utilisateur.make_utilisateur(nom_lu, prenom_lu, id_lu, admin_oui)
      --ajouter_un_utilisateur(utilisateur)

    end
    lecteur.disconnect
	end

end -- class MEDIATHEQUE
