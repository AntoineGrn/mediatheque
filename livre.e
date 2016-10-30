class LIVRE
	--
	-- Classe décrivant les livres
	--

creation {ANY}
	make

feature {}


feature {ANY}
	--variables
	auteur : STRING

	make is
			-- Creation d'un livre
		do

		end

		---------------------------------------
	                --GETTER / SETTER
	  ---------------------------------------
	  get_auteur  : STRING is
	  do
	    Result := auteur
	  end

	  set_auteur(valeur: STRING) is
	  do
	    auteur.copy(auteur)
	  end

	  ---------------------------------------
	              --TO STRING
	  ---------------------------------------
	  to_string : STRING is
	  do
			io.put_string("MEDIA : %N")
	    io.put_string("Auteur : " + auteur + "%N%N")
	  end


end -- class LIVRE
