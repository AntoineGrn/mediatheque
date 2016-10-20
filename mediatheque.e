class MEDIATHEQUE
	--
	-- Classe décrivant la médiathèque
	--

creation {ANY}
	make

feature {}

	media: MEDIA
			-- un media

feature {ANY}
	make is
			-- Creation d'une mediatheque
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
