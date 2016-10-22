class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}

	liste_medias: ARRAY[MEDIA] -- liste des médias
	--liste_utilisateurs: ARRAY[UTILISATEUR] -- liste des utilisateurs


feature {ANY}
	make is
			-- Creation du jeu et boucle principale
		do
			-- Initialisations
      create liste_medias.with_capacity(0, 0)
      --create liste_utilisateurs.with_capacity(0,0)
			readfilemedia
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
	end

end -- class MEDIATHEQUE
