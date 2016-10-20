class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}
	nb: INTEGER
			-- Taille des tours

	tower1, tower2, tower3: TOWER
	      -- Les 3 tours du jeu youpi

feature {ANY}
	make is
			-- Creation du jeu et boucle principale
		do
			io.put_string("Hauteur des tours : ")
			io.flush
			io.read_integer
			nb := io.last_integer

			create tower1.full(nb)
			create tower2.empty(nb)
			create tower3.empty(nb)
			io.put_string("Situation au depart :%N")
			print_game
			resolve(nb, tower1, tower2, tower3)
			io.put_string("Situation a la fin :%N")
			print_game
		end

end -- class MEDIATHEQUE
