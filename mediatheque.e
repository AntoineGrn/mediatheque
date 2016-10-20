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
			-- Creation d'une mediatheque
		do
			-- Initialisations
      create liste_medias.with_capacity(0, 0)
      --create liste_utilisateurs.with_capacity(0,0)
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
	do
		create file.connect_to("medias.txt")
		from until file.end_of_input
		loop
			file.read_line
			line := file.last_string
			if line.has_substring("Livre") then
				is_book := True
				--create livre.with_capacity(0,0,0)
			end
			if line.has_substring("DVD") then
				is_dvd := True
				--create dvd.with_capacity(0,0,0,0,0)
			end
			nbr_separation_inline := line.occurrences(';')

			io.put_string("nombre de points virgules : " + nbr_separation_inline.to_string + "%N")
			io.put_string("ligne : " + line + "%N")
			from i := 0 until i < nbr_separation_inline + 1
			loop

			end
		end
	end

end -- class MEDIATHEQUE
